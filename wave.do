onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider core
add wave -noupdate /test/u_core/clk
add wave -noupdate /test/u_core/nrst
add wave -noupdate /test/u_core/exIns_valid
add wave -noupdate /test/u_core/exIns_in
add wave -noupdate /test/u_core/exIns_ren
add wave -noupdate /test/u_core/exIns_addr
add wave -noupdate -color Orchid /test/u_core/pc
add wave -noupdate -color {Medium Orchid} /test/u_core/inst
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -divider r1
add wave -noupdate /test/u_core/stall
add wave -noupdate /test/u_core/ins_br_en
add wave -noupdate /test/u_core/ins_br_addr
add wave -noupdate -color Orchid /test/u_core/pc_r1
add wave -noupdate -color {Medium Orchid} /test/u_core/inst_r1
add wave -noupdate /test/u_core/rf_wen
add wave -noupdate /test/u_core/radd1_r1
add wave -noupdate /test/u_core/radd2_r1
add wave -noupdate /test/u_core/stall_r1
add wave -noupdate -divider r2
add wave -noupdate /test/u_core/rs1_data_r2
add wave -noupdate /test/u_core/rs2_data_r2
add wave -noupdate -color Orchid /test/u_core/pc_r2
add wave -noupdate -color {Medium Orchid} /test/u_core/inst_r2
add wave -noupdate -radix binary /test/u_core/inst_funct3_r2
add wave -noupdate -color Gold -radix unsigned /test/u_core/rd_addr_r2
add wave -noupdate -radix symbolic -radixshowbase 0 /test/u_core/mem_opcode_r2
add wave -noupdate /test/u_core/rf_wdata
add wave -noupdate /test/u_core/br_en_r2
add wave -noupdate /test/u_core/br_addr_r2
add wave -noupdate /test/u_core/rd_wen_r2
add wave -noupdate /test/u_core/mem_rdata_valid_r2
add wave -noupdate /test/u_core/alu_rd_data_r2
add wave -noupdate /test/u_core/stall_r2
add wave -noupdate -divider r3
add wave -noupdate /test/u_core/br_en_r3
add wave -noupdate /test/u_core/rd_wen_r3
add wave -noupdate /test/u_core/mem_rdata_valid_r3
add wave -noupdate /test/u_core/mem_rdata_r3
add wave -noupdate /test/u_core/dmem_rwaddr
add wave -noupdate /test/u_core/br_addr_r3
add wave -noupdate -radix unsigned /test/u_core/rd_addr_r3
add wave -noupdate /test/u_core/stall_r3
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate /test/u_core/regFile/wen
add wave -noupdate -radix unsigned /test/u_core/regFile/wadd
add wave -noupdate /test/u_core/regFile/wdata
add wave -noupdate -format Event /test/u_core/regFile/reg_file
add wave -noupdate {/test/u_core/regFile/reg_file[29]}
add wave -noupdate {/test/u_core/regFile/reg_file[30]}
add wave -noupdate {/test/u_core/regFile/reg_file[31]}
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -color Orchid /test/u_core/alu_mod/pc
add wave -noupdate -color {Medium Orchid} /test/u_core/alu_mod/inst
add wave -noupdate /test/u_core/alu_mod/rs2_data
add wave -noupdate /test/u_core/alu_mod/rs1_data
add wave -noupdate /test/u_core/alu_mod/rd_data
add wave -noupdate /test/u_core/alu_mod/br_en
add wave -noupdate -color {Dark Orchid} -radix binary /test/u_core/alu_mod/inst_opcode
add wave -noupdate -color {Dark Orchid} /test/u_core/alu_mod/inst_funct3
add wave -noupdate -color {Dark Orchid} /test/u_core/alu_mod/inst_funct7
add wave -noupdate /test/u_core/alu_mod/imm
add wave -noupdate /test/u_core/alu_mod/imm_valid
add wave -noupdate -divider alu
add wave -noupdate -radix symbolic /test/u_core/alu_mod/alu_op
add wave -noupdate /test/u_core/alu_mod/alu_rs1
add wave -noupdate /test/u_core/alu_mod/alu_rs2
add wave -noupdate /test/u_core/alu_mod/alu_rd
add wave -noupdate /test/u_core/alu_mod/alu_of
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix binary /test/u_core/dmem_mod/inst_funct3
add wave -noupdate -radix binary /test/u_core/dmem_mod/mem_opcode
add wave -noupdate -color Pink /test/u_core/dmem_mod/rwaddr
add wave -noupdate /test/u_core/dmem_mod/wdata
add wave -noupdate /test/u_core/dmem_mod/rdata
add wave -noupdate -format Event /test/u_core/dmem_mod/dmem/mem1/mem
add wave -noupdate -format Event /test/u_core/dmem_mod/dmem/mem2/mem
add wave -noupdate {/test/u_core/dmem_mod/dmem/mem1/mem[63]}
add wave -noupdate {/test/u_core/dmem_mod/dmem/mem1/mem[65]}
add wave -noupdate -divider memory
add wave -noupdate -radix binary /test/u_core/dmem_mod/dmem/op_code
add wave -noupdate /test/u_core/dmem_mod/dmem/rwaddr
add wave -noupdate /test/u_core/dmem_mod/dmem/rwaddr_r
add wave -noupdate /test/u_core/dmem_mod/dmem/wdata
add wave -noupdate /test/u_core/dmem_mod/dmem/rdata
add wave -noupdate /test/u_core/dmem_mod/dmem/q_1
add wave -noupdate /test/u_core/dmem_mod/dmem/q_2
add wave -noupdate /test/u_core/dmem_mod/dmem/q
add wave -noupdate /test/u_core/dmem_mod/dmem/d
add wave -noupdate /test/u_core/dmem_mod/dmem/bwen
add wave -noupdate /test/u_core/dmem_mod/dmem/wen
add wave -noupdate /test/u_core/dmem_mod/dmem/cen_1
add wave -noupdate /test/u_core/dmem_mod/dmem/cen_2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {517 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 209
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ns} {534 ns}
