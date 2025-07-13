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
    wire [15:0] counter;
    wire pos_edge;
    wire neg_edge;
    wire counting;
    
    top dut( .x(x),
            .clk(clk),
            .reset(reset),
            .pulse_width(pulse_width),
            .counting(counting),
            .counter(counter),
            .pos_edge(pos_edge),
            .neg_edge(neg_edge)
    );

    initial begin
        clk = 0;
        forever #5 clk=~clk;
    end

    initial begin
        reset=1;
        x=0;
        #15;
        reset=0;

        #3 x=1;
        #30 x=0;
        #12 x=1;
        #10 x=0;
        #6 x=1;
        #4 x=0;
        #10 x=1;
        #90 x=0;

        #20 $finish;
    end
    initial begin
        $monitor("T=%0t | x=%b | pos_edge=%b | neg_edge=%b | pulse_width=%d", $time, x, dut.pos_edge, dut.neg_edge, pulse_width);
    end

endmodule