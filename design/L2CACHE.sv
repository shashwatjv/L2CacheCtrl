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
		
		// CPU and Snoop commands 
		cpu = (cmd_in == RD_L1D) || (cmd_in == WR_L1D) || (cmd_in == RD_L1I);
		snp = !cpu && !( (cmd_in == DISP) || (cmd_in == CLR) );

		// Create the Cache Set if not present
		if(cache[indx] == null) begin
		   cache[indx] = new(indx);
		end		

		//----------------------------------------------------------
		//              CPU Command Processing
		//----------------------------------------------------------
		if(cpu)begin 	
			// Pass the command to particular Cache Set function
			hit = cache[indx].set_process_cpucmd(cmd_in, pa_in);
			if(hit) hits++;
			else misses++;
			
			// Number of Reads 
			if(cmd_in == RD_L1D || cmd_in == RD_L1I) reads++;
			
			// Number of writes 
			if(cmd_in == WR_L1D) writes++;
		end
	 
	 //----------------------------------------------------------
	 //              Snoop Command Processing
	 //----------------------------------------------------------
	 
	 // STILL UNDER CONSIDERATION --- PENDING 
	 // USED FOR SNOOP STATS 
	 if(snp) begin
	    resp = cache[index].set_process_snoop(cmd_in, pa_in);
	    cache[index].mesibit; 
		if(mesibit == invalid) begin 
			misses++; 
		end 
		else begin
			hits++; 
		end 
	 end
	 
	 if(cmd_in == DISP) begin
		foreach chache[i] begin 
			cache[i].setprint; //Print Contents - Tags, Data, LRU, MESI State, Capture Statistics 
		end
		$display("------------ STATS -----------\n"); 
		$display("No. of Hits --- %0lu\n",hits);
		$display("No. of Misses --- %0lu\n",misses); 
		$display("No. of Read --- %0lu\n",reads); 
		$display("No. of Writes --- %0lu\n",writes);
		$display("--------------------------------"); 		
	 end 
	 
	// Clear command is called we clear the stats and the objects 
	if(cmd_in == CLR) begin
		// Clear the Stats 
		reads = '0; 
		writes = '0; 
		misses = '0; 
		hits = '0;
		 
		// Remove Cache elements   
		cache.delete; //remove all entries from the associative array cache
	end  		 
 
	endfunction // l2_command_process
 endclass 