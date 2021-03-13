onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /data_memory_tb/clk
add wave -noupdate -radix unsigned /data_memory_tb/reset
add wave -noupdate -radix hexadecimal -childformat {{{/data_memory_tb/read_data[31]} -radix unsigned} {{/data_memory_tb/read_data[30]} -radix unsigned} {{/data_memory_tb/read_data[29]} -radix unsigned} {{/data_memory_tb/read_data[28]} -radix unsigned} {{/data_memory_tb/read_data[27]} -radix unsigned} {{/data_memory_tb/read_data[26]} -radix unsigned} {{/data_memory_tb/read_data[25]} -radix unsigned} {{/data_memory_tb/read_data[24]} -radix unsigned} {{/data_memory_tb/read_data[23]} -radix unsigned} {{/data_memory_tb/read_data[22]} -radix unsigned} {{/data_memory_tb/read_data[21]} -radix unsigned} {{/data_memory_tb/read_data[20]} -radix unsigned} {{/data_memory_tb/read_data[19]} -radix unsigned} {{/data_memory_tb/read_data[18]} -radix unsigned} {{/data_memory_tb/read_data[17]} -radix unsigned} {{/data_memory_tb/read_data[16]} -radix unsigned} {{/data_memory_tb/read_data[15]} -radix unsigned} {{/data_memory_tb/read_data[14]} -radix unsigned} {{/data_memory_tb/read_data[13]} -radix unsigned} {{/data_memory_tb/read_data[12]} -radix unsigned} {{/data_memory_tb/read_data[11]} -radix unsigned} {{/data_memory_tb/read_data[10]} -radix unsigned} {{/data_memory_tb/read_data[9]} -radix unsigned} {{/data_memory_tb/read_data[8]} -radix unsigned} {{/data_memory_tb/read_data[7]} -radix unsigned} {{/data_memory_tb/read_data[6]} -radix unsigned} {{/data_memory_tb/read_data[5]} -radix unsigned} {{/data_memory_tb/read_data[4]} -radix unsigned} {{/data_memory_tb/read_data[3]} -radix unsigned} {{/data_memory_tb/read_data[2]} -radix unsigned} {{/data_memory_tb/read_data[1]} -radix unsigned} {{/data_memory_tb/read_data[0]} -radix unsigned}} -subitemconfig {{/data_memory_tb/read_data[31]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[30]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[29]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[28]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[27]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[26]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[25]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[24]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[23]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[22]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[21]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[20]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[19]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[18]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[17]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[16]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[15]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[14]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[13]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[12]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[11]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[10]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[9]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[8]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[7]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[6]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[5]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[4]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[3]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[2]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[1]} {-height 15 -radix unsigned} {/data_memory_tb/read_data[0]} {-height 15 -radix unsigned}} /data_memory_tb/read_data
add wave -noupdate -radix unsigned /data_memory_tb/address
add wave -noupdate -radix unsigned /data_memory_tb/read_en
add wave -noupdate -radix unsigned /data_memory_tb/write_en
add wave -noupdate -radix unsigned /data_memory_tb/is_signed
add wave -noupdate -radix unsigned /data_memory_tb/xfer_size
add wave -noupdate -radix unsigned /data_memory_tb/write_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1190 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 238
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
