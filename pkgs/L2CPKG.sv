// -------------------------------------------------------------------------
// Portland State University
// Course: ECE585
// 
// Project: L2 Cache Controller
// 
// Filename: L2CPKG.sv
// 
// Description: Package file to declare enumerated STATE types, Parameters
// -------------------------------------------------------------------------

`ifndef CACHECTRL_PKG_DEFS_DONE

`define CACHECTRL_PKG_DEFS_DONE

`include "L2CacheCtrl_CfgDefines.svh"

package L2CPKG;

   // Parameters
   parameter NUM_PROC = `NUM_PROCESSOR;
   parameter PA_BITS = `PA_BITS;

   parameter L1_ASSOC = `L1_ASSOC;
   parameter L1_LINE_SZ = `L1_LINE_SIZE;

   parameter L2_SIZE_KB = `L2_SIZE_KB;
   parameter L2_ASSOC = `L2_ASSOC;
   parameter L2_LINE_SZ = `L2_LINE_SIZE;

   parameter L2_LRU_LENGTH = $clog2(L2_ASSOC);
   parameter L2_INDEX_LENGTH = $clog2(L2_SIZE_KB*1024) - $clog2(L2_ASSOC) - $clog2(L2_LINE_SZ);
   parameter L2_TAG_LENGTH = PA_BITS - L2_INDEX_LENGTH - $clog2(L2_LINE_SZ);
   parameter L2_LINE_ADDR = $clog2(L2_LINE_SZ);

   // Create LRU/MRU constants
   parameter LRU = 0;
   //parameter MRU = L2_ASSOC-1;
   
   // Create BYTE, other frequently used types
   typedef logic [7:0] BYTE;
   typedef logic [L2_LRU_LENGTH-1:0] TYP_RU_NUM;
   typedef logic [L2_LRU_LENGTH:0]   TYP_RU_COUNT;
   typedef logic [L2_TAG_LENGTH-1:0] TYP_TAG;
   typedef logic [PA_BITS-1:0] 	     TYP_PA;
   typedef logic [L2_LINE_ADDR-1:0]  TYP_OFST;
   typedef logic [L2_INDEX_LENGTH-1:0] TYP_INDX;
   
   // Create Enumerated MESI States
   typedef enum int {INV=0, MOD=1, EXCL=2, SHRD=3} TYP_MESI_STATES;

   // Bus Operation Types
   typedef enum int {READ=1, WRITE=2, INVALIDATE=3, RWIM=4} TYP_BUSOP;

   // Snoop Response Types
   typedef enum int {NOHIT=0, HIT=1, HITM=2} TYP_SNOOP_RESP;

   // Command Types
   typedef enum int {RD_L1D=0, WR_L1D=1, RD_L1I=2, SNP_INV=3, SNP_RD=4, SNP_WR=5, SNP_RWIM=6, CLR=8, DISP=9} TYP_CMD;

   // Define Cache-Line data structure

   typedef struct packed {
      BYTE [L2_LINE_SZ-1:0] data;
      TYP_TAG tag;
      //logic [L2_INDEX_LENGTH-1:0] indx; // probably can be removed later if not required
      TYP_MESI_STATES mesi;
      TYP_RU_NUM ru_num;
   } CLINE;

`include "L2BUSOP.sv"

endpackage

import L2CPKG::*; // import package in current scope

`endif

// -------------------------------------------------------------------------
