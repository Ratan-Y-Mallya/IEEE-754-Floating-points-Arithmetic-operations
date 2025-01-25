// `include "addition_s.v"
// `include "compare_and_shift.v"
// `include "normalisation.v"


// module adder_single_cycle (
//     input clk,                 // Clock signal
//     input rst,                 // Reset signal
//     input i_valid,             // Input valid signal
//     input [15:0] i_a,          // IEEE 754 input A
//     input [15:0] i_b,          // IEEE 754 input B
//     output reg [15:0] o_res,   // IEEE 754 normalized result
//     output  Overflow,       // Overflow flag
//     output reg o_res_vld       // Output result valid signal
// );

//     // Internal wires
//    wire [12:0] mantisa1_w,mantisa2_w;
//    wire [4:0] exp1_w,exp2_w;
//    wire [12:0] mantisa1_new_w,mantisa2_new_w;
//    wire [4:0]new_exp_w,exp_out_w; 
//    wire [13:0] mantisa_out_w;
//    wire sign_out_w,overflow_flag_w;
//    wire [10:0] mantisa_out;
//    wire  zero_a,zero_b,exception_a,exception_b,zero_ip;
//    wire  [15:0] res;

// always @(posedge clk)
// begin
// 	if(rst)
// 	begin
// 		o_res <= 16'd0;
// 		o_res_vld <= 1'b0;
        
// 	end
	
// 	else 
// 	begin
// 		o_res <= res;
// 		o_res_vld <= i_valid;
        
// 	end
	
// end


// assign exception_a=(&i_a[14:10]);
// assign exception_b=(&i_b[14:10]);
// assign zero_a=!(|i_a[14:0]);
// assign zero_b=!(|i_b[14:0]);
// assign zero_ip= zero_a && zero_b;



// assign mantisa1_w = (|i_a[14:10]) ? {3'b001,i_a[9:0]} : {3'b000,i_a[9:0]};   // assigned 13 bits		  
// assign mantisa2_w = (|i_b[14:10]) ? {3'b001,i_b[9:0]} : {3'b000,i_b[9:0]};


  

//     // Submodule instances
//     compare_and_shift u_compare_and_shift (
//         .mantisa1(mantisa1_w),
//         .mantisa2(mantisa2_w),
//         .exp1(i_a[14:10]),
//         .exp2(i_b[14:10]),
//         .mantisa1_new(mantisa1_new_w),
//         .mantisa2_new(mantisa2_new_w),
//         .new_exp(new_exp_w)
//     );

//     addition_s u_addition_s (
//          .mantisa1(mantisa1_new_w),
//          .mantisa2(mantisa2_new_w),
//          .sign1(i_a[15]),
//          .sign2(i_b[15]),
//          .mantisa_out(mantisa_out_w)
        
//     );

//     normalization u_normalisation (
//          .mantisa(mantisa_out_w),
//          .exp(new_exp_w),
//          .mantisa_out(mantisa_out),
//          .exp_out(exp_out_w),
//          .overflow_flag(Overflow),
//         .sign_res(sign_out_w)
//     );

//   assign res=(zero_ip?({sign_out_w,15'd0}):exception_a?{i_a[15],5'b11111,10'b0}:exception_b?{i_b[15],5'b11111,10'b0}:Overflow?{1'b0,5'b11111,10'b0}:zero_a?i_b:zero_b?i_a:{sign_out_w,exp_out_w,mantisa_out[9:0]});


// endmodule


`include "addition_s.v"
`include "compare_and_shift.v"
`include "normalisation.v"

module adder_single_cycle (
    input clk,                  // Clock signal
    input rst,                  // Reset signal
    input i_valid,              // Input valid signal
    input [15:0] i_a,           // IEEE 754 input A
    input [15:0] i_b,           // IEEE 754 input B
    output reg [15:0] o_res,    // IEEE 754 normalized result
    output reg Overflow,        // Overflow flag
    output reg o_res_vld        // Output result valid signal
);

    // Internal wires
    wire [12:0] mantisa1_w, mantisa2_w;
    wire [4:0] exp1_w, exp2_w;
    wire [12:0] mantisa1_new_w, mantisa2_new_w;
    wire [4:0] new_exp_w, exp_out_w; 
    wire [13:0] mantisa_out_w;
    wire sign_out_w, overflow_flag_w;
    wire [10:0] mantisa_out;
    wire zero_a, zero_b, exception_a, exception_b, zero_ip;
    wire [15:0] res;

    // Registers for synchronized outputs
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o_res <= 16'd0;
            o_res_vld <= 1'b0;
            Overflow <= 1'b0;
        end else begin
            o_res <= res;
            o_res_vld <= i_valid;
            Overflow <= overflow_flag_w;
        end
    end

    // Exception and zero handling
    assign exception_a = (&i_a[14:10]);
    assign exception_b = (&i_b[14:10]);
    assign zero_a = !(|i_a[14:0]);
    assign zero_b = !(|i_b[14:0]);
    assign zero_ip = zero_a && zero_b;

    // Mantissa extraction
    assign mantisa1_w = (|i_a[14:10]) ? {3'b001, i_a[9:0]} : {3'b000, i_a[9:0]};   // Assigned 13 bits		  
    assign mantisa2_w = (|i_b[14:10]) ? {3'b001, i_b[9:0]} : {3'b000, i_b[9:0]};

    // Submodule instances
    compare_and_shift u_compare_and_shift (
        .mantisa1(mantisa1_w),
        .mantisa2(mantisa2_w),
        .exp1(i_a[14:10]),
        .exp2(i_b[14:10]),
        .mantisa1_new(mantisa1_new_w),
        .mantisa2_new(mantisa2_new_w),
        .new_exp(new_exp_w)
    );

    addition_s u_addition_s (
        .mantisa1(mantisa1_new_w),
        .mantisa2(mantisa2_new_w),
        .sign1(i_a[15]),
        .sign2(i_b[15]),
        .mantisa_out(mantisa_out_w)
    );

    normalization u_normalisation (
        .mantisa(mantisa_out_w),
        .exp(new_exp_w),
        .mantisa_out(mantisa_out),
        .exp_out(exp_out_w),
        .overflow_flag(overflow_flag_w),
        .sign_res(sign_out_w)
    );

    // Output result assignment
    assign res = (overflow_flag_w) ? {1'b0, 5'b11111, 10'b0} : // Handle overflow as infinity
                 (zero_ip) ? {sign_out_w, 15'd0} :       // Both inputs are zero
                 (exception_a) ? {i_a[15], 5'b11111, 10'b0} : // Handle exception in A
                 (exception_b) ? {i_b[15], 5'b11111, 10'b0} : // Handle exception in B
                 (zero_a) ? i_b :                       // A is zero
                 (zero_b) ? i_a :                       // B is zero
                 {sign_out_w, exp_out_w, mantisa_out[9:0]}; // Normalized result

endmodule
