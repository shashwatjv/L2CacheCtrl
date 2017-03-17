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
      foreach(this.line[i]) begin
	 if(this.line[i].chk_tag(in_tag))
	   return 1;
      end
      return 0;
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
	 ru = LRU;
	 if(this.wayCount === L2_ASSOC) begin
	    // EVICT a Line
	    this.set_evict_line(ru);
	 end

	 // now with one line evicted, get the closest WAY we can allocate

	 // If eviction was not required, continue following Allocation logic
	 // Get the closest WAY we can allocate
	 foreach(this.line[i]) begin
	    if(this.line[i].get_mesi_bits() === INV) begin
	       way = i;
	       break;
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

   function automatic void set_evict_line(TYP_RU_NUM ru_in);
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
      end 
   endfunction // set_evict_line
   
endclass // L2CSET

