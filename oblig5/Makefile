.PHONY = all clean run

all: work-obj08.cf

clean:
	rm work-obj08.cf

run: work-obj08.cf
	ghdl run --std=08 tb_pargen --wave=wave.ghw

work-obj08.cf: subprog_pck.vhd pargen.vhd tb_pargen.vhd
	ghdl analyze --std=08 $^
	ghdl elaborate --std=08 tb_pargen
