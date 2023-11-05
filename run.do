vlib  work
vlog *.v
vsim -novopt work.tb
view wave
add wave -r /*
add wave \
{sim:/tb/cycle/reg_file/Registers[10] } 
run 80ns