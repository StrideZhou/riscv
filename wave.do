onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider core
add wave -noupdate /test/u_core/clk
add wave -noupdate /test/u_core/nrst
add wave -noupdate /test/u_core/exIns_valid
add wave -noupdate /test/u_core/exIns_in
add wave -noupdate /test/u_core/exIns_ren
add wave -noupdate /test/u_core/exIns_addr
add wave -noupdate -color Gold /test/u_core/pc
add wave -noupdate /test/u_core/inst
add wave -noupdate /test/u_core/ins_br_en
add wave -noupdate /test/u_core/ins_br_addr
add wave -noupdate -color Gold /test/u_core/pc_r1
add wave -noupdate /test/u_core/stall
add wave -noupdate /test/u_core/rf_wen
add wave -noupdate /test/u_core/radd1
add wave -noupdate /test/u_core/radd2
add wave -noupdate /test/u_core/rf_wadd
add wave -noupdate /test/u_core/rf_wdata
add wave -noupdate /test/u_core/rs1_data
add wave -noupdate /test/u_core/rs2_data
add wave -noupdate -color Gold /test/u_core/pc_r2
add wave -noupdate /test/u_core/inst_r2
add wave -noupdate /test/u_core/br_en_r3
add wave -noupdate /test/u_core/rd_wen_r3
add wave -noupdate /test/u_core/alu_rd_data
add wave -noupdate /test/u_core/mem_rdata
add wave -noupdate /test/u_core/inst_funct3_r3
add wave -noupdate /test/u_core/mem_opcode_r3
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate /test/u_core/regFile/nrst
add wave -noupdate /test/u_core/regFile/clk
add wave -noupdate /test/u_core/regFile/radd1
add wave -noupdate /test/u_core/regFile/radd2
add wave -noupdate /test/u_core/regFile/wen
add wave -noupdate /test/u_core/regFile/wadd
add wave -noupdate /test/u_core/regFile/wdata
add wave -noupdate /test/u_core/regFile/rs1
add wave -noupdate /test/u_core/regFile/rs2
add wave -noupdate /test/u_core/regFile/i
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate /test/u_core/alu_mod/inst
add wave -noupdate /test/u_core/alu_mod/rs1_data
add wave -noupdate /test/u_core/alu_mod/rs2_data
add wave -noupdate /test/u_core/alu_mod/rd_data
add wave -noupdate /test/u_core/alu_mod/pc
add wave -noupdate /test/u_core/alu_mod/br_en
add wave -noupdate /test/u_core/alu_mod/inst_opcode
add wave -noupdate /test/u_core/alu_mod/inst_funct3
add wave -noupdate /test/u_core/alu_mod/inst_funct7
add wave -noupdate /test/u_core/alu_mod/imm
add wave -noupdate /test/u_core/alu_mod/imm_valid
add wave -noupdate /test/u_core/alu_mod/alu_op
add wave -noupdate /test/u_core/alu_mod/alu_rs1
add wave -noupdate /test/u_core/alu_mod/alu_rs2
add wave -noupdate /test/u_core/alu_mod/alu_rd
add wave -noupdate /test/u_core/alu_mod/alu_of
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {62 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 498
configure wave -valuecolwidth 139
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
WaveRestoreZoom {6 ns} {40 ns}
