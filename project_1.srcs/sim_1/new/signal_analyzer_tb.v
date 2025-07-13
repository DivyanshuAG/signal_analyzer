`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2025 08:44:21 PM
// Design Name: 
// Module Name: signal_analyzer_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top_tb;
    reg clk;
    reg reset;
    reg x;
    wire [15:0] pulse_width;
    wire [15:0] counter_tp;
    wire pos_edge;
    wire neg_edge;
    wire counting_tp;
    wire [15:0] tp;
    wire iterator;
    wire [15:0] freq;
    
    top dut( .x(x),
            .clk(clk),
            .reset(reset),
            .pulse_width(pulse_width),
            .counting_tp(counting_tp),
            .counter_tp(counter_tp),
            .pos_edge(pos_edge),
            .neg_edge(neg_edge),
            .tp(tp),
            .iterator(iterator),
            .freq(freq)
    );

    initial begin
        clk = 0;
        forever #5 clk=~clk;
    end

    initial begin
        reset = 1;
        x = 0;
        #20;
        reset = 0;
        // Uniform square wave (100 ns period: 40 ns HIGH, 60 ns LOW)
        forever begin
            x = 1;
            #60;
            x = 0;
            #60;
        end
    end

    initial begin
        $monitor("T=%0t | x=%b | pos_edge=%b | neg_edge=%b | pulse_width=%d", $time, x, dut.pos_edge, dut.neg_edge, pulse_width);
    end

endmodule