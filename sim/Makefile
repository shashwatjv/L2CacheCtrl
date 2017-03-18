all :
	setlib 
	compile 
	run 

setlib :
	vlib work
	vmap work work

compile :
	vlog -sv +incdir+./+../pkgs/+../+../design/+../tb/ ../tb/L2CACHE_tb.sv

run : 
	vsim -c work.test -do "run -all; quit"
clean :
	rm -rf work
	rm modelsim.ini
	rm transcript 

