package fifo_sequence_pkg ;
import uvm_pkg ::*;
`include "uvm_macros.svh"

import fifo_seq_item_pkg ::*;

class fifo_reset_sequence extends uvm_sequence#(fifo_seq_item) ;
`uvm_object_utils(fifo_reset_sequence)
  fifo_seq_item seq_item ;

  function new (string name ="fifo_reset_sequence");
    super.new(name);
  endfunction

  task body ;
    seq_item  = fifo_seq_item::type_id::create("seq_item");
    start_item(seq_item);
    seq_item.rst_n = 0 ;
    seq_item.wr_en = 0 ;
    seq_item.rd_en = 0 ;
    seq_item.data_in = 0 ;
    finish_item(seq_item);
  endtask

endclass //fifo_reset_sequence

class fifo_write_only_sequence extends uvm_sequence#(fifo_seq_item) ;
`uvm_object_utils(fifo_write_only_sequence)

  fifo_seq_item seq_item ;

  function new (string name ="fifo_write_only_sequence");
    super.new(name);
  endfunction

  task body ;
    seq_item  = fifo_seq_item::type_id::create("seq_item");
    repeat (100) begin
    start_item(seq_item);
    seq_item.wr_en = 1 ;
    seq_item.rd_en = 0 ;
    seq_item.rst_n = 1 ;
    seq_item.rst_n.rand_mode(0);
    seq_item.wr_en.rand_mode(0);
    seq_item.rd_en.rand_mode(0);
    assert(seq_item.randomize())
    finish_item(seq_item);
    end
  endtask

endclass //fifo_write_only_sequence 

class fifo_read_only_sequence extends uvm_sequence#(fifo_seq_item) ;
`uvm_object_utils(fifo_read_only_sequence)
  fifo_seq_item seq_item ;

  function new (string name ="fifo_read_only_sequence");
    super.new(name);
  endfunction

  task body ;
    seq_item  = fifo_seq_item::type_id::create("seq_item");
    repeat (100) begin
    start_item(seq_item);
    seq_item.wr_en = 0 ;
    seq_item.rd_en = 1 ;
    seq_item.rst_n = 1 ;
    assert(seq_item.randomize(data_in))
    finish_item(seq_item);
    end
  endtask

endclass //fifo_read_only_sequence

class fifo_main_sequence extends uvm_sequence#(fifo_seq_item) ;
`uvm_object_utils(fifo_main_sequence)
  fifo_seq_item seq_item ;

  function new (string name ="fifo_main_sequence");
    super.new(name);
  endfunction

  task body ;
    seq_item  = fifo_seq_item::type_id::create("seq_item");
    repeat (1000) begin
    start_item(seq_item);
    assert(seq_item.randomize())
    finish_item(seq_item);
    end
  endtask

endclass //fifo_main_sequence

endpackage