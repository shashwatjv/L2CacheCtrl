// -------------------------------------------------------------------------
// Portland State University
// Course: ECE585
// 
// Project: L2 Cache Controller
// 
// Filename: L2CLINE.sv
// 
// Description: Defines the Single Cacheline class and its methods
// -------------------------------------------------------------------------

`include "L2CacheCtrl.pkg"

class L2CLINE;
   // Create a cache line of CLINE type
   CLINE myline;

   int function chk_tag (input [L2_TAG_LENGTH-1:0] in_tag);
      begin
	 return (in_tag === myline.tag);
      end
   endfunction // chk_tag

   TYP_RU_NUM function get_ru_num ();
      begin
	 return myline.ru_num;
      end
   endfunction // get_ru_num

   MESI_STATES function get_mesi_bits ();
      begin
	 return myline.mesi;
      end
   endfunction // get_mesi_bits

   int function updt_ru_num(input TYP_RU_NUM);
      // return 0 if we successfully update else, -1 if we under/overflow the RU_NUM
      begin
	 // Incoming RU_NUM is the RU_NUM on which current read/write operation 
	 //   is performed.
	 // LRU = 0 , MRU = MAX-1
	 // Algo -
	 // If incoming RU_NUM is same as THIS line's num
	 //     Make THIS line MOST RECENT
	 // Else If incoming RU_NUM > THIS RU_NUM
	 //     Decrement THIS RU_NUM by 1
	 // Else
	 //     Keep retain THIS RU_NUM
	 // TODO :: 
	 // add logic of updating the Recently Number
      end
   endfunction // updt_ru_num

   int function updt_mesi(input MESI_STATES);
      // return 0 if successfully updated the mesi bits, -1 if catch erronous state change
      begin
	 // TODO ::
      end
   endfunction // updt_mesi

   void function put_data(BYTE [L2_LINE_SZ-1:0] din);
      begin
	 myline.data = din;
      end
   endfunction // put_data

   BYTE [L2_LINE_SZ-1:0] function get_data();
      begin
	 return myline.data;
      end
   endfunction // get_data
   
endclass // L2CLINE
