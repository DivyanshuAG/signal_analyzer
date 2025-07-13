# Digital Signal Analyzer (Verilog)

## Overview

This project implements a digital signal analyzer in Verilog. It takes in a digital square wave and extracts key signal properties such as pulse width, time period, and frequency using synchronous logic.
All modules are tested and verified using Xilinx Vivado with a 100 MHz system clock.

## Completed Features

### 1. Edge Detection Module
- Detects both **positive** and **negative** edge of the input signal (`x`)
- Operates synchronously with the `clk` signal
- Provides `pos_edge` and `neg_edge` signals that go high for one clock cycle when an edge is detected
- Includes asynchronous reset functionality

### 2. Pulse Width Measurement Module
- Starts counting on the positive edge of the input signal
- Stops counting on the negative edge
- Stores the pulse width (in clock cycles) in a 16-bit register
- Short pulses (below 1 clock cycle) are ignored due to synchronous operation

### 3. Time Period Measurement Module
- Measures the time between two consecutive positive edges of the input signal
- Uses internal control logic to distinguish between the first and second edge.
- Stores the result in a 16-bit register (`tp`)

### 4. Frequency Calculation Module
- Computes the frequency of the input signal using the formula:  
  `frequency = clock_frequency / time_period`
- Uses integer division, so only the whole number part of the result is kept.  
  For example, a 12-cycle period at 100 MHz results in `8 MHz` (the actual frequency is 8.33 MHz).
- Output updates one clock cycle after the time period is captured
> Note: Floating-point division (e.g., to show 8.33 MHz) can be implemented for simulation, but this is not synthesizable for FPGA hardware

### 5. Testbench
- Simulates a uniform square wave
- Verifies:
  - Correct rising and falling edge detection
  - Accurate pulse width measurement
  - Correct time period detection
  - Frequency updates after time period changes

## Technical Notes
- **Clock Frequency**: 100 MHz (10 ns period)
- **Resolution**: All time-based measurements are limited to 1 clock cycle
- **Tools**:
  - Verilog HDL
  - Vivado Simulator (Xilinx)