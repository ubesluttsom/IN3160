vcom -work work -2008 -explicit -vopt -stats=none /uio/hume/student-u82/martimn/in3160/oblig2/decoder.vhd
vcom -work work -2008 -explicit -vopt -stats=none /uio/hume/student-u82/martimn/in3160/oblig2/case_decoder.vhd
vsim -voptargs=+acc work.tb_decoder
add wave -position insertpoint  \
sim:/tb_decoder/tb_sw_case \
sim:/tb_decoder/tb_ld_case
run -all