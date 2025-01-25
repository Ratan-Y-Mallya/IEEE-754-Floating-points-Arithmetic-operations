module compare_and_shift (
    input [12:0] mantisa1,           // 10-bit mantissa of input 1
    input [12:0] mantisa2,           // 10-bit mantissa of input 2
    input [4:0] exp1,               // 5-bit exponent of input 1
    input [4:0] exp2,               // 5-bit exponent of input 2
    output reg [12:0] mantisa1_new, // 11-bit aligned mantissa of input 1
    output reg [12:0] mantisa2_new, // 11-bit aligned mantissa of input 2
    output reg [4:0] new_exp        // 5-bit aligned exponent
);

    wire [4:0] exp_dif;              // Exponent difference
    

    // Calculate exponent difference
    assign exp_dif = (exp1 > exp2) ? (exp1 - exp2) : (exp2 - exp1);

    always @(*) begin
        // Initialize outputs to avoid latches
        mantisa1_new = 0;
        mantisa2_new = 0;
        new_exp = 0;

       
        // Align mantissas based on exponent difference
        if (exp1 > exp2) begin
            mantisa1_new = mantisa1;              // Keep mantisa1 as is
            mantisa2_new = mantisa2 >> exp_dif;   // Right-shift mantisa2
            new_exp = exp1+8'd1;                        // Use the larger exponent
        end else if (exp1 < exp2) begin
            mantisa1_new = mantisa1 >> exp_dif;   // Right-shift mantisa1
            mantisa2_new = mantisa2;              // Keep mantisa2 as is
            new_exp = exp2+8'd1;                        // Use the larger exponent
        end else begin
            mantisa1_new = mantisa1;              // Exponents are the same
            mantisa2_new = mantisa2;              // No need to shift
            new_exp = exp1+8'd1;                        // Exponents are equal
        end
    end

endmodule
