# 64-bit Arithmetic and Logic cores for basic operations

-----------------------------------------------------------------------

## About

This repository contains the SystemVerilog implementations of various 64-bit arithmetic and logic cores. The main reason behind this repository is to implement different algorithms for multiplication, division etc. and to integrate them further in my future projects.

For now, the focus is on building and testing the cores with `verilator` using C++ testbenches. You can know more about `verilator` [here](https://www.veripool.org/verilator/).

## Core documentation

The repository consists of several directories containing the RTL and testbench code corresponding to each core as listed below.

- `adder_subtractor` : 64-bit Adder-Subtractor core

- `barrel-shifter` : 64-bit Barrel shifter core  

## Simulating and running the core

Switch to the `tb` directory in the core you wish to simulate and run,

    make MODULE_NAME:=<module_name> simulate

The executable will be generated inside `obj_dir`. You can run it by typing,

    make MODULE_NAME:=<module_name> run

Optionally, clean the directory using `make clean`