# Create work library
vlib work

# Compile Verilog, Needed to compile the verilog for the initial simulation
# or when you updated/changed your verilog code
# find the verilog files
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
# Make sure the directory of the verilog file is correct
# You may use an absolute path or an relative path as used here.
# ".." means return one level up in file directory, and due to the fact that 
# modelsim simulation directory is normally 2 level deep in the quartus main project
# directory, I returned two times to find my verilog file
# In general, know where your files are and point to them correctly!

vlog -sv -work work "mux_8_1.sv"
vlog -sv -work work "mux_4_1.sv"
vlog -sv -work work "mux_2_1.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work mux_8_1_testbench


# Set the window types
view wave
view structure
view signals

# Set window configuration
# WaveRestoreCursors {{Cursor 1} {1000 ps} 0}
# quietly wave cursor active 1
# configure wave -namecolwidth 150
# configure wave -valuecolwidth 100
# configure wave -justifyvalue left
# configure wave -signalnamewidth 1
# configure wave -snapdistance 10
# configure wave -datasetprefix 0
# configure wave -rowmargin 4
# configure wave -childrowmargin 2
# configure wave -gridoffset 0
# configure wave -gridperiod 300
# configure wave -griddelta 40
# configure wave -timeline 0
# configure wave -timelineunits ps
# update

# adding in the waves that you wish to observe
# in this case clk, a ,b, out, are the signal names
# if you wish to observe some signal that are levels deeper
# you need to use module_name/signal_name naming structure

# add wave -noupdate clk
# add wave -noupdate a
# add wave -noupdate b
# add wave -noupdate out

# Or you can put the content depended commands like adding waves
# in a seperate do file and source the wave do file
# make sure the do file is in the same directory of this do file
# do some_testbench.do

do mux_8_1_wave.do


# Run the simulation
run -all

# End
