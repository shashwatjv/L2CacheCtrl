// -------------------------------------------------------------------------
// Portland State University
// Course: ECE585
// 
// Project: L2 Cache Controller
// 
// Filename: L2CACHE_DEFS.svh
// 
// Description: Defines to set various sub-fields for given address
// -------------------------------------------------------------------------

`define L2OFST_BITS 0+:L2_LINE_ADDR
`define L2INDX_BITS L2_LINE_ADDR+:L2_INDEX_LENGTH
`define L2TAG_BITS (L2_LINE_ADDR+L2_INDEX_LENGTH)+:L2_TAG_LENGTH
