// -------------------------------------------------------------------------
// Portland State University
// Course: ECE585
// 
// Project: L2 Cache Controller
// 
// Filename: L2CACHE_tb.sv
// 
// Description: Testbench for the Cache Controller.
//               Reads a TESTCASE file and processes the entries.
//               Command Text Format
//                     <SOL>CMD_NUM<WHITESPACE>HEX_ADDR<WHITESPACE><NEWLINE>
//               Eg.        2 123456
//                          5 789ABC
//                          1 DEF012
// -------------------------------------------------------------------------

`include "L2CPKG.sv"

`include "L2CLINE.sv"

`include "L2CSET.sv"

`include "L2CACHE.sv"

program test;

   TYP_PA pa;
   TYP_CMD cmd;

   L2CACHE uut;
   int fd;
   int head;
   string line;
   int 	  cmd_num;
   longint lineCount;
   int chk;

   initial begin

      // Cache Instance
      uut = new();

      //---------------------------------
      //    Open the testcase file
      //---------------------------------

      fd = $fopen(`TESTCASE_FILE,"r");
      
      if(!fd) begin
	 $display("Cannot Open TestCase file %s",`TESTCASE_FILE);
	 $finish();
      end

      //---------------------------------
      //    Parse the testcase file
      //---------------------------------

      // get the number of header lines that need to be skipped
      head = `TESTCASE_HEAD_LINE;

      while(!$feof(fd)) begin
	 if(head) begin
	    // skip the heading lines from the testcase if present
	    chk = $fgets(line,fd);
	    head--;
	    lineCount++;
	 end else begin
	    chk = $fscanf(fd,"%d %h \n", cmd_num, pa);
	    //$display("CMD=%d, PA=%h",cmd_num,pa);
	    $cast(cmd, cmd_num);
	    uut.l2_command_process(cmd,pa);
	    lineCount++;
	 end
      end

      $fclose(fd);

      $display("\t -----------------------------------------------------------");
      $display("\t | Read %0d Lines from %s file",lineCount, `TESTCASE_FILE);
      $display("\t -----------------------------------------------------------");
      $display("\t |      SIMULATION COMPLETE ");
      $display("\t -----------------------------------------------------------");
      
      $finish();
   end

endprogram // test
   

   
