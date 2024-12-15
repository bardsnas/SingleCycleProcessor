`timescale 1ns/10ps

module alu(A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic [63:0] A, B;
	input logic [2:0] cntrl;
	output logic [63:0] result;
	output logic negative, zero, overflow, carry_out;
	
	logic [63:0] wr, result_sum, result_bypass;
	logic [15:0] l1;
	logic [3:0] l2;
	logic aluop;
	
	bitSlice b1(.Ai(A[0]), .Bi(B[0]), .s(cntrl), .cin(cntrl[0]), .cout(wr[0]), .out(result_sum[0]));
	
	genvar i;
	generate
		for (i = 1; i < 64; i = i + 1) begin : bitSlices
			bitSlice b2(.Ai(A[i]), .Bi(B[i]), .s(cntrl), .cin(wr[i-1]), .cout(wr[i]), .out(result_sum[i]));
		end
	endgenerate
	
	assign negative = result_sum[63];
	xor #(50ps) x1(overflow, wr[63], wr[62]);
	assign carry_out = wr[63];
	
	genvar j;
	generate
		for (j = 0; j < 16; j = j + 1) begin : orloop1
			or #(50ps) o1 (l1[j], result_sum[4*j], result_sum[4*j+1], result_sum[4*j+2], result_sum[4*j+3]);
		end
	endgenerate
	
	genvar k;
	generate
		for (k = 0; k < 4; k = k + 1) begin : orloop2
			or #(50ps) o2 (l2[k], l1[4*k], l1[4*k+1], l1[4*k+2], l1[4*k+3]);
		end
	endgenerate
	
	nor #(50ps) n1(zero, l2[0], l2[1], l2[2], l2[3]);
	
	nor #(50ps) n2(aluop, cntrl[0], cntrl[1], cntrl[2]);
	
	assign result_bypass = B;
	
	mux2_1 m1 (.i0(result_sum), .i1(result_bypass), .sel(aluop), .out(result));

endmodule