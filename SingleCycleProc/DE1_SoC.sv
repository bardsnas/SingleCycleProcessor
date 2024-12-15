`timescale 1ns/10ps

module DE1_SoC(clk, reset);
	
	logic [63:0] q;
	logic [63:0] d;
	logic [31:0] instruction;
	logic negative, zero, overflow, Reg2Loc, ALUSrc, MemtoReg, RegWrite, 
			MemWrite, Imm, Brtaken, UncondBr, carry_out, dir, wr;
	logic [1:0] mush;
 	logic [2:0] ALUOp;
	input logic clk, reset;
	
	logic [3:0] frOut;
	
	
//	DFF_VAR #(4) dfflags(.q(flags_out), .d(flags_in), .reset(reset), .clk(clk));
	
	
	DFF_VAR PC (.q(q), .d(d), .reset(reset), .clk(clk));
	
	PC_datapath PCData (.instruction(instruction), .UncondBr(UncondBr), .BrTaken(Brtaken), .PC_in(q), .PC_out(d));
	
	instructmem instr (.address(q), .instruction(instruction), .clk(clk));
	
	cntrl_main ctrl  (.instruction(instruction), .negative(frOut[2]), .zero(zero), .overflow(frOut[3]), 
							.Reg2Loc(Reg2Loc), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegWrite(RegWrite), 
							.MemWrite(MemWrite), .ALUOp(ALUOp), .Imm(Imm), .Brtaken(Brtaken), .UncondBr(UncondBr), 
							.dir(dir), .mush(mush), .wr(wr));
	
	datapath data (.instruction(instruction), .Reg2Loc(Reg2Loc), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), 
						.RegWrite(RegWrite), .MemWrite(MemWrite), .ALUOp(ALUOp), .Imm(Imm), .clk(clk), 
						.frOut(frOut), .zero(zero), .wr(wr), .dir(dir), .mush(mush));
	
	

endmodule 

module DE1_SoC_testbench();

	logic clock;
	logic reset;
	
	DE1_SoC dut(.clk(clock), .reset);
	
	initial begin
			clock <= 0;
			forever #(50000) clock <= ~clock; // every 50 time stamps we flip the clk (1/0)
					
		end //initial
		
		integer i;
		initial begin
			reset = 1; @(posedge clock);
			reset = 0; @(posedge clock);
			for (i = 0; i < 10000; i++) begin
				@(posedge clock);
			end
		$stop;
		end
endmodule 