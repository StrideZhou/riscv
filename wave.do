onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test/clk
add wave -noupdate /test/nrst
add wave -noupdate /test/inst
add wave -noupdate /test/pc
add wave -noupdate /test/exIns_valid
add wave -noupdate /test/exIns_in
add wave -noupdate /test/exIns_ren
add wave -noupdate /test/exIns_addr
add wave -noupdate -divider core
add wave -noupdate /test/u_core/clk
add wave -noupdate /test/u_core/nrst
add wave -noupdate /test/u_core/exIns_valid
add wave -noupdate /test/u_core/exIns_in
add wave -noupdate /test/u_core/exIns_ren
add wave -noupdate /test/u_core/exIns_addr
add wave -noupdate /test/u_core/pc
add wave -noupdate /test/u_core/inst
add wave -noupdate /test/u_core/ins_br_en
add wave -noupdate /test/u_core/ins_br_addr
add wave -noupdate /test/u_core/pc_r1
add wave -noupdate /test/u_core/rf_wen
add wave -noupdate /test/u_core/radd1
add wave -noupdate /test/u_core/radd2
add wave -noupdate /test/u_core/rf_wadd
add wave -noupdate /test/u_core/rf_wdata
add wave -noupdate /test/u_core/rs1_data
add wave -noupdate /test/u_core/rs2_data
add wave -noupdate /test/u_core/pc_r2
add wave -noupdate /test/u_core/inst_r2
add wave -noupdate /test/u_core/br_en_r3
add wave -noupdate /test/u_core/rd_wen
add wave -noupdate /test/u_core/alu_rd_data
add wave -noupdate /test/u_core/rdata
add wave -noupdate /test/u_core/inst_funct3
add wave -noupdate /test/u_core/mem_opcode
add wave -noupdate /test/u_core/stall
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {261 ns} 0}
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
WaveRestoreZoom {0 ns} {27 ns}
