package fifo_config_pkg ;
import uvm_pkg ::*;
`include "uvm_macros.svh"

class fifo_config_obj extends uvm_object ;
  `uvm_object_utils(fifo_config_obj)

  virtual fifo_if fifo_vif ;
  function new(string name = "fifo_config_obj");
  super.new(name);
  endfunction

endclass
endpackage