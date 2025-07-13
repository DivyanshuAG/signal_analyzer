`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2025 08:43:48 PM
// Design Name: 
// Module Name: signal_analyzer
// Project Name: signal_analyzer
// Target Devices: 
// Tool Versions: 
// Description: Find the different properties of a uniform square wave
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module edge_detector(input x, input clk, input reset, output reg pos_edge, output reg neg_edge);
    reg x_prev;
    always @(posedge clk) begin
        if (reset) begin
            x_prev<=0;
            pos_edge<=0;
            neg_edge<=0;
        end else begin
            x_prev<=x;
            pos_edge <= (~x_prev) & x;
            neg_edge <= x_prev & (~x);
        end
    end
endmodule

module time_calc(input pos_edge, input neg_edge, input clk, input reset, output reg [15:0] counter, output reg [15:0] pulse_width, output reg counting); //considering max freq of 50MHz, and 65535 clock cycles
    // reg counting;
    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            counting <= 0;
            pulse_width <= 0;
        end else begin
            if (pos_edge) begin
                counting <= 1;
                counter <= 1;
            end
            else if (neg_edge) begin
                counting <= 0;
                pulse_width <= counter;
            end
            
            if (counting) begin
                counter <= counter + 1;
            end
        end
    end
endmodule

module top(input x, input clk, input reset, output wire [15:0] pulse_width, output wire [15:0] counter, output pos_edge, output neg_edge, output counting);
    // wire pos_edge, neg_edge;
    // wire [15:0] counter;
    edge_detector edge_detector_inst(
        .x(x),
        .clk(clk),
        .reset(reset),
        .pos_edge(pos_edge),
        .neg_edge(neg_edge)
    );

    time_calc time_calc_inst(
        .clk(clk),
        .reset(reset),
        .pos_edge(pos_edge),
        .neg_edge(neg_edge),
        .counter(counter),
        .pulse_width(pulse_width),
        .counting(counting)
    );
    
endmodule