// -------------------------------------------------------------------------
// Portland State University
// Course: ECE585
// 
// Project: L2 Cache Controller
// 
// Filename: L2CSET.sv
// 
// Description: Defines the Single Set class and its methods.
//                 The single set consists of N cachelines where N 
//                 corresponds to Set N Associativity
// -------------------------------------------------------------------------

`include "L2CACHE_DEFS.svh"

`include "L2CPKG.sv"
`include "L2CLINE.sv"

class L2CSET;
   // Create a cache line of CLINE type
   L2CLINE line[L2_ASSOC] ;

   // index holds the INDEX of the set within the cache
   TYP_INDX index;
   
   // count from 0 to MAX_ASSOC ( 0 to 2/4/8 ...)
   TYP_RU_COUNT wayCount;

   // create new function to initialize wayCount to 0
   function new(int num);
      this.wayCount = 0;
      this.index = num;
      foreach (this.line[i]) this.line[i] = new();
   endfunction // new

   // function to check the precense of TAG in one of the lines
   function automatic int set_chk_tag(TYP_TAG in_tag);
      // return the WAY on which got the TAG match
      foreach(this.line[i]) begin
	 if(this.line[i].chk_tag(in_tag))
	   return i;
      end
      return -1;
   endfunction // set_chk_tag

   // function to allocate a cacheline
   // returns the WAY allocated 
   function automatic int set_alloc_line();
      int way;
      TYP_RU_NUM ru;
      begin
      // algo.
      // 1. check waycount
      //     if not MAX setup new line
      // 2. if MAX associativity occupied
      // 
      //
	 if(this.wayCount === L2_ASSOC) begin
	    // Have all WAYs occupied, EVICT a Line
	    ru = LRU;
	    way = this.set_evict_line(ru);
	 end else begin
	    // not all WAYs are occupied, just allocate a new line

	    // Get the closest WAY we can allocate
	    foreach(this.line[i]) begin
	       if(this.line[i].get_mesi_bits() === INV) begin
		  way = i;
		  break;
	       end
	    end
	 end

	 $cast(ru,this.wayCount);
	 this.line[way].put_ru_num(ru);

	 // done allocating new line and updating the RU for new allocated line
	 // so, increment the wayCount
	 this.wayCount++;

	 return way;
      end
   endfunction // set_alloc_line
   
   function automatic void set_updt_ru( TYP_RU_NUM ru_in);
      int c;
      begin
	 foreach (this.line[i]) begin
	    c = this.line[i].updt_ru_num(ru_in,this.wayCount);
	    if(c) begin
	       $display("Update LRU Failed RU-IN : %0d", ru_in);
	       $finish();
	    end
	 end
      end
   endfunction // updt_lru

   function automatic int set_evict_line(TYP_RU_NUM ru_in);
      int way;
      TYP_PA pa;
      TYP_BUSOP busop;
      TYP_SNOOP_RESP resp;
      begin

	 // get the WAY for LRU line
	 foreach(this.line[i]) begin
	    if(this.line[i].get_ru_num() === ru_in) begin
	       way = i;
	       break;
	    end
	 end
	 
	 // got the LRU line
	 // evict the line if not modified, else writeback
	 if(this.line[way].get_mesi_bits() === MOD) begin
	    // write back to next level of memory hierarchy
	    pa = { >> {this.line[way].get_tag(), this.index, {L2_LINE_ADDR{1'b0}} } };
            busop = WRITE;

            BusOperation(pa, busop, resp);
            assert(resp==NOHIT); // for L2 eviction never expect HIT/HITM

            // notify L1 about eviction in L2
            L1Notify_L2Evict(pa);
	 end

	 // update RU for cache lines such that RU is reduced by 1 respectively
	 this.set_updt_ru(ru_in);
	 
	 // invalidate the line
	 this.line[way].put_mesi_inv();
	 
	 this.wayCount--;

	 return way;
	 
      end 
   endfunction // set_evict_line

   function automatic int set_process_cpucmd(TYP_CMD cmd_in, TYP_PA pa_in);
      // return 1 indicate HIT, 0 indicates a miss for current command
      TYP_TAG curr_tag;
      int way, hit;
      TYP_SNOOP_RESP resp;
      TYP_BUSOP busop;
      TYP_RU_NUM curr_ru;
      
      begin
	 // get the TAG bits from PA
	 curr_tag = pa_in >> (L2_LINE_ADDR+L2_INDEX_LENGTH);

	 // check if current TAG already present in one of Valid lines
	 way = this.set_chk_tag(curr_tag);
	 if(way == -1) begin

	    hit = 0; //set the return value
	    
	    // didn't get a hit on TAG check, need to allocate a new line
	    way = this.set_alloc_line();
	    this.line[way].set_tag(curr_tag);

	    // with Line allocated, get the relevant data in from the next memory hierarchy
	    if(cmd_in == RD_L1D || cmd_in == RD_L1I) busop = READ;
	    else if(cmd_in == WR_L1D) busop = RWIM;
	    
            BusOperation(pa_in, busop, resp);

	    // Put the Data into the Cacheline ----- Stub Here
	    
	    // assign the MESI state based on BusOp response
	    this.line[way].updt_mesi(cmd_in, resp);
	 end else begin

	    hit = 1; //set the return value
	    
	    // if we did get a HIT of TAG match,
	    // hit has the value of the way that matched the tag
	    curr_ru = this.line[hit].get_ru_num();

	    // Update the RU for all other Ways in current set
	    this.set_updt_ru(curr_ru);
	 end

	 // Do the Actual CPU Rd/Wr on the Cachline : Stub Here

	 return hit;
	 
      end
   endfunction // set_process_cpucmd

   function automatic TYP_SNOOP_RESP set_process_snoop(TYP_CMD cmd_in, TYP_PA pa_in);
      int way;
      TYP_TAG curr_tag;
      TYP_MESI_STATES curr_mesi;
      
      begin

	 // get the TAG from the PA
	 curr_tag = pa_in >> (L2_LINE_ADDR+L2_INDEX_LENGTH);

	 // check if we have the TAG in the cache line
	 way =  this.set_chk_tag(curr_tag);

	 if(way == -1)
	   return NOHIT;
	 else begin
	    curr_mesi = this.line[way].get_mesi_bits();
	    if(curr_mesi == MOD)
	      return HITM;
	    else if(curr_mesi == EXCL || curr_mesi == SHRD)
	      return HIT;
	    else begin
	       $display("Unexpected MESI state : %s", curr_mesi);
	       $finish();
	    end
	 end
      end
   endfunction // set_process_snoop
   
endclass // L2CSET

