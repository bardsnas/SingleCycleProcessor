`timescale 1ns/10ps

module mux32_1(i, sel, out);
	output logic [63:0] out;
	input logic [31:0][63:0] i;
	input logic [4:0] sel;
	logic [63:0] v0, v1;
	
	mux16_1 m0(.i(i[15:0]), .sel(sel[3:0]), .out(v0));
	mux16_1 m1(.i(i[31:16]), .sel(sel[3:0]), .out(v1));
	
	mux2_1 m2(.i0(v0), .i1(v1), .sel(sel[4]), .out(out));

endmodule

module mux32_1_testbench();
	logic [31:0][63:0] i;
	logic [4:0] sel;
	logic [63:0] out;
	
	mux32_1 dut (.i, .sel, .out);

	initial begin
		i[0]=64'd64357; i[1]=64'd26000; i[2]=64'd24556; i[3]=64'd12328; i[4]=64'd63; i[5]=64'd31; i[6]=64'd132346; i[7]=64'd7;
		i[8]=64'd157; i[9]=64'd2803; i[10]=64'd308; i[11]=64'd64; i[12]=64'd27; i[13]=64'd879; i[14]=64'd538129; i[15]=64'd1327; 
		i[16]=64'd257; i[17]=64'd258; i[18]=64'd259; i[19]=64'd260; i[20]=64'd261; i[21]=64'd262; i[22]=64'd263; i[23]=64'd264; 
		i[24]=64'd264; i[25]=64'd265; i[26]=64'd266; i[27]=64'd267; i[28]=64'd268; i[29]=64'd269; i[30]=64'd270; i[31]=64'd271; #10;
		sel=5'b00000; #10;
		sel=5'b00001; #10;
		sel=5'b00010; #10;
		sel=5'b00011; #10;
		sel=5'b00100; #10;
		sel=5'b00101; #10;
		sel=5'b00110; #10;
		sel=5'b00111; #10;
		sel=5'b01000; #10;
		sel=5'b01001; #10;
		sel=5'b01010; #10;
		sel=5'b01011; #10;
		sel=5'b01100; #10;
		sel=5'b01101; #10;
		sel=5'b01110; #10;
		sel=5'b01111; #10;
		sel=5'b10000; #10;
		sel=5'b10001; #10;
		sel=5'b10010; #10;
		sel=5'b10011; #10;
		sel=5'b10100; #10;
		sel=5'b10101; #10;
		sel=5'b10110; #10;
		sel=5'b10111; #10;
		sel=5'b11000; #10;
		sel=5'b11001; #10;
		sel=5'b11010; #10;
		sel=5'b11011; #10;
		sel=5'b11100; #10;
		sel=5'b11101; #10;
		sel=5'b11110; #10;
		sel=5'b11111; #10;
	end
endmodule