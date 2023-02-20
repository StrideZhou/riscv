DUT_TOP := top_tb
VDUT := ./obj_dir/V$(DUT_TOP)

test: $(VDUT)
	$^

test_wave: *.vcd

# 	gtkwave  -o -z -c 8 -W \
# 	# -t $(VDUT).stems 
#! 	# https://github.com/gtkwave/gtkwave/issues/139
# 	-f $^ ./*.gtkw

	gtkwave  -o -z -c 8 -W \
	-f $^ ./*.gtkw

*.vcd: $(VDUT)
	$(VDUT) +trace

$(VDUT): $(DUT_TOP).sv sim_main.cpp 

# 	verilator -Wno-lint -Wno-style -Wno-context -j 8 \
#  		--trace \
# 		--trace-threads 2 \
# 		--xml-output $(VDUT).xml \
#  		-sv --cc --exe --build $^ \
# 		xml2stems -V $(VDUT).xml $(VDUT).stems \
#! 		# https://github.com/gtkwave/gtkwave/issues/139

	verilator -Wno-lint -Wno-style -Wno-context -j 8 \
 		--trace \
		--trace-threads 2 \
 		-sv --cc --exe --build $^

clean: clean_wave clean_obj

clean_obj:
	rm -rf ./obj_dir 

clean_wave:
	rm -f *.vcd* 

.PHONY: test test_wave clean clean_obj clean_wave