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

function void BusOperation
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
      else if(cmd == INVALIDATE)
	// for a INVALIDATE command cannot expect to get HITM
	$cast(resp, ($countones(addr) % 2) ); // 2 because of current Snoop Response encoding
      else
	$cast(resp, ($countones(addr) % 3) ); // 3 because of current Snoop Response encoding
   end
endfunction // BusOperation

function void L1Notify_L2Evict
  (
   input TYP_PA addr
   );
   begin
      // This Function Notifies L1 to evict the cachline evicted by L2
      // Assumptions:
      // 1. L2 notofies exact PA it evicted
      // 2. L1 had knowledge of Cacheline Size of L2
      //      Knowing (L2CacheLineSize/L1CacheLineSize) determines 
      //      the number of Cache lines to be evicted by L1
      $display(" L2 Notification -> Evicted Address : 0x%0x " , addr);
   end
endfunction // L1Notify_L2Evict
