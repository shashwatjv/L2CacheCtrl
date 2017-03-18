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

`include "L2CLINE.sv"

`include "L2CSET.sv"

`include "L2CACHE.sv"

module test;

   TYP_PA pa;
   TYP_CMD cmd;

   L2CACHE uut;

initial begin
   uut = new();

   pa = 'h5500;
   $cast(cmd, 0);
   uut.l2_command_process(cmd,pa);
   $cast(cmd, 9);
   uut.l2_command_process(cmd,pa);

   $cast(cmd, 8);
   uut.l2_command_process(cmd,pa);
   for(int i=0;i<13;i++) begin
      pa = i*2;
      $cast(cmd, 0);
      uut.l2_command_process(cmd,pa);
   end
   
   $cast(cmd, 9);
   uut.l2_command_process(cmd,pa);

	     
   $finish();
   end

endmodule // test
   

   
