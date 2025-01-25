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

        // Test Case 1: Add two normalized positive numbers
        #10;
        i_valid = 1;
        i_a = 16'b0100010100000000; // +5.0
        i_b = 16'b0100001000000000; // +2.5
        // Expected output: o_res = 0110011000000000 (+7.5), Overflow = 0
        #10 i_valid = 0;

        // Test Case 2: Add a positive and a negative number
        #20;
        i_valid = 1;
        i_a = 16'b0100010100000000; // +5.0
        i_b = 16'b1100001000000000; // -2.5
        // Expected output: o_res = 0100001000000000 (+2.5), Overflow = 0
        #10 i_valid = 0;

        // Test Case 3: Add two negative numbers
        #20;
        i_valid = 1;
        i_a = 16'b1100010100000000; // -5.0
        i_b = 16'b1100001000000000; // -2.5
        // Expected output: o_res = 1110011000000000 (-7.5), Overflow = 0
        #10 i_valid = 0;

        // Test Case 4: Add numbers with different exponents
        #20;
        i_valid = 1;
        i_a = 16'b0100010100000000; // +5.0
        i_b = 16'b0100110000000000; // +48.0
        // Expected output: o_res = 0100110010100000 (+53.0), Overflow = 0
        #10 i_valid = 0;

        // Test Case 5: Overflow occurs
        #20;
        i_valid = 1;
        i_a = 16'b0111101111111111; // Maximum positive value (~65504.0)
        i_b = 16'b0100110000000000; // +48.0
        // Expected output: o_res = Undefined, Overflow = 1
        #10 i_valid = 0;

        // Test Case 6: Add zero to a number
        #20;
        i_valid = 1;
        i_a = 16'b0100010100000000; // +5.0
        i_b = 16'b0000000000000000; // 0.0
        // Expected output: o_res = 0100010100000000 (+5.0), Overflow = 0
        #10 i_valid = 0;

        // Test Case 7: Both inputs are zero
        #20;
        i_valid = 1;
        i_a = 16'b0000000000000000; // 0.0
        i_b = 16'b0000000000000000; // 0.0
        // Expected output: o_res = 0000000000000000 (0.0), Overflow = 0
        #10 i_valid = 0;

        // End simulation
        #50;
        $finish;
    end

endmodule
