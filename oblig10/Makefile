.PHONY = all clean run pandoc work-obj08.cf

VHDL = rom.vhd self_test_module.vhd tb_self_test_module.vhd \
		   pulse_width_modulator.vhd tb_pwm_module.vhd
SRCS = $(addprefix src/, $(VHDL))


all: work-obj08.cf

clean:
	rm work-obj08.cf

run: work-obj08.cf
	# ghdl run --std=08 tb_self_test_module --wave=tb_self_test_module.ghw
	ghdl run --std=08 tb_pulse_width_modulator --wave=tb_pwm_module.ghw

work-obj08.cf: $(SRCS)
	ghdl analyze --std=08 $^
	# ghdl elaborate --std=08 tb_self_test_module
	# ghdl elaborate --std=08 tb_pulse_width_modulator
