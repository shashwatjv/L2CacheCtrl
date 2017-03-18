all :
	setlib 
	compile 
	run 

setlib :
	vlib work
	vmap work work

compile :
	vlog -sv +incdir+./+../pkgs/+../+../design/+../tb/+../tests/ ../tb/L2CACHE_tb.sv

run : 
	vsim -c work.test -l L2SIM.log -do "run -all; quit"

clean :
	mv Makefile ../
	rm -rf *
	mv ../Makefile .
