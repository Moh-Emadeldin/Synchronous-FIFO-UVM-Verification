package fifo_test_pkg ;
import uvm_pkg ::* ;
`include "uvm_macros.svh"

import fifo_env_pkg ::* ;
import fifo_config_pkg::* ;
import fifo_sequence_pkg ::* ;

  class fifo_test extends uvm_test ;
    `uvm_component_utils(fifo_test)

    fifo_env env ;
    fifo_config_obj fifo_cfg ;
    virtual fifo_if fifo_vif ;
    fifo_reset_sequence reset_seq ;
    fifo_main_sequence main_seq ;
    fifo_read_only_sequence read_only_seq ;
    fifo_write_only_sequence write_only_seq ;

    function new (string name = "fifo_test" , uvm_component parent = null) ;
      super.new(name , parent);
    endfunction

    function void build_phase (uvm_phase phase) ;
      super.build_phase(phase);
      env = fifo_env::type_id::create("env",this);
      fifo_cfg = fifo_config_obj::type_id::create("fifo_cfg");

      reset_seq = fifo_reset_sequence::type_id::create("reset_seq");
      main_seq = fifo_main_sequence::type_id::create("main_seq");
      read_only_seq = fifo_read_only_sequence::type_id::create("read_only_seq");
      write_only_seq = fifo_write_only_sequence::type_id::create("write_only_seq");
      
    if (!uvm_config_db#(virtual fifo_if)::get(this,"","FIFO_IF",fifo_cfg.fifo_vif))
    `uvm_fatal("build_phase","Test - Unable to get the virtual interface")

    uvm_config_db#(fifo_config_obj)::set(this,"*","CFG",fifo_cfg);

    endfunction

    task run_phase (uvm_phase phase) ;
      super.run_phase(phase);
      phase.raise_objection(this);
      `uvm_info("run_phase","Reset Asserted",UVM_LOW)
      reset_seq.start(env.agt.sqr);
      `uvm_info("run_phase","Reset Deasserted" , UVM_LOW)
      `uvm_info("run_phase","Write only Sequence  Started", UVM_LOW)
      write_only_seq.start(env.agt.sqr);
      `uvm_info("run_phase","Write only Sequence Ended", UVM_LOW)
      `uvm_info("run_phase","Read only Sequence  Started", UVM_LOW)
      read_only_seq.start(env.agt.sqr);
      `uvm_info("run_phase","Read only Sequence Ended", UVM_LOW)
      `uvm_info("run_phase","Main Sequence   Started", UVM_LOW)
      main_seq.start(env.agt.sqr);
      `uvm_info("run_phase","Main Sequence Ended", UVM_LOW)
      phase.drop_objection(this);
      
    endtask

  endclass

endpackage