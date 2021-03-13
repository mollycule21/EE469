onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /top_tb/clk
add wave -noupdate /top_tb/KEY
add wave -noupdate /top_tb/address
add wave -noupdate -radix hexadecimal /top_tb/dut/HEX_out
add wave -noupdate /top_tb/dut/counter
add wave -noupdate /top_tb/dut/out3
add wave -noupdate /top_tb/dut/out2
add wave -noupdate /top_tb/dut/out1
add wave -noupdate /top_tb/dut/out0
add wave -noupdate /top_tb/HEX3
add wave -noupdate /top_tb/HEX2
add wave -noupdate /top_tb/HEX1
add wave -noupdate /top_tb/HEX0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {645372 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 234
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {4751360 ps}
