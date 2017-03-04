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

   function automatic int chk_tag (input [L2_TAG_LENGTH-1:0] in_tag);
      return (in_tag === this.myline.tag);
   endfunction // chk_tag

   function automatic TYP_RU_NUM get_ru_num ();
      return this.myline.ru_num;
   endfunction // get_ru_num

   function automatic MESI_STATES get_mesi_bits ();
      return this.myline.mesi;
   endfunction // get_mesi_bits

   function automatic int updt_ru_num(input TYP_RU_NUM in_ru);
      // return 0 if we successfully update else, -1 if we under/overflow the RU_NUM

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
   endfunction // updt_ru_num

   function automatic int updt_mesi(input MESI_STATES in_mesi);
      // return 0 if successfully updated the mesi bits, -1 if catch erronous state change
      // TODO ::
   endfunction // updt_mesi

   function automatic void put_data(BYTE [L2_LINE_SZ-1:0] din);
      this.myline.data = din;
   endfunction // put_data

   function automatic BYTE [L2_LINE_SZ-1:0] get_data();
      return this.myline.data;
   endfunction // get_data
   
endclass // L2CLINE
