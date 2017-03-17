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

   