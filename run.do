vlib work
vlog -f src_files.list
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all +vcs+dumpvars
add wave /top/fifoif/*
coverage save FIFO.ucdb -onexit -du fifo_if
run -all