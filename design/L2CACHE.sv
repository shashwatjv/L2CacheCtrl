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

   longint reads, writes, misses, hits, HIT, HITM,snoop_count;

   function automatic void l2_command_process(TYP_CMD cmd_in, TYP_PA pa_in);
      TYP_INDX set;
      int  indx;
      bit  cpu, snp;
      int  hit;
      int  resp; 
      begin

		set = pa_in >> L2_LINE_ADDR; // shifting by offset bits gets us to Index bits
		$cast(indx,set);
		
		// CPU and Snoop commands 
		cpu = (cmd_in == RD_L1D) || (cmd_in == WR_L1D) || (cmd_in == RD_L1I);
		snp = !cpu && !( (cmd_in == DISP) || (cmd_in == CLR) );

		// Create the Cache Set if not present
		if(!cache.exists(indx)) begin
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
	 // USED FOR SNOOP STATS 
	 if(snp) begin
	    resp = cache[indx].set_process_snoop(cmd_in, pa_in);
	    snoop_count++; 
	    if(resp == 0) begin 
			HITM++; 
		end 
		else begin
			HIT++; 
	    end 
	 end
	
	 if(cmd_in == DISP) begin

	        $display("\t -----------------------------------------------------------");
	        $display("\t |      STATISTICS FOR L2 CACHE CONTROLLER SIMULATION");
	        $display("\t -----------------------------------------------------------");
	    
		foreach (cache[i]) begin 
			cache[i].set_print(); //Print Contents - Tags, Data, LRU, MESI State, Capture Statistics 
		end
	        $display("\t -----------------------------------------------------------");
		$display("\t | HITS   --- %0d ",hits);
		$display("\t | MISSES --- %0d ",misses); 
		$display("\t | READS  --- %0d ",reads); 
		$display("\t | WRITES --- %0d ",writes);
		$display("\t | RATIO  --- %0.2f%%",(hits*100.0)/(reads+writes));
	        $display("\t -----------------------------------------------------------");
		$display("\t |    STATS FOR SNOOP RESULTS                              |");
		$display("\t -----------------------------------------------------------"); 
		$display("\t | SNOOP HIT --- %0d",HIT); 
		$display("\t | SNOOP HITM --- %0d",HITM); 
		$display("\t | SNOOP RATIO --- %0.2f%%",(HIT*100)/(snoop_count)); 
		$display("\t -----------------------------------------------------------");
	        $display("\n");
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
      end
    endfunction // l2_command_process
 endclass 
