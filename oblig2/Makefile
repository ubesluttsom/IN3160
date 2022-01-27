.PHONY = all clean run

all: work-obj08.cf

clean:
	rm work-obj08.cf

run: wave.ghw

work-obj08.cf: decoder.vhd case_decoder.vhd tb_decoder.vhd
	ghdl analyze --std=08 $^
	ghdl elaborate --std=08 tb_decoder

wave.ghw: work-obj08.cf
	ghdl run --std=08 tb_decoder --wave=$@
