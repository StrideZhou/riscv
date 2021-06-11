onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ins_mod_tb/UUT/clk
add wave -noupdate /ins_mod_tb/UUT/nrst
add wave -noupdate /ins_mod_tb/UUT/stall
add wave -noupdate /ins_mod_tb/UUT/br_en
add wave -noupdate /ins_mod_tb/UUT/br_addr
add wave -noupdate /ins_mod_tb/UUT/PC
add wave -noupdate /ins_mod_tb/UUT/ins_out
add wave -noupdate /ins_mod_tb/UUT/exIns_valid
add wave -noupdate /ins_mod_tb/UUT/exIns_in
add wave -noupdate /ins_mod_tb/UUT/exIns_ren
add wave -noupdate /ins_mod_tb/UUT/exIns_addr
add wave -noupdate /ins_mod_tb/UUT/rdata
add wave -noupdate /ins_mod_tb/UUT/exIns_in_r
add wave -noupdate /ins_mod_tb/UUT/PC_reg
add wave -noupdate /ins_mod_tb/UUT/ren
add wave -noupdate /ins_mod_tb/UUT/exIns_ren_r
add wave -noupdate /ins_mod_tb/UUT/exIns_ready
add wave -noupdate -divider mem
add wave -noupdate /ins_mod_tb/UUT/imem/clk
add wave -noupdate /ins_mod_tb/UUT/imem/nrst
add wave -noupdate /ins_mod_tb/UUT/imem/stall
add wave -noupdate /ins_mod_tb/UUT/imem/op_code
add wave -noupdate /ins_mod_tb/UUT/imem/rwaddr
add wave -noupdate /ins_mod_tb/UUT/imem/wdata
add wave -noupdate /ins_mod_tb/UUT/imem/rdata
add wave -noupdate /ins_mod_tb/UUT/imem/q_1
add wave -noupdate /ins_mod_tb/UUT/imem/q_2
add wave -noupdate /ins_mod_tb/UUT/imem/q_all
add wave -noupdate /ins_mod_tb/UUT/imem/bwen
add wave -noupdate /ins_mod_tb/UUT/imem/wen
add wave -noupdate /ins_mod_tb/UUT/imem/cen_1
add wave -noupdate /ins_mod_tb/UUT/imem/cen_2
add wave -noupdate /ins_mod_tb/UUT/imem/mem1/clk
add wave -noupdate /ins_mod_tb/UUT/imem/mem1/cen
add wave -noupdate /ins_mod_tb/UUT/imem/mem1/wen
add wave -noupdate /ins_mod_tb/UUT/imem/mem1/bwen
add wave -noupdate /ins_mod_tb/UUT/imem/mem1/a
add wave -noupdate /ins_mod_tb/UUT/imem/mem1/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {120247 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 238
configure wave -valuecolwidth 100
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {212100 ps}
