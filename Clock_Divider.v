// Connor Humiston
// ECEN2350
// University of Colorado, Boulder
// Project 2

//1000Hz clock divider
module Clock_Divider1000(clock, reset, clk_out_1000Hz);
	input clock, reset;
	output clk_out_1000Hz;
	
	parameter WIDTH = 24; // Width of the register required
	parameter N = 5_000; //divides 10Mhz by 10,000
 
	reg [WIDTH-1:0] r_reg;
	wire [WIDTH-1:0] r_nxt;
	reg clk_track;
 
	always @(posedge clock or posedge reset)
	begin
		if (reset)
		begin
			r_reg <= 0;
			clk_track <= 1'b0;
		end
	  
		else if (r_nxt == N)
 	   begin
			r_reg <= 0;
			clk_track <= ~clk_track;
	   end
		
		else 
			r_reg <= r_nxt;
	end

	assign r_nxt = r_reg + 1;   	      
	assign clk_out_1000Hz = clk_track;
endmodule


//1Hz clock divider
module Clock_Divider1(clock, reset, clk_out_1Hz);
	input clock, reset;
	output clk_out_1Hz;
	
	parameter WIDTH = 24; // Width of the register required
	parameter N = 5_000_000; //divides 10Mhz by 10,000,000
 
	reg [WIDTH-1:0] r_reg;
	wire [WIDTH-1:0] r_nxt;
	reg clk_track;
 
	always @(posedge clock or posedge reset)
	begin
		if (reset)
		begin
			r_reg <= 0;
			clk_track <= 1'b0;
		end
	  
		else if (r_nxt == N)
 	   begin
			r_reg <= 0;
			clk_track <= ~clk_track;
	   end
		
		else 
			r_reg <= r_nxt;
	end

	assign r_nxt = r_reg + 1;   	      
	assign clk_out_1Hz = clk_track;
endmodule
