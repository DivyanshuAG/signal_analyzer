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

// tp gives number of clock cycles between two rising edges
// time period in seconds = tp * 10 ns (10 ns is the time period of each clock)
module time_period( input clk, 
                    input reset, 
                    input pos_edge, 
                    output reg [15:0] tp, 
                    output reg [15:0] counter_tp,
                    output reg tp_valid 
                    );
    reg first_edge_passed;
    always @(posedge clk) begin
        if (reset) begin
            tp <= 0;
            counter_tp <= 1;
            first_edge_passed <= 0;
        end else begin
            tp_valid <= 0;
            counter_tp <= counter_tp + 1;
            if (first_edge_passed == 0) begin
                counter_tp <= 1;
            end
            if (pos_edge) begin
                if (first_edge_passed) begin
                    tp_valid <= 1;
                end
                first_edge_passed <= 1;
                tp <= counter_tp;
                counter_tp <= 1;
            end
        end
    end
endmodule

module frequency(
    input clk,
    input reset,
    input [15:0] tp,
    input tp_valid,
    output reg [15:0] freq
);
    parameter clock_freq = 100;//100MHz clock frequency

    always @(posedge clk) begin
        if (reset) begin
            freq <= 0;
        end else if (tp_valid) begin            
            if (tp > 0) begin
                freq <= clock_freq / tp;
            end else begin
                freq <= 0;
            end
        end
    end
endmodule

module duty_cycle (
    input clk,
    input reset,
    input [15:0] tp,
    input [15:0] pulse_width,
    input tp_valid,
    output reg [15:0] duty_cycle
);
    always @(posedge clk) begin
        if (reset) begin
            duty_cycle <= 0;
        end else if (tp_valid) begin            
            if (tp != 0) begin
                duty_cycle <= 100 * pulse_width/tp;
            end
            else begin
                duty_cycle <= 0;
            end
        end
    end
endmodule

module top( input x, 
            input clk, 
            input reset, 
            output wire [15:0] pulse_width, 
            output wire [15:0] counter_tp,
            output wire tp_valid,
            output wire pos_edge, 
            output wire neg_edge, 
            output wire [15:0] tp,
            output wire [15:0] freq,
            output wire [15:0] duty_cycle
            );

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
    );

    time_period time_period_inst(
        .clk(clk),
        .reset(reset),
        .pos_edge(pos_edge),
        .tp(tp),
        .tp_valid(tp_valid),
        .counter_tp(counter_tp)
    ); 

    frequency frequency_inst(
        .clk(clk),
        .reset(reset),
        .tp(tp),
        .tp_valid(tp_valid),
        .freq(freq)
    );

    duty_cycle duty_cycle_inst(
        .clk(clk),
        .reset(reset),
        .tp(tp),
        .tp_valid(tp_valid),
        .pulse_width(pulse_width),
        .duty_cycle(duty_cycle)
    );
endmodule