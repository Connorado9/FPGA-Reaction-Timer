// Connor Humiston
// ECEN2350
// University of Colorado, Boulder
// Project 2

//this is the bcd to seven segment display decoder 
module BCD_Decoder(bcd, leds); 
	input [3:0] bcd; 
	output reg [7:0] leds;

	always @(bcd) 
		case (bcd)	  //abcdefg
			0: leds = 8'b11000000; 
			1: leds = 8'b11111001; 
			2: leds = 8'b10100100; 
			3: leds = 8'b10110000; 
			4: leds = 8'b10011001; 
			5: leds = 8'b10010010; 
			6: leds = 8'b10000010; 
			7: leds = 8'b11111000; 
			8: leds = 8'b10000000; 
			9: leds = 8'b10010000; 
			default: leds = 8'b11000000;
		endcase 
endmodule
