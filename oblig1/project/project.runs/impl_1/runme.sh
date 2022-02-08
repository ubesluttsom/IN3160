#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/opt/ifi/Xilinx/Vitis/2020.2/bin:/opt/ifi/Xilinx/Vivado/2020.2/ids_lite/ISE/bin/lin64:/opt/ifi/Xilinx/Vivado/2020.2/bin
else
  PATH=/opt/ifi/Xilinx/Vitis/2020.2/bin:/opt/ifi/Xilinx/Vivado/2020.2/ids_lite/ISE/bin/lin64:/opt/ifi/Xilinx/Vivado/2020.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/uio/hume/student-u82/martimn/in3160/oblig1/project/project.runs/impl_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

# pre-commands:
/bin/touch .write_bitstream.begin.rst
EAStep vivado -log FIRST.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source FIRST.tcl -notrace

