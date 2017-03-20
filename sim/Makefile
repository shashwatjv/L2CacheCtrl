FILENAME?=\"../tests\/cc1.din\"

setlib :
	vlib work
	vmap work work

compile :
	echo ${FILENANME}
	vlog -sv +define+TESTCMD=${FILENAME} +incdir+./+../pkgs/+../+../design/+../tb/+../tests/ ../tb/L2CACHE_tb.sv

run : 
	vsim -c work.test -l L2SIM.log -do "run -all; quit"

clean :
	mv Makefile ../
	rm -rf *
	mv ../Makefile .

all :
	setlib 
	compile 
	run 

