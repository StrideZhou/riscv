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
add wave -noupdate /test/u_core/ins_mod/clk
add wave -noupdate /test/u_core/ins_mod/nrst
add wave -noupdate /test/u_core/ins_mod/stall
add wave -noupdate /test/u_core/ins_mod/br_en
add wave -noupdate /test/u_core/ins_mod/br_addr
add wave -noupdate /test/u_core/ins_mod/pc
add wave -noupdate /test/u_core/ins_mod/ins_out
add wave -noupdate /test/u_core/ins_mod/exIns_valid
add wave -noupdate /test/u_core/ins_mod/exIns_in
add wave -noupdate /test/u_core/ins_mod/exIns_ren
add wave -noupdate /test/u_core/ins_mod/exIns_addr
add wave -noupdate /test/u_core/ins_mod/rdata
add wave -noupdate /test/u_core/ins_mod/exIns_in_r
add wave -noupdate /test/u_core/ins_mod/pc_reg
add wave -noupdate /test/u_core/ins_mod/ren
add wave -noupdate /test/u_core/ins_mod/exIns_ren_r
add wave -noupdate /test/u_core/ins_mod/Ins_ready
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
WaveRestoreZoom {240 ns} {274 ns}
