onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /register_file_tb/CLOCK_PERIOD
add wave -noupdate /register_file_tb/read_reg_1
add wave -noupdate /register_file_tb/read_reg_2
add wave -noupdate /register_file_tb/wr_reg
add wave -noupdate /register_file_tb/wr_data
add wave -noupdate /register_file_tb/wr_en
add wave -noupdate /register_file_tb/clk
add wave -noupdate /register_file_tb/read_out_1
add wave -noupdate /register_file_tb/read_out_2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {81 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {958 ps}
