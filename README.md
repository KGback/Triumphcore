# Triumphcore
Focus on the experimental creation of CPU archtecture based on risc-v


# DV version record
Considering that there will be more versions in the future, I would record the designing-and-verifying process and changes in this blog.
The link: https://blog.csdn.net/qq_39815222/article/details/111386853

# Quick start

Firstly, you should prepare the simulator and risc-v tools. This project use xcelium as the example simulating.

## Build gcc-toolchains

refer to the link: https://github.com/riscv/riscv-gnu-toolchain

## Begin to test

 % cd sim
 
 % make sanity

After open simvision, you can source sim/scripts/signals.svwf in the cadence console, the you will see the output of critical signals with different colors.
