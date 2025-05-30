package fifo_coverage_collector_pkg ;
import uvm_pkg ::*;
`include "uvm_macros.svh"

import fifo_seq_item_pkg ::*;

class fifo_coverage extends uvm_component ;
`uvm_component_utils(fifo_coverage)
uvm_analysis_export #(fifo_seq_item) cov_export ;
uvm_tlm_analysis_fifo #(fifo_seq_item) cov_fifo ;
fifo_seq_item seq_item_cov ;

  covergroup cvr_gp ;

    wr_en_cp: coverpoint seq_item_cov.wr_en ;
    rd_en_cp: coverpoint seq_item_cov.rd_en ;
    full_cp: coverpoint seq_item_cov.full ;
    almostfull_cp: coverpoint seq_item_cov.almostfull ; 
    empty_cp: coverpoint seq_item_cov.empty ;
    almostempty_cp: coverpoint seq_item_cov.almostempty ; 
    overflow_cp: coverpoint seq_item_cov.overflow ;
    underflow_cp: coverpoint seq_item_cov.underflow ; 
    wr_ack_cp: coverpoint seq_item_cov.wr_ack ;

    cross_wr_rd_full:         cross wr_en_cp, rd_en_cp, full_cp;
    cross_wr_rd_almostfull:   cross wr_en_cp, rd_en_cp, almostfull_cp;
    cross_wr_rd_empty:        cross wr_en_cp, rd_en_cp, empty_cp;
    cross_wr_rd_almostempty:  cross wr_en_cp, rd_en_cp, almostempty_cp;
    cross_wr_rd_overflow:     cross wr_en_cp, rd_en_cp, overflow_cp{
      ignore_bins wr0_rd0_overflow1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{0} && binsof(overflow_cp)intersect{1};
      ignore_bins wr0_rd1_overflow1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{1} && binsof(overflow_cp)intersect{1};
    }
    cross_wr_rd_underflow:    cross wr_en_cp, rd_en_cp, underflow_cp{
      ignore_bins wr0_rd0_underflow1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{0} && binsof(underflow_cp)intersect{1};
      ignore_bins wr1_rd0_underflow1 = binsof(wr_en_cp)intersect{1} && binsof(rd_en_cp)intersect{0} && binsof(underflow_cp)intersect{1};
    }

    /*cross_wr_rd_wr_ack:       cross wr_en_cp, rd_en_cp, wr_ack_cp{
      ignore_bins wr0_rd1_ack_1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{1} && binsof(wr_ack_cp)intersect{1};
      ignore_bins wr0_rd0_ack_1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{0} && binsof(wr_ack_cp)intersect{1};
    }*/
        
  endgroup

  function new (string name = "fifo_coverage" , uvm_component parent = null);
  super.new(name,parent);
  cvr_gp = new();
endfunction

function void build_phase (uvm_phase phase);
  super.build_phase(phase);
  cov_export=new("cov_export",this);
  cov_fifo = new("cov_fifo",this) ; 
endfunction

function void connect_phase (uvm_phase phase);
  super.connect_phase(phase);
  cov_export.connect(cov_fifo.analysis_export);
endfunction

task run_phase (uvm_phase phase);
  super.run_phase(phase);
  forever begin
    cov_fifo.get(seq_item_cov);
    cvr_gp.sample();
  end
endtask

endclass


endpackage