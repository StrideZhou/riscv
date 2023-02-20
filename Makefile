DUT_TOP = top_tb

test: ./obj_dir/V$(DUT_TOP)
	./obj_dir/V$(DUT_TOP)
test_wave: *.vcd
	gtkwave  -o -z -c 8 -W \
	# -t ./obj_dir/V$(DUT_TOP).stems \
	# https://github.com/gtkwave/gtkwave/issues/139
	-f ./wave.vcd ./wave.gtkw

*.vcd: ./obj_dir/V$(DUT_TOP)
	./obj_dir/V$(DUT_TOP) +trace

./obj_dir/V$(DUT_TOP): $(DUT_TOP).sv sim_main.cpp 
	verilator -Wno-lint -Wno-style -Wno-context -j 8 \
		--trace --trace-threads 2 \
		# --xml-output ./obj_dir/V$(DUT_TOP).xml \
		-sv --cc --exe --build sim_main.cpp $(DUT_TOP).sv \
		# xml2stems -V ./obj_dir/V$(DUT_TOP).xml ./obj_dir/V$(DUT_TOP).stems \
		# https://github.com/gtkwave/gtkwave/issues/139

clean:
	rm -rf ./obj_dir wave.vcd* 

.PHONY: test test_wave clean