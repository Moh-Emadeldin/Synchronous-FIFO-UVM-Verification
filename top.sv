import fifo_test_pkg ::*;
import uvm_pkg ::*;
`include "uvm_macros.svh"
module top ;
  bit clk ;

  initial begin
    clk = 0 ;
    forever begin
      #1 clk = ~clk ;
    end
  end

  fifo_if fifoif (clk) ;
  FIFO DUT (fifoif);

  // Assertion binding :
  bind FIFO fifo_sva ASSR (fifoif) ;

  initial begin
    uvm_config_db#(virtual fifo_if)::set(null , "uvm_test_top" , "FIFO_IF" , fifoif);
    run_test("fifo_test") ;
  end


  
endmodule