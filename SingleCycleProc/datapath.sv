`timescale 1ns/10ps

module datapath(instruction, Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemWrite, 
						ALUOp, Imm, clk, frOut, zero, wr, dir, mush);

	input logic [31:0] instruction;
	input logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemWrite, Imm, dir, wr;
	input logic [2:0] ALUOp;
	input logic [1:0] mush;
	input logic clk;
	output logic [3:0] frOut;
	output logic zero;
	
	logic overflow, negative, carry_out;
	logic [4:0] Ab;
	logic [63:0] Da;
	logic [63:0] Db1;
	logic [63:0] DAddr9;
	logic [63:0] Imm12;
	logic [63:0] val;
	logic [63:0] Db2;
	logic [63:0] result;
	logic [63:0] Dout;
	logic [63:0] Dw, Dw1, Dw2, Dw12, Dw3;
	
	mux2_1_5bit m1(.i0(instruction[4:0]), .i1(instruction[20:16]), .sel(Reg2Loc), .out(Ab));
	
	regfile rf1(.ReadData1(Da), .ReadData2(Db1), .WriteData(Dw), .ReadRegister1(instruction[9:5]), 
	            .ReadRegister2(Ab), .WriteRegister(instruction[4:0]), .RegWrite(RegWrite), .clk(clk));
	
	sign_extend #(9) se1(.in(instruction[20:12]), .out(DAddr9));
	
	sign_extend #(12) se2(.in(instruction[21:10]), .out(Imm12));
	
	mux2_1 m2(.i0(DAddr9), .i1(Imm12), .sel(Imm), .out(val));
	
	mux2_1 m3(.i0(Db1), .i1(val), .sel(ALUSrc), .out(Db2));
	
	alu alu1(.A(Da), .B(Db2), .cntrl(ALUOp), .result(result), .negative(negative), 
				.zero(zero), .overflow(overflow), .carry_out(carry_out));
	
	logic [3:0] flags_in;
	assign flags_in = {overflow, negative, zero, carry_out};
	
	
	flag_regs fr1 (.wr(wr), .in(flags_in), .out(frOut), .clk(clk));
	
	datamem dm1(.address(result), .write_enable(MemWrite), .read_enable(~MemWrite), 
					.write_data(Db1), .clk(clk), .xfer_size(4'h8), .read_data(Dout));
	
	mux2_1 m4(.i0(result), .i1(Dout), .sel(MemtoReg), .out(Dw1));
	
	shifter shft (.value(Da), .direction(dir), .distance(instruction[15:10]), .result(Dw2));
	
	logic [63:0] multh;
	mult mul (.A(Da), .B(Db1), .doSigned(1'b1), .mult_low(Dw3), .mult_high(multh));
	
	logic [3:0][63:0] in;
	assign in[0] = Dw1;
	assign in[1] = Dw2;
	assign in[2] = Dw3;
	
	mux4_1 m5 (.i(in), .sel(mush), .out(Dw));
//	mux2_1 m5(.i0(Dw1), .i1(Dw2), .sel(shift), .out(Dw12)); // Select ALU/memory or shifter
//	mux2_1 m6(.i0(Dw12), .i1(Dw3), .sel(mult), .out(Dw));  // Add multiplier to the selection
	
	

endmodule 