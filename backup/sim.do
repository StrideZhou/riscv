#==============================================
# clear 
#==============================================
quit -sim
.main clear

#==============================================
# Create work library
#==============================================
vlib work
vmap work work

#================================================================
# Compiling
#================================================================
# Compile the common files
vlog -sv common_parts/control_constants.v
vlog -sv common_parts/adder.v
vlog -sv common_parts/alu.v
vlog -sv common_parts/regFile.v
vlog -sv common_parts/alu_op_gen.v
vlog -sv common_parts/immediate_gen.v
vlog -sv common_parts/inst_decoder.v
vlog -sv common_parts/mux2.v
vlog -sv common_parts/mux4.v
vlog -sv common_parts/syn_reg.v

# Compile the files for singlecycle implementation
vlog -sv controlpath_single.v
vlog -sv datapath_single.v
vlog -sv top_single.v

# Compile the test file
vlog -sv test_single.v

#================================================================
# Simulation settings
#================================================================
# Set top and no optimization
vsim -novopt test

# Add waves

# Run simulation
run 1000