.PHONY = all clean run wave

all: work-obj08.cf

clean:
	rm work-obj08.cf

wave: tb_delay.ghw tb_variables_vs_signals.ghw
	gtkwave $^

tb_delay.ghw: work-obj08.cf
	ghdl run --std=08 tb_delay --wave=tb_delay.ghw

tb_variables_vs_signals.ghw: work-obj08.cf
	ghdl run --std=08 tb_variables_vs_signals --wave=tb_variables_vs_signals.ghw

work-obj08.cf: delay.vhd tb_delay.vhd variables_vs_signals.vhd tb_variables_vs_signals.vhd
	ghdl analyze --std=08 $^
	ghdl elaborate --std=08 tb_delay
	ghdl elaborate --std=08 tb_variables_vs_signals
