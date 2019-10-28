// Connor Humiston
// ECEN2350
// University of Colorado, Boulder
// Project 2

//This module counts in milliseconds for output to the 7seg display
module BCD_Counter(clock, reset, enable, BCD0, BCD1, BCD2, BCD3);
	input clock, reset, enable;
	output reg [3:0] BCD0, BCD1, BCD2, BCD3;

	always @(posedge clock, posedge reset)//, posedge enable)
	begin
		if (reset)
		begin
			BCD0 <= 4'b0000;
			BCD1 <= 4'b0000;
			BCD2 <= 4'b0000;
			BCD3 <= 4'b0000;
		end
		
		else if (enable)
		begin
			BCD0 <= BCD0 + 1;
			if (BCD0 == 4'b1001)
			begin 
				BCD0 <=  0;
				BCD1 <= BCD1 + 1'b1;
				if (BCD1 == 4'b1001)
				begin
					BCD1 <= 0;
					BCD2 <= BCD2 + 1'b1;
					if (BCD2 == 4'b1001)
					begin
						BCD2 <= 0;
						BCD3 <= BCD3 + 1;
					end
				end
			end
		end
		
		else if(!enable)
		begin
			BCD0 <= BCD0;
			BCD1 <= BCD1;
			BCD2 <= BCD2;
			BCD3 <= BCD3;
		end
		
	end
endmodule
//BCD counter module