module divider (in1,in2,final);

// initalize i/o port
input [31:0] in1,in2;
output [31:0]final;

// interim wire
wire [23:0]M1,M2;
wire [7:0]E1,E2;
wire s1,s2;
wire[8:0] eigth_bit_sub,nine_bit_add;
wire [31:0] div;

// Design of the circuit

assign M1 = {1'b1, in1[22:0]};
assign M2 = {1'b1, in2[22:0]};
assign E1 =  in1[30:23];
assign E2 =  in2[30:23];    

assign eigth_bit_sub = E1 - E2;
assign eigth_bit_add = eigth_bit_sub + 9'b001111111;

assign  final[30:23] = eigth_bit_add;

assign div = M1/M2;

assign final[22:0] = div;

assign s1 = in1[31];
assign s2 = in2[31];

assign final [31] = s1^s2;

endmodule