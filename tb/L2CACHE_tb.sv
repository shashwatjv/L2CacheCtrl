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

`ifdef SELF_TEST
 `include `TESTFILE
`endif
   
   initial begin

      $display("\n");
      $display("\t ***********************************************************");
      $display("\t -----------------------------------------------------------");
      $display("\t |      L2 CACHE SIMULATION  ");
      $display("\t -----------------------------------------------------------");

`ifdef SELF_TEST
      // if doing self test, generate the command input file
      `FN_CMDGEN();

      $display("\t -----------------------------------------------------------");
      $display("\t |      COMPLETED COMMAND GENERATION FOR SIMULATION ");
      $display("\t -----------------------------------------------------------");
      
`endif
      // Cache Instance
      uut = new();

      //---------------------------------
      //    Open the testcase file
      //---------------------------------

      fd = $fopen(`TESTCMD,"r");
      
      if(!fd) begin
	 $display("\n\tCannot Open TestCommands file %s",`TESTCMD);
	 $finish();
      end

      //---------------------------------
      //    Parse the testcase file
      //---------------------------------

      // get the number of header lines that need to be skipped
      head = `TESTCMD_HEAD;

      while(!$feof(fd)) begin
	 if(head) begin
	    // skip the heading lines from the testcase if present
	    chk = $fgets(line,fd);
	    head--;
	    lineCount++;
	    //$display("\n \t HEAD : %s " , line);
	    
	 end else begin
	    chk = $fscanf(fd,"%d %h \n", cmd_num, pa);
	    //$display("\tCMD=%d, PA=%h",cmd_num,pa);
	    $cast(cmd, cmd_num);
	    uut.l2_command_process(cmd,pa);
	    lineCount++;
	 end
      end

      $fclose(fd);

      $display("\t -----------------------------------------------------------");
      $display("\t | Read %0d Lines from %s file",lineCount, `TESTCMD);
      $display("\t -----------------------------------------------------------");
      $display("\t |      SIMULATION COMPLETE ");
      $display("\t -----------------------------------------------------------");
      $display("\t ***********************************************************");
      
      $finish();
   end

endprogram // test
   

   
