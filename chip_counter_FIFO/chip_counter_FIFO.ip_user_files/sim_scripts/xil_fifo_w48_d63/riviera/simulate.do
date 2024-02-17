transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+xil_fifo_w48_d63  -L xpm -L fifo_generator_v13_2_9 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.xil_fifo_w48_d63 xil_defaultlib.glbl

do {xil_fifo_w48_d63.udo}

run 1000ns

endsim

quit -force
