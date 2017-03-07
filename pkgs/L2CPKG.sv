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

// Create BYTE, other frequently used types
typedef logic [7:0] BYTE;
typedef logic [L2_LRU_LENGTH-1:0] TYP_RU_NUM;
typedef logic [L2_TAG_LENGTH-1:0] TYP_TAG;

// Create Enumerated MESI States
typedef enum logic [1:0] {INV=0, MOD=1, EXCL=2, SHRD=3} MESI_STATES;

// Bus Operation Types
typedef enum {READ=1, WRITE=2, INVALIDATE=3, RWIM=4} BUS_OP;

// Snoop Response Types
typedef enum {NOTHIT=0, HIT=1, HITM=2} SNOOP_RESP;

// Define Cache-Line data structure

typedef struct packed {
   BYTE [L2_LINE_SZ-1:0] data;
   TYP_TAG tag;
   logic [L2_INDEX_LENGTH-1:0] indx; // probably can be removed later if not required
   MESI_STATES mesi;
   TYP_RU_NUM ru_num;
} CLINE;

typedef struct packed {
   CLINE [L2_ASSOC-1:0] line;
} CSET;

endpackage

import L2CacheCtrl_pkg::*; // import package in current scope

`endif

// -------------------------------------------------------------------------