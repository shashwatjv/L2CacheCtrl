// -------------------------------------------------------------------------
// Portland State University
// Course: ECE585
// 
// Project: L2 Cache Controller
// 
// Filename: L2CLINE.sv
// 
// Description: Defines the Single Cacheline class and its methods
// -------------------------------------------------------------------------

class L2CLINE;
   // Create a cache line of CLINE type
   CLINE myline;

   // create new function that initializes MESI state to INVALID
   function new();
      this.myline.mesi = INV;
      this.myline.ru_num = '0;
      this.myline.tag = '0;
      this.myline.data = '0;
      
   endfunction // new

   function automatic int chk_tag (TYP_TAG in_tag);
      return ( (this.myline.tag === in_tag) && (this.myline.mesi !== INV) );
   endfunction // chk_tag

   function automatic void set_tag (TYP_TAG in_tag);
      this.myline.tag = in_tag;
   endfunction // chk_tag

   function automatic TYP_TAG get_tag ();
      return this.myline.tag;
   endfunction // chk_tag

   function automatic TYP_RU_NUM get_ru_num ();
      return this.myline.ru_num;
   endfunction // get_ru_num

   function automatic void put_ru_num (TYP_RU_NUM ru_in);
      //return 0 for successful update else return -1
      if(ru_in >= L2_ASSOC) begin
	 $display("In-appropriate RU Number assignment: RU_IN=%0d",ru_in);
	 $finish();
      end 

      this.myline.ru_num = ru_in;

   endfunction // get_ru_num

   function automatic int updt_ru_num(TYP_RU_NUM in_ru, TYP_RU_COUNT in_way);
      // return 0 if we successfully update else, -1 if we under/overflow the RU_NUM

      if(in_ru >= L2_ASSOC)
	return -1;
      else begin
      // Incoming RU_NUM is the RU_NUM on which current read/write operation 
      //   is performed.
      // LRU = 0 , MRU = MAX-1
      // Algo -
      // If incoming RU_NUM is same as THIS line's num
      //     Make THIS line MOST RECENT
      // Else If THIS RU_NUM > incoming RU_NUM 
      //     Decrement THIS RU_NUM by 1
      // Else
      //     Retain THIS RU_NUM
	 if(this.myline.mesi !== INV) begin
	    if(this.myline.ru_num === in_ru)
	      this.myline.ru_num = in_way-1;
	    else if(this.myline.ru_num > in_ru)
	      this.myline.ru_num--;
	 end
	 // done updating return 0
	 return 0;
      end
   endfunction // updt_ru_num

   function automatic TYP_MESI_STATES get_mesi_bits ();
      return this.myline.mesi;
   endfunction // get_mesi_bits

   function automatic void put_mesi_inv ();
      if(this.myline.mesi === INV) begin
	 $display("Trying to Invalidate already Invalid line.");
	 $finish();
      end

      this.myline.mesi = INV;

   endfunction // get_mesi_bits

   function automatic void updt_mesi(TYP_CMD cmd, TYP_SNOOP_RESP snoop);
      // TYP_MESI_STATES {INV = 0, MOD = 1, EXCL = 2, SHRD = 3} 
      // this.myline.mesi <--- current mesi 
      // 
      // // Inputs 
      // We need snooping result from bus operation
      // Type command operation  
      // 1. TYP_CMD 
      // 2. TYP_SNOOP_RESP
      // 

      case(this.myline.mesi) 
	   INV: // Invalid
		   // SNOOPING PROCESSOR

	           // If invalid, any Snoop command keeps the line Invalid,
	           //    so there's no need of state modifications.
	     
		   //if(snoop == !HIT) begin
	 	   //   this.myline.mesi = INV; 
		   //end
		   // SNOOPING PROCESSOR
		   
		   // PROCESSOR ACCESSING MEMORY 
		   if(((cmd == RD_L1D) | (cmd == RD_L1I)) & ((snoop == HIT) | (snoop == HITM))) 
		   begin
		      this.myline.mesi = SHRD; 
		   end
		   else if(((cmd == RD_L1D) | (cmd == RD_L1I)) & !((snoop == HIT) | (snoop == HITM))) 
		   begin
		      this.myline.mesi = EXCL; 	   
		   end
		   else if(cmd == WR_L1D) begin // no need to check snoop response for writes
		      this.myline.mesi = MOD; 	   
		   end
		   // PROCESSOR ACCESSING MEMORY 

           MOD: // Modified
		   // SNOOPING PROCESSOR
		   if(cmd == SNP_RWIM) begin
		      this.myline.mesi = INV;
		   end
		   else if(cmd == SNP_RD) begin 
		      this.myline.mesi = SHRD;
		   end
		   // SNOOPING PROCESSOR
		   
		   // PROCESSOR ACCESSING MEMORY
	           // if hit and doing a rd/wr op, no need to check bus response(shouldn't have busop)
		   else if((cmd == RD_L1D) | (cmd == RD_L1I) | (cmd == WR_L1D)) begin
		       this.myline.mesi = MOD;
		   end
		   // PROCESSOR ACCESSING MEMMORY 


	   EXCL: // Excluded 
		   // SNOOPING PROCESSOR
		   if(cmd == SNP_RWIM) begin
		      this.myline.mesi = INV;  	   
		   end
		   else if(cmd == SNP_RD) begin
		      this.myline.mesi = SHRD; 
		   end
		   //SNOOPING PROCESSOR 
		   
		   // PROCESSOR ACCESSING MEMORY
		   else if((cmd == WR_L1D)) begin
		       this.myline.mesi = MOD; 
		   end
		   // PROCESSOR ACCESSING MEMORY 

	   SHRD: // Shared 
		   // SNOOPING PROCESSOR
		   if((cmd == SNP_RWIM) | (cmd ==SNP_INV)) begin
		      this.myline.mesi = INV; 
		   end
		   // SNOOPING PROCESSOR
		   
		   // PROCESSOR ACCESSING MEMORY 
		   else if(cmd == WR_L1D) begin
		       this.myline.mesi = MOD;
		   end
		   // PROCESSOR ACCESSING MEMORY
          //default:
      endcase
   endfunction // updt_mesi
   
   function automatic void print_line();
		// this.myline.mesi = INV;
		// this.myline.ru_num = '0;
        // this.myline.tag = '0;
        // this.myline.data = '0;
		$display("\t---------- Line Data ----------"); 
		$display("Tag --- %0p \n",this.myline.tag); 
		$display("LRU Num --- %0p \n",this.myline.ru_num); 
		$display("MESI State --- %0p \n",this.myline.mesi);
		$display("----------------------------------\n"); 		
   endfunction


   function automatic void put_data(BYTE din, logic [L2_LINE_ADDR-1:0] ain );
      this.myline.data[ain] = din;
   endfunction // put_data

   function automatic void put_alldata(BYTE [L2_LINE_SZ-1:0] din );
      this.myline.data = din;
   endfunction // put_data

   function automatic BYTE get_data(logic [L2_LINE_ADDR-1:0] ain);
      return this.myline.data[ain];
   endfunction // get_data
   
   function automatic BYTE [L2_LINE_SZ-1:0] get_alldata();
      return this.myline.data;
   endfunction // get_data
   
endclass // L2CLINE
