all:
	ghdl analyze --std=08 *.vhd
	ghdl elaborate --std=08 tb_compute_pipelined
	ghdl run --std=08 tb_compute_pipelined --wave=tb_compute_pipelined.ghw
