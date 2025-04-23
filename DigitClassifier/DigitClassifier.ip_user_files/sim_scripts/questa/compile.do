vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu  -sv \
"D:/Apps/Vivado/2024.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93  \
"D:/Apps/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../DigitClassifier.srcs/sources_1/new/Types.vhd" \
"../../../DigitClassifier.srcs/sources_1/new/Layer.vhd" \
"../../../DigitClassifier.srcs/sources_1/new/mpg.vhd" \
"../../../DigitClassifier.srcs/sources_1/new/TOP.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

