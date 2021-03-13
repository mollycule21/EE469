onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /id_ex_tb/clk
add wave -noupdate -radix unsigned /id_ex_tb/RF_out_1
add wave -noupdate -radix unsigned /id_ex_tb/RF_out_2
add wave -noupdate -radix unsigned /id_ex_tb/forwardA
add wave -noupdate -radix unsigned /id_ex_tb/forwardB
add wave -noupdate -radix unsigned /id_ex_tb/EX_out_1
add wave -noupdate -radix unsigned /id_ex_tb/EX_out_2
add wave -noupdate -radix unsigned /id_ex_tb/EX_Rd
add wave -noupdate -radix unsigned /id_ex_tb/rd
add wave -noupdate -radix unsigned /id_ex_tb/id_ex_pc
add wave -noupdate -radix unsigned /id_ex_tb/if_id_pc
add wave -noupdate -radix unsigned /id_ex_tb/id_ex_instruction
add wave -noupdate -radix unsigned /id_ex_tb/if_id_instruction
add wave -noupdate -radix unsigned /id_ex_tb/read_out_1
add wave -noupdate -radix unsigned /id_ex_tb/read_out_2
add wave -noupdate -radix unsigned /id_ex_tb/alu_out
add wave -noupdate -radix unsigned /id_ex_tb/mem_read_out
add wave -noupdate -radix unsigned /id_ex_tb/wb_data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {296 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1365 ps}
