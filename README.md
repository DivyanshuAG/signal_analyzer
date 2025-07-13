# Digital Signal Analyzer (Verilog)

## Overview

This project implements a digital signal analyzer in Verilog.  
It detects edges on a digital input signal and measures the pulse width (i.e., the time for which the signal remains high). This design has been tested and simulated using Xilinx Vivado.

## Completed Features

### 1. Edge Detection Module
- Detects **positive (rising)** and **negative (falling)** edges of a digital input signal (`x`)
- Operates synchronously with a `clk` signal
- Includes asynchronous reset functionality

### 2. Pulse Width Measurement Module
- Starts counting clock cycles on a rising edge of the input
- Stops counting on the falling edge
- Stores the pulse width (in clock cycles) using a 16-bit counter
- Handles reset and properly latches the output

### 3. Testbench
- Simulates multiple test scenarios with various pulse widths
- Confirms edge detection and timing behavior
- Verifies that short pulses below 1 clock cycle are ignored, as expected

## Technical Notes
- Clock frequency used in simulation: **100 MHz** (10 ns period)
- Timing resolution is limited to one clock cycle
- Outputs are updated on the rising edge following detection, as per synchronous design behavior
- Vivado simulation confirms functional correctness

## Tools Used
- Verilog HDL
- Vivado Simulator (Xilinx)
