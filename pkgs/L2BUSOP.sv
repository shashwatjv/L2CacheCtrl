// -------------------------------------------------------------------------
// Portland State University
// Course: ECE585
// 
// Project: L2 Cache Controller
// 
// Filename: L2BUSOP.sv
// 
// Description: Collection of the Bus Operation functions
// -------------------------------------------------------------------------

function BusOperation
  (
   input TYP_PA addr,
   input TYP_BUSOP cmd,
   output TYP_SNOOP_RESP resp
   );

   begin
      if(cmd == WRITE)
	// for a write following assumption are made for L2 operation
	// 1. L2 Writes only when a cacheline is Evicted
	// 2. When L2 has sends a write only if the cache line is modified
	// 3. Adhering to MESI protocol, If a processor had L2 in Modified state,
	//     then the shared copy of all other processors should have been 
	//     evicted without modifications.
	resp = NOHIT;
      else
	$cast(resp, ($countones(addr) % 3) );
   end
endfunction // BusOperation
