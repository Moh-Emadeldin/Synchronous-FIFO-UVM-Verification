package fifo_scoreboard_pkg ;
import uvm_pkg ::*;
`include "uvm_macros.svh"

import fifo_seq_item_pkg ::*;
import fifo_config_pkg ::*;


class fifo_scoreboard extends uvm_scoreboard ;
`uvm_component_utils(fifo_scoreboard)
  uvm_analysis_export#(fifo_seq_item)sb_export;
  uvm_tlm_analysis_fifo#(fifo_seq_item)sb_fifo;
  fifo_seq_item seq_item_sb ;
  logic [15:0] data_out_ref ;
  logic [15:0] Queue [$] ;
  logic [4:0] count ;

  int error_counter = 0 ;
  int correct_counter = 0 ; 

  function new (string name = "fifo_scoreboard" ,uvm_component parent = null) ;
    super.new(name,parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    sb_export = new("sb_export",this);
    sb_fifo = new("sb_fifo",this);
  endfunction

  function void connect_phase (uvm_phase phase);  
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
  endfunction

  
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin
      sb_fifo.get(seq_item_sb);
      Reference_model(seq_item_sb);
      #1;
      if((seq_item_sb.data_out !== data_out_ref) ) begin
        `uvm_error("run_phase",$sformatf("Comparison Failed , Transaction recieved bu DUT : %s 
        while the reference data_out : 0h%0h",seq_item_sb.convert2string(),data_out_ref))
        error_counter ++ ;
      end
      else begin
        `uvm_info("run_phase",$sformatf("Correct FIFO out : %s ",seq_item_sb.convert2string() ),UVM_HIGH)
        correct_counter ++ ;
      end
    end
  endtask

  task Reference_model (fifo_seq_item seq_item_chk);
			// Reset logic
			if (!seq_item_chk.rst_n) begin
				Queue <= {}; 
				count <= 0;
			end
			else begin
				// Write operation if not full
				if (seq_item_chk.wr_en && count <  8) begin
					Queue.push_back(seq_item_chk.data_in);  
					count <= Queue.size();       
				end

				// Read operation if not empty
				if (seq_item_chk.rd_en && count != 0) begin
					data_out_ref <= Queue.pop_front();
					count <= Queue.size();          
				end
				
			end

  endtask

  function void report_phase (uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("report_phase",$sformatf("total successful transactions = %0d ",correct_counter),UVM_MEDIUM)
    `uvm_info("report_phase",$sformatf("total failed transactions = %0d ",error_counter),UVM_MEDIUM)
  endfunction

endclass
endpackage