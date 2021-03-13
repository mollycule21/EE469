onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /test_tb/dut/clk
add wave -noupdate -radix unsigned /test_tb/dut/reset
add wave -noupdate -radix unsigned /test_tb/dut/do_WB
add wave -noupdate -radix unsigned /test_tb/dut/WB_data
add wave -noupdate -radix unsigned /test_tb/dut/data_mem_output
add wave -noupdate -radix unsigned /test_tb/dut/data_mem_output_final
add wave -noupdate -radix unsigned /test_tb/dut/write_half
add wave -noupdate -radix unsigned /test_tb/dut/read_half
add wave -noupdate -radix unsigned /test_tb/dut/address
add wave -noupdate -radix unsigned /test_tb/dut/instruction
add wave -noupdate -radix unsigned -childformat {{/test_tb/dut/dec_control_outputs.rd -radix unsigned} {/test_tb/dut/dec_control_outputs.mem_read -radix unsigned} {/test_tb/dut/dec_control_outputs.mem_write -radix unsigned} {/test_tb/dut/dec_control_outputs.reg_write -radix unsigned} {/test_tb/dut/dec_control_outputs.data_mem_signed -radix unsigned} {/test_tb/dut/dec_control_outputs.control_branch -radix unsigned} {/test_tb/dut/dec_control_outputs.jalr_branch -radix unsigned} {/test_tb/dut/dec_control_outputs.alu_signal -radix unsigned} {/test_tb/dut/dec_control_outputs.imm_en -radix unsigned} {/test_tb/dut/dec_control_outputs.imm -radix unsigned} {/test_tb/dut/dec_control_outputs.imm_U_J -radix unsigned} {/test_tb/dut/dec_control_outputs.xfer_size -radix unsigned}} -subitemconfig {/test_tb/dut/dec_control_outputs.rd {-height 15 -radix unsigned} /test_tb/dut/dec_control_outputs.mem_read {-height 15 -radix unsigned} /test_tb/dut/dec_control_outputs.mem_write {-height 15 -radix unsigned} /test_tb/dut/dec_control_outputs.reg_write {-height 15 -radix unsigned} /test_tb/dut/dec_control_outputs.data_mem_signed {-height 15 -radix unsigned} /test_tb/dut/dec_control_outputs.control_branch {-height 15 -radix unsigned} /test_tb/dut/dec_control_outputs.jalr_branch {-height 15 -radix unsigned} /test_tb/dut/dec_control_outputs.alu_signal {-height 15 -radix unsigned} /test_tb/dut/dec_control_outputs.imm_en {-height 15 -radix unsigned} /test_tb/dut/dec_control_outputs.imm {-height 15 -radix unsigned} /test_tb/dut/dec_control_outputs.imm_U_J {-height 15 -radix unsigned} /test_tb/dut/dec_control_outputs.xfer_size {-height 15 -radix unsigned}} /test_tb/dut/dec_control_outputs
add wave -noupdate -radix unsigned -childformat {{/test_tb/dut/EX_control_outputs.rd -radix unsigned} {/test_tb/dut/EX_control_outputs.mem_read -radix unsigned} {/test_tb/dut/EX_control_outputs.mem_write -radix unsigned} {/test_tb/dut/EX_control_outputs.reg_write -radix unsigned} {/test_tb/dut/EX_control_outputs.data_mem_signed -radix unsigned} {/test_tb/dut/EX_control_outputs.control_branch -radix unsigned} {/test_tb/dut/EX_control_outputs.jalr_branch -radix unsigned} {/test_tb/dut/EX_control_outputs.alu_signal -radix unsigned} {/test_tb/dut/EX_control_outputs.imm_en -radix unsigned} {/test_tb/dut/EX_control_outputs.imm -radix unsigned} {/test_tb/dut/EX_control_outputs.imm_U_J -radix unsigned} {/test_tb/dut/EX_control_outputs.xfer_size -radix unsigned}} -subitemconfig {/test_tb/dut/EX_control_outputs.rd {-radix unsigned} /test_tb/dut/EX_control_outputs.mem_read {-radix unsigned} /test_tb/dut/EX_control_outputs.mem_write {-radix unsigned} /test_tb/dut/EX_control_outputs.reg_write {-radix unsigned} /test_tb/dut/EX_control_outputs.data_mem_signed {-radix unsigned} /test_tb/dut/EX_control_outputs.control_branch {-radix unsigned} /test_tb/dut/EX_control_outputs.jalr_branch {-radix unsigned} /test_tb/dut/EX_control_outputs.alu_signal {-radix unsigned} /test_tb/dut/EX_control_outputs.imm_en {-radix unsigned} /test_tb/dut/EX_control_outputs.imm {-radix unsigned} /test_tb/dut/EX_control_outputs.imm_U_J {-radix unsigned} /test_tb/dut/EX_control_outputs.xfer_size {-radix unsigned}} /test_tb/dut/EX_control_outputs
add wave -noupdate -radix unsigned /test_tb/dut/MEM_control_outputs
add wave -noupdate -radix unsigned /test_tb/dut/WB_control_outputs
add wave -noupdate -radix unsigned /test_tb/dut/if_id_pc
add wave -noupdate -radix binary /test_tb/dut/if_id_instruction
add wave -noupdate -radix unsigned /test_tb/dut/id_ex_pc
add wave -noupdate -radix unsigned /test_tb/dut/rs1
add wave -noupdate -radix unsigned /test_tb/dut/rs2
add wave -noupdate -radix unsigned /test_tb/dut/forwardA
add wave -noupdate -radix unsigned /test_tb/dut/forwardB
add wave -noupdate -radix unsigned /test_tb/dut/id_ex_alu_in_1
add wave -noupdate -radix unsigned /test_tb/dut/id_ex_alu_in_2
add wave -noupdate -radix binary /test_tb/dut/id_ex_instruction
add wave -noupdate -radix binary /test_tb/dut/ex_mem_instruction
add wave -noupdate -radix unsigned /test_tb/dut/alu_output
add wave -noupdate -radix unsigned /test_tb/dut/ex_mem_alu_output
add wave -noupdate -radix unsigned /test_tb/dut/take_branch
add wave -noupdate -radix unsigned /test_tb/dut/take_branch_final
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {106 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 257
configure wave -valuecolwidth 95
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
WaveRestoreZoom {56 ps} {399 ps}
