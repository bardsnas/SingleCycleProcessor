// Carson Blaisdell and Bardia Nasrulai
// 11/03/2023
// Lab 3: Intro Digital Logic, Finite State Machines
// EE 271 
// Takes in a clock signal, divides the clock cycle and outputs 32
// divided clock signals of varying frequency.
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ...
// [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...

`timescale 1ns/10ps

module clock_divider (clock, divided_clocks);
	
	input logic clock;
	output logic [31:0] divided_clocks = 32'b0;
	
	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	end
endmodule


module clock_divider_testbench();
	logic clock;
	logic [31:0] divided_clocks;
	
	clock_divider dut (.clock(clock), .divided_clocks(divided_clocks));
	
	// TODO: Set up the clock.

	parameter clock_period = 100;
		
		initial begin
			clock <= 0;
			forever #(clock_period /2) clock <= ~clock; // every 50 time stamps we flip the clk (1/0)
					
		end //initial
		
		integer i;
		initial begin
		// TODO:
		
		
		
		// Run the simulation for a limited number of
		// clock cycles until $stop directive ends the sim.
		// Otherwise simulation will run forever
		
		// Use @(posedge clock); to run 1 clock
		// cycle.
		
		// A for-loop can be leveraged to
		// efficiently run many cycles here ......
		for (i = 0; i < 100; i++) begin
			@(posedge clock);
		end
		
		$stop;
	end
endmodule
