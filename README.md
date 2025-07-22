# Digital Signal Analyzer using Verilog

## Overview

This project implements a digital signal analyzer in Verilog. It takes in a digital square wave and extracts key signal properties such as **pulse width**, **time period**, **frequency** and **duty cycle** using synchronous logic.
All modules are tested and verified using Xilinx Vivado Simulator with a 100 MHz system clock.

## Completed Features

### 1. Edge Detection Module
- Detects both **positive** and **negative** edge of the input signal (`x`)
- Provides `pos_edge` and `neg_edge` signals that go high for one clock cycle when an edge is detected

### 2. Pulse Width Measurement Module
- Measures the duration of a high pulse
- Starts counting on positive edge and stops on corresponding negative edge
- The smallest unit of time that can be measured is one clock cycle (10 ns)

### 3. Time Period Measurement Module
- Measures the time between two consecutive positive edges of the input signal
- Generates a `tp_valid` pulse to indicate when a new, stable measurement is ready

### 4. Frequency Calculation Module
- Calculates the frequency of the input signal using the formula:  
  `frequency = clock_frequency / time_period per clock cycle`
- The calculation is triggered by the `tp_valid` signal to ensure utilization of stable data only

### 5. Duty Cycle Calculation Module
- Calculates the duty cycle of the input signal as a % using the formula:
  `duty_cycle = (pulse_width / time_period_per_clock_cycle) * 100`
- This calculation is also triggered by the `tp_valid` signal
> Note: Hardware division is resource intensive. While the frequency and duty cycle modules have been implemented here to complete the simulation model, during final implementation they would be offloaded to software for an efficient design.

### 5. Testbench
- Simulates a uniform square wave
- Verifies:
  - Correct rising and falling edge detection
  - Accurate pulse width measurement
  - Correct time period detection
  - Frequency updates after time period changes

## Technical Notes
- **Clock Frequency**: 100 MHz (10 ns period)
- **Resolution**: All time-based measurements are limited to 1 clock cycle, resulting in a **least count of 10ns**
- **Tools**:
  - Verilog HDL
  - Vivado Simulator (Xilinx)