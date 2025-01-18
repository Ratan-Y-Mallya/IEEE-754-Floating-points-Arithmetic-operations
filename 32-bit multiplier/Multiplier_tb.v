// `include "Multiplier.v"

module multiplier_tb ;
reg [31:0] in1,in2;
wire [31:0]final;

    multiplier dut (.in1(in1),.in2(in2),.final(final));

initial begin

      // Test cases
    // Input values are in IEEE 754 format
    in1 = 32'h3F800000; // 1.0
    in2 = 32'h40000000; // 2.0
    #10  // Expected 2.0

    in1 = 32'hC0000000; // -2.0
    in2 = 32'h40000000; // 2.0
    #10  // Expected -4.0

    in1 = 32'h40400000; // 3.0
    in2 = 32'h40400000; // 3.0
    #10  // Expected 9.0

    in1 = 32'h3F800000; // 1.0
    in2 = 32'h00000000; // 0.0
    #10  // Expected 0.0

    in1 = 32'h7F800000; // Infinity
    in2 = 32'h3F800000; // 1.0
    #10  // Expected Infinity

    in1 = 32'h7F800000; // Infinity
    in2 = 32'h7F800000; // Infinity
    #10  // Expected Infinity

    in1 = 32'h7F800000; // Infinity
    in2 = 32'hFF800000; // -Infinity
    #10  // Expected -Infinity

    in1 = 32'hFFFFFFFF; // NaN
    in2 = 32'h3F800000; // 1.0
    #10  // Expected NaN

    // End simulation
     $finish;
end
 initial begin
        $dumpfile("top_dump.vcd");
        $dumpvars(0);
    end

endmodule