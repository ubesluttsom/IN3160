.PHONY = all clean run pandoc

all: work-obj08.cf

clean:
	rm work-obj08.cf

run: work-obj08.cf
	ghdl run --std=08 tb_bin2ssd --wave=tb_bin2ssd.ghw
	ghdl run --std=08 tb_seg7ctrl --wave=tb_seg7ctrl.ghw

work-obj08.cf: bin2ssd.vhd seg7model_ent.vhd seg7model_beh.vhd tb_bin2ssd.vhd seg7ctrl.vhd tb_seg7ctrl.vhd seg7ctrl_arch.vhd tb_seg7ctrl_arch.vhd
	ghdl analyze --std=08 $^
	ghdl elaborate --std=08 tb_bin2ssd
	ghdl elaborate --std=08 tb_seg7ctrl

pandoc:
	pandoc oblig6.md -o oblig6.pdf -C --pdf-engine xelatex
