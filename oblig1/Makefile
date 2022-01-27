all: work-obj08.cf run

work-obj08.cf: first.vhd tb_first.vhd
	ghdl analyze --std=08 first.vhd tb_first.vhd
	ghdl elaborate --std=08 test_first

wave run: work-obj08.cf
	ghdl run --std=08 test_first --wave=wave.ghw
