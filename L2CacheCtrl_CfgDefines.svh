// -------------------------------------------------------------------------
// Portland State University
// Course: ECE585
// 
// Project: L2 Cache Controller
// 
// Filename: L2CacheCtrl_CfgDefines.svh
// 
// Description: Configuration Defines set to pass parameterized values
// -------------------------------------------------------------------------

`ifndef L2CACHE_DEFS_DONE

`define L2CACHE_DEFS_DONE

`define NUM_PROCESSOR 4
`define PA_BITS 40

`define L1_ASSOC 4
`define L1_LINE_SIZE 32

`define L2_SIZE_KB 8192
`define L2_ASSOC 4
`define L2_LINE_SIZE 64

//-------------------------------------------------------
//    Defines to Configure the Test address generator

`define TESTCMD_HEAD 0

//`define SELF_TEST

`ifdef SELF_TEST

`define FN_CMDGEN L2CMDGEN

`define TESTFILE "L2CADDRGEN.sv"

`define TESTCMD "LRU_CHECK"
`define TESTCMD_HEAD 0

`define T_LRU_CMD 3
`endif

`endif
