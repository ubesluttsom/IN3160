.PHONY = all clean run

all: work-obj08.cf

clean:
	rm work-obj08.cf

run: work-obj08.cf
	ghdl run --std=08 tb_shift8  --wave=tb_shift8.ghw
	ghdl run --std=08 tb_shift32 --wave=tb_shift32.ghw
	ghdl run --std=08 tb_shiftn  --wave=tb_shiftn.ghw

work-obj08.cf: dff.vhd shift8.vhd tb_shift8.vhd shift32.vhd tb_shift32.vhd \
	shiftn.vhd tb_shiftn.vhd
	ghdl analyze --std=08 $^
	ghdl elaborate --std=08 tb_shift8
	ghdl elaborate --std=08 tb_shift32
	ghdl elaborate --std=08 tb_shiftn
