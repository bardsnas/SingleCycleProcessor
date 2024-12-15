`timescale 1ns/10ps

module cntrl_main(instruction, negative, zero, overflow, 
						Reg2Loc, ALUSrc, MemtoReg, RegWrite, 
						MemWrite, ALUOp, Imm, Brtaken, UncondBr, dir, mush, wr);

	output logic 	Reg2Loc, ALUSrc, MemtoReg, RegWrite, 
						MemWrite, Brtaken, UncondBr, Imm, dir, wr;
	output logic [1:0] mush;
	
	output logic [2:0] ALUOp;
	
	input logic [31:0] instruction;
	
	input logic negative, zero, overflow;
	logic 	Reg2Loc1, ALUSrc1, MemtoReg1, RegWrite1, 
				MemWrite1, Brtaken1, UncondBr1, Imm1, dir1, mush1;
	logic [2:0] ALUOp1;
	logic 	Reg2Loc2, ALUSrc2, MemtoReg2, RegWrite2, 
				MemWrite2, Brtaken2, UncondBr2, Imm2, dir2, mush2;
	logic [2:0] ALUOp2;
	
	logic Br;
	logic C;
	
	/*assign ADDI 	= 11'b100100 01000; // unique
	assign ADDS 	= 11'b101010 11000; // unique
	assign B 		= 11'b000101 xxxxx; // unique
	assign B_cond 	= 11'b010101 00xxx; // unique
	assign CBZ 		= 11'b101101 00xxx; // unique
	assign LDUR 	= 11'b111110 00010; // same as STUR
	assign LSL		= 11'b110100 11011; // same as LSR
	assign LSR		= 11'b110100 11010; // same as LSL
	assign MUL		= 11'b100110 11000; // unique
	assign STUR 	= 11'b111110 00000; // same as LDUR
	assign SUBS 	= 11'b111010 11000; // unique
	*/
	always_comb begin
		case (instruction[31:26])
		
			6'b100100: begin // ADDI
					Reg2Loc = 1; 		ALUSrc = 1;
					MemtoReg = 0; 		RegWrite = 1;
					MemWrite = 0; 		ALUOp = 3'b010;
					Brtaken = 0;		UncondBr = 1'bx;
					Imm = 1;				dir = 1'bx;
					mush = 2'b00;		wr = 0;
			end
			
			6'b101010: begin // ADDS
					Reg2Loc = 1; 		ALUSrc = 0;
					MemtoReg = 0;		RegWrite = 1;
					MemWrite = 0; 		ALUOp = 3'b010;
					Brtaken = 0;		UncondBr = 1'bx;
					Imm = 1'bx;			dir = 1'bx;
					mush = 2'b00;		wr = 1;
			end
			
			6'b000101: begin // B
					Reg2Loc = 1'bx; 	ALUSrc = 1'bx; 
					MemtoReg = 1'bx; 	RegWrite = 0; 
					MemWrite = 0; 		ALUOp = 1'bx;
					Brtaken = 1;		UncondBr = 1;
					Imm = 1'bx;			dir = 1'bx;
					mush = 2'b00;		wr = 0;
			end
			
			6'b010101: begin	// B.cond
					Reg2Loc = 1'bx;	ALUSrc = 1'bx;
					MemtoReg = 1'bx; 	RegWrite = 0;
					MemWrite = 0;	 	ALUOp = 1'bx;
					Brtaken = Br;		UncondBr = 0;
					Imm = 1'bx;			dir = 1'bx;
					mush = 2'b00;		wr = 0;
			end
			
			6'b101101: begin // CBZ
					Reg2Loc = 0; 		ALUSrc = 0; 	
					MemtoReg = 1'bx; 	RegWrite = 0;
					MemWrite = 0; 		ALUOp = 3'b000;
					Brtaken = zero;	UncondBr = 0;
					Imm = 1'bx;			dir = 1'bx;
					mush = 2'b00;		wr = 1;
			end
			6'b111110: begin	// LDUR/STUR
					Reg2Loc = Reg2Loc1;	ALUSrc = ALUSrc1; 	
					MemtoReg = MemtoReg1; 		RegWrite = RegWrite1;
					MemWrite = MemWrite1; 		ALUOp = ALUOp1;
					Brtaken = Brtaken1;		UncondBr = UncondBr1;
					Imm = Imm1;				dir = dir1;
					mush = mush1;			wr = 0;
			end	
			6'b111010: begin	// SUBS
					Reg2Loc = 1; 		ALUSrc = 0; 	
					MemtoReg = 0; 		RegWrite = 1;
					MemWrite = 0; 		ALUOp = 3'b011;
					Brtaken = 0;		UncondBr = 1'bx;
					Imm = 1'bx;			dir = 1'bx;
					mush = 2'b00;		wr = 1;
			end
			6'b110100: begin // LSL/LSR
					Reg2Loc = Reg2Loc2;	ALUSrc = ALUSrc2; 	
					MemtoReg = MemtoReg2; 		RegWrite = RegWrite2;
					MemWrite = MemWrite2; 		ALUOp = ALUOp2;
					Brtaken = Brtaken2;		UncondBr = UncondBr2;
					Imm = Imm2;					dir = dir2;
					mush = mush2;				wr = 0;
			end
			6'b100110: begin	// MUL
					Reg2Loc = 1'b1; 		ALUSrc = 1'bx; 	
					MemtoReg = 1'bx; 		RegWrite = 1;
					MemWrite = 0; 		ALUOp = 3'bx;
					Brtaken = 0;		UncondBr = 1'bx;
					Imm = 1'bx;			dir = 1'bx;
					mush = 2'b10;		wr = 0;
			end
			default: begin
					Reg2Loc = 1'bx; 		ALUSrc = 1'bx; 	
					MemtoReg = 1'bx; 		RegWrite = 1'bx;
					MemWrite = 1'bx; 		ALUOp = 3'bx;
					Brtaken = 1'bx;		UncondBr = 1'bx;
					Imm = 1'bx;				dir = 1'bx;
					mush = 2'bx;			wr = 1'bx;
			end	
		endcase
	end
	
	always_comb begin
		case (instruction[25:21])
		
			5'b00010: begin
					Reg2Loc1 = 1'bx;	ALUSrc1 = 1; 	
					MemtoReg1 = 1; 		RegWrite1 = 1;
					MemWrite1 = 0; 		ALUOp1 = 3'b010;
					Brtaken1 = 0;		UncondBr1 = 1'bx;
					Imm1 = 0;	dir1 = 1'bx;
					mush1 = 2'b00;
			end
			
			5'b00000: begin
					Reg2Loc1 = 0; 		ALUSrc1 = 1;
					MemtoReg1 = 1'bx;		RegWrite1 = 0;
					MemWrite1 = 1; 		ALUOp1 = 3'b010;
					Brtaken1 = 0;		UncondBr1 = 1'bx;
					Imm1 = 0;	 dir1 = 1'bx;
					mush1 = 2'b00;	
			end
			
			default: begin
					Reg2Loc1 = 1'bx; 		ALUSrc1 = 1'bx; 	
					MemtoReg1 = 1'bx; 		RegWrite1 = 1'bx;
					MemWrite1 = 1'bx; 		ALUOp1 = 3'bx;
					Brtaken1 = 1;		UncondBr1 = 1;
					Imm1 = 1'bx;	dir1 = 1'bx;
					mush1 = 2'bx;	
			end
		endcase
	end
	
	always_comb begin
		case (instruction[25:21])
		
			5'b11011: begin // LSL
					Reg2Loc2 = 0;	ALUSrc2 = 1'bx; 	
					MemtoReg2 = 1'bx; 		RegWrite2 = 1;
					MemWrite2 = 1'bx; 		ALUOp2 = 3'b010;
					Brtaken2 = 0;		UncondBr2 = 1'bx;
					Imm2 = 1'bx;	dir2 = 0;
					mush2 = 2'b01;	
			end
			
			5'b11010: begin // LSR
					Reg2Loc2 = 0; 		ALUSrc2 = 1'bx;
					MemtoReg2 = 1'bx;		RegWrite2 = 1;
					MemWrite2 = 1'bx; 		ALUOp2 = 3'bx;
					Brtaken2 = 0;		UncondBr2 = 1'bx;
					Imm2 = 1'bx;	dir2 = 1;
					mush2 = 2'b01;
			end
			
			default: begin
					Reg2Loc2 = 1'bx; 		ALUSrc2 = 1'bx; 	
					MemtoReg2 = 1'bx; 		RegWrite2 = 1'bx;
					MemWrite2 = 1'bx; 		ALUOp2 = 3'bx;
					Brtaken2 = 1'bx;		UncondBr2 = 1'bx;
					Imm2 = 1'bx;		dir2 = 1'bx;
					mush2 = 2'bx;
			end
		endcase
	end
	always_comb begin // Brtaken
		case (instruction[4:0])
		
			5'd0: begin // EQ
					Br = (zero==1);
			end
			
			5'd1: begin // NE
					Br = (zero==0);
			end
			
			5'd2: begin // HS
					Br = (C==1);
			end
			
			5'd3: begin // LO
					Br = (C==0);
			end
			
			5'd4: begin // MI
					Br = (negative==1);
			end
			
			5'd5: begin // PL
					Br = (negative==0);
			end
			
			5'd6: begin // VS
					Br = (overflow==1);
			end
			
			5'd7: begin // VC
					Br = (overflow==0);
			end
			
			5'd8: begin // HI
					Br = (C==1 && zero==0);
			end
			
			5'd9: begin // LS
					Br = (C==0 || zero==1);
			end
			
			5'd10: begin // GE
					Br = (negative==overflow);
			end
			
			5'd11: begin // LT
					Br = (negative==1 && overflow==0);
			end
			
			5'd12: begin // GT
					Br = (zero==0 && negative==overflow);
			end
			
			5'd13: begin // LE
					Br = !(zero==0 && negative==overflow);
			end
			
			default: begin
					Br = 1'bx;
			end
		endcase
	end
endmodule

//module controller_testbench();
//
//	logic [63:0] address;
//	logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemWrite, BrTaken, UncondBr, ALUOp;
//	
//	controller dut (.address, .Reg2Loc, .ALUSrc, .MemtoReg, .RegWrite, .MemWrite, .BrTaken, .UncondBr, .ALUOp);
//	
//	initial begin // begin test
//		address = 64b'
	