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
module edge_detector(   input x, 
                        input clk, 
                        input reset, 
                        output reg pos_edge, 
                        output reg neg_edge
                        );
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

module time_calc(   input pos_edge, 
                    input neg_edge, 
                    input clk, 
                    input reset, 
                    output reg [15:0] counter, 
                    output reg [15:0] pulse_width
                    ); //considering max freq of 50MHz, and 65535 clock cycles
    reg counting;
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

module time_period( input x,
                    input clk, 
                    input reset, 
                    input pos_edge, 
                    input neg_edge, 
                    output reg [15:0] tp, 
                    output reg counting_tp, 
                    output reg [15:0] counter_tp, 
                    output reg iterator
                    );
    always @(posedge clk) begin
        if (reset) begin
            tp <= 0;
            counting_tp <= 0;
            iterator <= 1;
        end else begin
            if (pos_edge) begin
                if (iterator) begin    
                    counting_tp <= 1;
                    iterator <= ~iterator;
                    counter_tp <= 1;
                end else begin
                    tp <= counter_tp; // if it is the second pos_edge of input then store period value
                    iterator <= ~iterator;
                    counting_tp <= 0;
                end
            end
            if (counting_tp) begin
                counter_tp <= counter_tp + 1;
            end
        end
    end
endmodule

module frequency(
    input clk,
    input [15:0] tp,
    output reg [15:0] freq
);
    parameter clock_freq = 100;//100MHz clock frequency

    always @(posedge clk) begin
        if (tp > 0) begin
            freq <= clock_freq / tp;
        end else begin
            freq <= 0;
        end
    end
    
endmodule

module top( input x, 
            input clk, 
            input reset, 
            output wire [15:0] pulse_width, 
            // output wire [15:0] counter, 
            output wire [15:0] counter_tp,
            // output wire counting, 
            output wire counting_tp, 
            output wire pos_edge, 
            output wire neg_edge, 
            output wire iterator,
            output wire [15:0] tp,
            output wire [15:0] freq
            );

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
        .pulse_width(pulse_width)
        // .counting(counting)
    );

    time_period time_period_inst(
        .x(x),
        .clk(clk),
        .reset(reset),
        .pos_edge(pos_edge),
        .tp(tp),
        .counting_tp(counting_tp),
        .counter_tp(counter_tp),
        .iterator(iterator)
    ); 

    frequency frequency_inst(
        .clk(clk),
        .tp(tp),
        .freq(freq)
    );
endmodule