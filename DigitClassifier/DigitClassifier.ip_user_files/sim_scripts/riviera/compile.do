transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -incr -l xpm -l xil_defaultlib \
"D:/Apps/Vivado/2024.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  -incr \
"D:/Apps/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../DigitClassifier.srcs/sources_1/new/Types.vhd" \
"../../../DigitClassifier.srcs/sources_1/new/Layer.vhd" \
"../../../DigitClassifier.srcs/sources_1/new/mpg.vhd" \
"../../../DigitClassifier.srcs/sources_1/new/TOP.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

