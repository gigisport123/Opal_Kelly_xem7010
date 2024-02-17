onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib xil_fifo_w48_d63_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {xil_fifo_w48_d63.udo}

run 1000ns

quit -force
