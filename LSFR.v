// Connor Humiston
// ECEN2350
// University of Colorado, Boulder
// Project 2

//generates a random number between 0 and 7
module LFSR7(randomIn, reset, clock, out);
	input [0:2] randomIn;
	input reset, clock;
	output reg [0:2] out;
	
	always @(posedge clock)
		if(reset)
			out <= randomIn;
		else
			out <= {out[2], out[0] ^ out[2], out[1]};
endmodule


//generates a random number between 0 and 15
module LFSR(clock, enable, out);
	input clock, enable;
	output reg [3:0] out;
	wire feedback;
	
	assign feedback = ~(out[3] ^ out[2]);
	
	always @(posedge clock)
	begin
		if(enable)
			out = {out[3:0], feedback};
		else
			out = 4'b0;
	end
endmodule


module LFSRl (out, clk, rst);

  output reg [3:0] out;
  input clk, rst;

  wire feedback;

  assign feedback = ~(out[3] ^ out[2]);

always @(posedge clk, posedge rst)
  begin
    if (rst)
      out = 4'b0;
    else
      out = {out[2:0],feedback};
  end
endmodule