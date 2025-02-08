`timescale 1ns/1ps

module tb_adder_single_cycle;

    // Inputs
    reg clk;
    reg rst;
    reg i_valid;
    reg [15:0] i_a;
    reg [15:0] i_b;

    // Outputs
    wire [15:0] o_res;
    wire Overflow;
    wire o_res_vld;

    // Instantiate the Unit Under Test (UUT)
    adder_single_cycle uut (
        .clk(clk),
        .rst(rst),
        .i_valid(i_valid),
        .i_a(i_a),
        .i_b(i_b),
        .o_res(o_res),
        .Overflow(Overflow),
        .o_res_vld(o_res_vld)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test cases
    initial begin
        // Monitor signals
        $monitor("Time: %0d | i_a: %b | i_b: %b | o_res: %b | Overflow: %b | o_res_vld: %b", 
                 $time, i_a, i_b, o_res, Overflow, o_res_vld);

        // Initialize dumpfile for waveform
        $dumpfile("adder_single_cycle.vcd");
        $dumpvars(0, tb_adder_single_cycle);

        // Initialize inputs
        rst = 1;
        i_valid = 0;
        i_a = 0;
        i_b = 0;

        // Reset the system
        #10 rst = 0;

        // Test Case 1: Basic positive numbers addition
        #10;
        i_valid = 1;
        i_a = 16'b0100010100000000; // +5.0 (sign=0, exp=8, mantissa=5.0)
        i_b = 16'b0100001000000000; // +2.0 (sign=0, exp=8, mantissa=2.0)
        #10 i_valid = 0;
        #20;

        // Test Case 2: Different exponents
        i_valid = 1;
        i_a = 16'b0100011000000000; // +8.0 (sign=0, exp=8, mantissa=8.0)
        i_b = 16'b0011110000000000; // +1.0 (sign=0, exp=7, mantissa=1.0)
        #10 i_valid = 0;
        #20;

        // Test Case 3: Subtraction (positive - negative)
        i_valid = 1;
        i_a = 16'b0100010100000000; // +5.0
        i_b = 16'b1100001000000000; // -2.0
        #10 i_valid = 0;
        #20;

        // Test Case 4: Numbers requiring normalization
        i_valid = 1;
        i_a = 16'b0011110000010000; // 1.001
        i_b = 16'b0011110000100000; // 1.002
        #10 i_valid = 0;
        #20;

        // Test Case 5: Overflow test
        i_valid = 1;
        i_a = 16'b0111101111111111; // Max normal number
        i_b = 16'b0100110000000000; // Large positive
        #10 i_valid = 0;
        #20;

        // Test Case 6: Addition with large exponent difference
        i_valid = 1;
        i_a = 16'b0101010100000000; // Large exponent
        i_b = 16'b0011010100000000; // Small exponent
        #10 i_valid = 0;
        #20;

        // Test Case 7: Equal magnitude opposite signs
        i_valid = 1;
        i_a = 16'b0100010100000000; // +5.0
        i_b = 16'b1100010100000000; // -5.0
        #10 i_valid = 0;
        #20;

        // Test Case 8: Zero plus number
        i_valid = 1;
        i_a = 16'b0100010100000000; // +5.0
        i_b = 16'b0000000000000000; // 0.0
        #10 i_valid = 0;
        #20;

        // Test Case 9: Both zeros
        i_valid = 1;
        i_a = 16'b0000000000000000; // 0.0
        i_b = 16'b0000000000000000; // 0.0
        #10 i_valid = 0;
        #20;

        // Test Case 10: Both negative numbers
        i_valid = 1;
        i_a = 16'b1100010100000000; // -5.0
        i_b = 16'b1100001000000000; // -2.0
        #10 i_valid = 0;
        #20;

        // Test Case 11: Close to overflow
        i_valid = 1;
        i_a = 16'b0111101000000000; // Very large positive
        i_b = 16'b0111100000000000; // Large positive
        #10 i_valid = 0;
        #20;

        // Test Case 12: Small numbers addition
        i_valid = 1;
        i_a = 16'b0000110000000000; // Very small positive
        i_b = 16'b0000110000000000; // Very small positive
        #10 i_valid = 0;
        #20;

        // End simulation
        #50 $finish;
    end
    endmodule