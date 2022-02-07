vcom -work work -2008 -explicit -vopt -stats=none decoder.vhd
vcom -work work -2008 -explicit -vopt -stats=none case_decoder.vhd
vcom -work work -2008 -explicit -vopt -stats=none tb_decoder.vhd
vsim -voptargs=+acc work.tb_decoder
add wave -position insertpoint  \
sim:/tb_decoder/tb_sw_case \
sim:/tb_decoder/tb_ld_case
run -all