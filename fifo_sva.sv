module fifo_sva (fifo_if.ASSR fifoif);



//Assertions 

always_comb begin : RST_check
	if(!fifoif.rst_n) 
	rst_assetion : assert final ((!FIFO.count)&&(!FIFO.wr_ptr)&&(!FIFO.rd_ptr)&&(!fifoif.wr_ack)&&(!fifoif.underflow)&&(!fifoif.overflow));
	rst_cover : cover final ((!FIFO.count)&&(!FIFO.wr_ptr)&&(!FIFO.rd_ptr)&&(!fifoif.wr_ack)&&(!fifoif.underflow)&&(!fifoif.overflow));
end

always_comb begin : Full_check
	if((fifoif.rst_n)&&(FIFO.count == fifoif.FIFO_DEPTH))
	full_assertion : assert final (fifoif.full);
	full_cover : cover final (fifoif.full);
end

always_comb begin : Almostfull_check
	if((fifoif.rst_n)&&(FIFO.count == (fifoif.FIFO_DEPTH-1)))
	almostfull_assertion : assert final (fifoif.almostfull);
	almostfull_cover : cover final (fifoif.almostfull);	
end

always_comb begin : Empty_check
	if((fifoif.rst_n)&&(FIFO.count == 0))
	empty_assertion : assert final (fifoif.empty);
	empty_cover : cover final (fifoif.empty);
end

always_comb begin :Almostempty_check
	if((fifoif.rst_n)&&(FIFO.count == 1))
	almostempty_assertion : assert final (fifoif.almostempty);
	almostempty_cover : cover final (fifoif.almostempty);
end


property wr_ack_p ;
	@(posedge fifoif.clk) 
	disable iff (!fifoif.rst_n)
	(fifoif.wr_en && !fifoif.full) |=> (fifoif.wr_ack) ;
endproperty

property overflow_p ;
	@(posedge fifoif.clk) 
	disable iff (!fifoif.rst_n)
	(fifoif.wr_en && fifoif.full) |=> (fifoif.overflow) ;
endproperty

property underflow_p ;
	@(posedge fifoif.clk) 
	disable iff (!fifoif.rst_n)
	(fifoif.rd_en && fifoif.empty) |=> (fifoif.underflow) ;
endproperty

property wr_ptr_wraparound;
	@(posedge fifoif.clk) 
	disable iff (!fifoif.rst_n)
	(fifoif.wr_en && !fifoif.full) |=> ((FIFO.wr_ptr == ($past(FIFO.wr_ptr) + 1))|| ((FIFO.wr_ptr==0)&&($past(FIFO.wr_ptr)+1 == 8)));
endproperty

property rd_ptr_wraparound;
	@(posedge fifoif.clk) 
	disable iff (!fifoif.rst_n)
	(fifoif.rd_en && !fifoif.empty ) |=> ((FIFO.rd_ptr == ( $past(FIFO.rd_ptr)+1 ))|| ((FIFO.rd_ptr==0)&&($past(FIFO.rd_ptr)+1 == 8)));
endproperty

property counter_wraparound_incr;
	@(posedge fifoif.clk) 
	disable iff (!fifoif.rst_n)
	( ({fifoif.wr_en, fifoif.rd_en} == 2'b10) && !fifoif.full) || ( ({fifoif.wr_en, fifoif.rd_en} == 2'b11) && fifoif.empty)
	 |=> (FIFO.count == $past(FIFO.count)+1);
endproperty

property counter_wraparound_decr;
	@(posedge fifoif.clk) 
	disable iff (!fifoif.rst_n)
	( ({fifoif.wr_en, fifoif.rd_en} == 2'b01) && !fifoif.empty) || ( ({fifoif.wr_en, fifoif.rd_en} == 2'b11) && fifoif.full)
	 |=> (FIFO.count == $past(FIFO.count)-1);
endproperty

property wr_ptr_thershold ;
	@(posedge fifoif.clk) 
	disable iff (!fifoif.rst_n)
	(FIFO.wr_ptr < fifoif.FIFO_DEPTH) ;
endproperty

property rd_ptr_thershold ;
	@(posedge fifoif.clk) 
	disable iff (!fifoif.rst_n)
	(FIFO.rd_ptr < fifoif.FIFO_DEPTH) ;
endproperty

property count_thershold ;
	@(posedge fifoif.clk) 
	disable iff (!fifoif.rst_n)
	(FIFO.count <= fifoif.FIFO_DEPTH) ;
endproperty



wr_ack_assertion : assert property (wr_ack_p) ;
wr_ack_cover : cover property (wr_ack_p) ;

overflow_assertion : assert property (overflow_p) ;
overflow_cover : cover property (overflow_p) ;

underflow_assertion : assert property (underflow_p) ;
underflow_cover : cover property (underflow_p) ;

wr_ptr_wraparound_assertion : assert property (wr_ptr_wraparound);
wr_ptr_wraparound_cover : cover property (wr_ptr_wraparound);

rd_ptr_wraparound_assertion : assert property (rd_ptr_wraparound);
rd_ptr_wraparound_cover : cover property (rd_ptr_wraparound);

counter_wraparound_incr_assertion : assert property (counter_wraparound_incr);
counter_wraparound_incr_cover : cover property (counter_wraparound_incr);

counter_wraparound_decr_assertion : assert property (counter_wraparound_decr);
counter_wraparound_decr_cover : cover property (counter_wraparound_decr);

wr_ptr_thershold_assertion : assert property (wr_ptr_thershold);
wr_ptr_thershold_cover : cover property (wr_ptr_thershold);

rd_ptr_thershold_assertion : assert property (rd_ptr_thershold);
rd_ptr_thershold_cover : cover property (rd_ptr_thershold);

count_thershold_assertion : assert property (count_thershold);
count_thershold_cover : cover property (count_thershold);

endmodule