// Connor Humiston
// ECEN2350
// University of Colorado, Boulder
// Project 2

module Down_Counter(clk, enable, LFSRout, downout);
	input clk, enable;
	input [3:0] LFSRout;
	output reg [3:0] downout;
	
	always @ (posedge clk)
	begin
		if(enable)
			downout <= downout - 1'b1;
		else
			downout <= LFSRout;
	end
endmodule
//down counter that takes random value from lfsr
