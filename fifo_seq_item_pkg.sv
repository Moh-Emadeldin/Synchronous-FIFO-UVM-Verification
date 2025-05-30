package fifo_seq_item_pkg ;
import uvm_pkg ::*;
`include "uvm_macros.svh"

class fifo_seq_item extends uvm_sequence_item ;
`uvm_object_utils(fifo_seq_item)

  rand bit rst_n, wr_en, rd_en; 
  rand logic [15:0] data_in; 

  logic [15:0] data_out;
  bit  wr_ack, overflow;
  bit full, empty, almostfull, almostempty, underflow;

  int RD_EN_ON_DIST = 70 ;
  int WR_EN_ON_DIST = 70;

  function new (string name = "fifo_seq_item");
    super.new(name) ;
  endfunction

  function string convert2string();
    return $sformatf("%s rst_n =0b%0b , wr_en =0b%0b , 
    rd_en =0b%0b ,data_in = 0b%0b,
     wr_ack =0b%0b , overflow =0b%0b , underflow =0b%0b ,
     full =0b%0b , empty =0b%0b , almostfull =0b%0b , 
     almostempty =0b%0b , data_out = 0h%0h "
     ,super.convert2string(),
    rst_n,wr_en,rd_en,data_in,wr_ack,overflow,underflow,
    full,empty,almostfull,almostempty,
    data_out);
    endfunction

    function string convert2string_stimulus();
    return $sformatf("  rst_n =0b%0b , wr_en =0b%0b , 
    rd_en =0b%0b ,data_in = 0b%0b  "
    ,rst_n,wr_en,rd_en,data_in);
    endfunction

  // Constrain blocks : 
  constraint rst_n_c { rst_n dist {0:/10 , 1:/90};}
  constraint wr_en_c { wr_en dist {0:/(100-WR_EN_ON_DIST) 
  , 1:/WR_EN_ON_DIST};}
  constraint rd_en_c { rd_en dist {0:/(100-RD_EN_ON_DIST) 
  , 1:/RD_EN_ON_DIST};}
  constraint data_in_c {
    data_in dist {
      {16{1'b0}}           := 10, // All zeros
      {16{1'b1}}           := 10, // All ones
      {8{2'b10}}    := 10, // Alternating 1/0 
      {8{2'b01}}    := 10, // Alternating 0/1 
      1                            := 5, // LSB only
      1 << (15)          := 5, // MSB only
      [16'h0002:16'hFFFE]                      := 50  // Rest of the values
    };
  }

endclass
endpackage