// -------------------------------------------------------------------------
// Portland State University
// Course: ECE585
// 
// Project: L2 Cache Controller
// 
// Filename: L2CADDRGEN.sv
// 
// Description: This file contains logic to generate address and command for
//               verification of the Cache Controller
// -------------------------------------------------------------------------

function void `FN_CMDGEN;

   TYP_PA pa;
   TYP_CMD cmd;

   int i,j,t;
   
   int fd;

   TYP_INDX indx;
   TYP_OFST ofst;
   TYP_TAG tag[*];
   
   begin

      //---------------------------------
      //    Open the file to generate addresses
      //---------------------------------
      
      fd = $fopen(`TESTCMD,"w");
	 
      if(!fd) begin
	 $display("\n\tCannot open file %s to print commands\n",`TESTCMD);
	 $finish();
      end
      
      // Addresses to check the LRU logic
      $cast(indx,$random());
      
      for(i=0;i<L2_ASSOC;i++) begin
	 $cast(tag[i], i);
      end

      // loop to generate N Read commands
      for(i=0; i < `T_LRU_CMD; i++) begin
	 for(j=0;j < L2_ASSOC; j++) begin
	    ofst = $random() % L2_LINE_SZ;
	    pa = { >> {tag[j], indx, ofst} };
            $cast(t,RD_L1I);
	    $fdisplay(fd,"%0d %x ",t, pa);
            $cast(t,DISP);
	    $fdisplay(fd,"%0d %x ",t, pa);
         end
      end

      $fclose(fd);
      
   end
   
endfunction
   
