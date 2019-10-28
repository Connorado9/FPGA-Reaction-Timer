module Delay_Counter(randomnum, clock, reset, out);
	input clock, reset;
	input [3:0] randomnum; 
	output reg out;
	reg [3:0] counter;
	
	always @(posedge clock or posedge reset)
	begin
		if(reset)
			counter[3:0] <= 3'b000;
	
		//if(counter == randomnum)
		//begin
		//	counter[2:0] <= 3'b000;
			//out = 1;
		//end
		
		else 
		//begin
			counter[3:0] <= counter[3:0] + 3'b001;
			//out = 0;
		//end
	end
	
	always @(*)
	begin
		if(counter == randomnum)
			out = 1;
		//else 
		//	out = 0;
	end
		
endmodule
