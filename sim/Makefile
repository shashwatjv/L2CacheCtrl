test?=../tests/cc1.din

all :	clean setlib compile run 

setlib :
	vlib work
	vmap work work

compile :
	echo ${test}
	vlog -sv +define+TESTCMD=\"${test}\" +incdir+./+../pkgs/+../+../design/+../tb/+../tests/ ../tb/L2CACHE_tb.sv

run : 
	vsim -c work.test -l L2SIM.log -do "run -all; quit"

clean :
	mv Makefile ../
	rm -rf *
	mv ../Makefile .

