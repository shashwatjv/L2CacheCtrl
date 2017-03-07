// -------------------------------------------------------------------------
// Portland State University
// Course: ECE585
// 
// Project: L2 Cache Controller
// 
// Filename: L2CSET.sv
// 
// Description: Defines the Single Set class and its methods.
//                 The single set consists of N cachelines where N 
//                 corresponds to Set N Associativity
// -------------------------------------------------------------------------

`include "L2CPKG.sv"

class L2CSET;
   // Create a cache line of CLINE type
   CSET myset;

endclass // L2CSET

