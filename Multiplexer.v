// Connor Humiston
// ECEN2350
// University of Colorado, Boulder
// Project 2

module Multiplexer(a, b, select0, multplxout);
	input [15:0] a, b;
	input select0;
	output reg [15:0] multplxout;

	always @ (select0)
		case ({select0})
		1'b1: multplxout = a;
		1'b0: multplxout = b;
	endcase
endmodule
