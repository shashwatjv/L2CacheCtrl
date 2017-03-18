// -------------------------------------------------------------------------
// Portland State University
// Course: ECE585
// 
// Project: L2 Cache Controller
// 
// Filename: L2CACHE.sv
// 
// Description: L2 Cache - Implemented as associative array of pointers
//                           to SETs within cache
// -------------------------------------------------------------------------

`include "L2CPKG.sv"

class L2CACHE;
   L2CSET cache[int];

   longint reads, writes, misses, hits;

   function automatic l2_command_process(TYP_CMD cmd_in, TYP_PA pa_in);
      TYP_INDX set;
      int  indx;
      bit  cpu, snp;
      int  hit;
      
      begin
	 set = pa_in >> L2_LINE_ADDR; // shifting by offset bits gets us to Index bits
	 $cast(indx,set);
	
	 cpu = (cmd_in == RD_L1D) || (cmd_in == WR_L1D) || (cmd_in == RD_L1I);
	 snp = !cpu && !( (cmd_in == DISP) || (cmd_in == CLR) );

	 //----------------------------------------------------------
	 //              CPU Command Processing
	 //----------------------------------------------------------
	 
	 if(cpu) do_cpu_cmd(indx, cmd_in, pa_in);

	 if(snp) do_snoop_cmd(indx, cmd_in, pa_in);

	 if(cmd_in == CLR) begin
	    
	 end
	 
	    
	    // Create the Cache Set if not present
	    if(cache[indx] == null) begin
	       cache[indx] = new(indx);
	    end

	    // Pass the command to particular Cache Set function
	    hit = cache[indx].set_process_cpucmd(cmd_in, pa_in);
	    if(hit) hits++;
	    else misses++;
	    
	    if(cmd_in == RD_L1D || cmd_in == RD_L1I) reads++;
	    if(cmd_in == WR_L1D) writes++;
	 end
	 
	 //----------------------------------------------------------
	 //              Snoop Command Processing
	 //----------------------------------------------------------
	 if(snp) begin
	    if(
	 end
		 
	    
 
      end
   endfunction // l2_command_process
   