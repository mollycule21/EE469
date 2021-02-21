onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /branch_adder_tb/imm_en
add wave -noupdate /branch_adder_tb/imm_U_J
add wave -noupdate /branch_adder_tb/imm
add wave -noupdate /branch_adder_tb/pc
add wave -noupdate /branch_adder_tb/pc_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {195 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 232
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
WaveRestoreZoom {0 ps} {827 ps}
