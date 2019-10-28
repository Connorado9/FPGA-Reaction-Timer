// Connor Humiston
// ECEN2350
// University of Colorado, Boulder
// Project 2

module Project2_Top(
	output [7:0] HEX0,
	output [7:0] HEX1,
	output [7:0] HEX2,
	output [7:0] HEX3,
	//output [7:0] HEX4,
	//output [7:0] HEX5,
	output [9:0] LEDR,
	input	[9:0] SW,
	input	KEY0,
	input	KEY1,
	input	CLK_50MHZ,
	input CLK_10MHZ
);
	wire clk_1000Hz;
	wire clk_1Hz;
	reg[2:0] state = 0;
	wire [3:0] BCD3, BCD2, BCD1, BCD0;
	reg [3:0] display3out, display2out, display1out, display0out;
	reg [15:0] highscore = 16'b1001100110011001;
	wire [3:0] LFSRout;
	//wire [15:0] LFSRout;
	reg [9:1] leds;
	reg [3:0] ledselect;
	wire [3:0] downCounterOut;
	reg counterReset;
	reg counterEnable;
	reg LFSRenable;
	reg downCounterEnable;
	wire [12:0] LFSRout2;
	
	//Clock Dividers into 1000Hz (ms) and 1Hz (s)
	Clock_Divider1000 divider1000(CLK_10MHZ, 0, clk_1000Hz);
	Clock_Divider1 	divider1(CLK_10MHZ, 0, clk_1Hz);
	
	//Output to the displays
	BCD_Decoder segment0(display0out[3:0], HEX0[7:0]);
	BCD_Decoder segment1(display1out[3:0], HEX1[7:0]);
	BCD_Decoder segment2(display2out[3:0], HEX2[7:0]);
	BCD_Decoder segment3(display3out[3:0], HEX3[7:0]);
	//BCD_Decoder segment4((LFSRout2[12:0] % 7) + 2, HEX4[7:0]);
	//BCD_Decoder segment5((LFSRout[3:0] % 7), HEX5[7:0]);
	//BCD_Decoder segment5(state[2:0], HEX5[7:0]);
	
	//Counter							reset should be 0 and enable 1 to count
	BCD_Counter counter1(clk_1000Hz, counterReset, counterEnable, BCD0[3:0], BCD1[3:0], BCD2[3:0], BCD3[3:0]);
	
	//Random number generator
	//LFSR random(clk_1000Hz, LFSRenable, 0, 16'b0, LFSRout);
	LFSR random(clk_1Hz, LFSRenable, LFSRout[3:0]);
	//LFSR7 random2(2, 0, clk_1Hz, LFSRout2[3:0]);
	LFSRl random2(LFSRout2, clk_1Hz, 0);
	//LFSR random(1, LFSRenable, clk_1Hz, LFSRout);

	//Down counter for delay
	Down_Counter delay1(clk_1Hz, downCounterEnable, (LFSRout[3:0] % 7), downCounterOut);
		
	//State determination from inputs
	always @(clk_1000Hz) 
	begin
		if(state[2:0] == 0) //State 0
			if(SW[0] == 1)
				state[2:0] = 1;
		if(state[2:0] == 1) //State 1
			if(~KEY0)
				state[2:0] = 2;
		if(state[2:0] == 2) //State 2
			if(downCounterOut == 0)
				state[2:0] = 3;
		//if(state[2:0] == 3) //State 3
		//	if(SW[9:1] & LEDR[9:1])
		//		state[2:0] = 4;
		
		if(SW[0] == 0) 	  //Reset
			state[2:0] = 0;
	end
		
	//State machine outputs
	always @(state)
	begin
		case(state)
			3'b000:	//0: reset and highscore
			begin
						display3out[3:0] = highscore[3:0];
						display2out[3:0] = highscore[7:4];
						display1out[3:0] = highscore[11:8];
						display0out[3:0] = highscore[15:12];
						ledselect[3:0] = 4'b0000;
						
						counterReset = 1; //clears the counter
						counterEnable = 0; //counter not enabled
						
						LFSRenable = 1; //enabling the LFSR to run in the background and select a random number
						
						downCounterEnable = 0;
			end
					 
			3'b001:	//1: enters game before start button pressed
			begin
						display3out[3:0] = 0; 
						display2out[3:0] = 0;
						display1out[3:0] = 0;
						display0out[3:0] = 0;
						ledselect[3:0] = 4'b0000;
						
						counterReset = 0;
						counterEnable = 0;
						
						LFSRenable = 1;

						downCounterEnable = 0;
			end
				
			3'b010:	//2: start button pressed & random time elapses
			begin
						display3out[3:0] = 0; 
						display2out[3:0] = 0;
						display1out[3:0] = 0;
						display0out[3:0] = 0;
						ledselect [3:0] = 4'b0000; //the LED select is assigned to the random LED passed from LSFR
						
						counterReset = 0;
						counterEnable = 0;
						
						LFSRenable = 0; //keeps the previous value generated in previous states
						
						downCounterEnable = 1; //the down counter begins and the state will change when its output equals 0
			end
			
			3'b011:	//3: random LED lights and counter begins
			begin
						display3out[3:0] = BCD3[3:0];
						display2out[3:0] = BCD2[3:0];
						display1out[3:0] = BCD1[3:0];
						display0out[3:0] = BCD0[3:0];
						//ledselect [3:0] = (LFSRout2[3:0] % 7) + 2; //this is a random number from 2 to 9 for LEDs
						ledselect [3:0] = (LFSRout2 % 7) + 2;
						//ledselect [3:0] = a + 2; //this is a random number from 2 to 9 for LEDs
						
						counterReset = 0;
						counterEnable = 1;
						
						LFSRenable = 0;
						
						downCounterEnable = 0;
						
						if(SW[9:1] & LEDR[9:1])
						begin
							counterEnable = 0;
							if(highscore > {BCD0, BCD1, BCD2, BCD3})
							begin
								
								if({BCD0, BCD1, BCD2, BCD3} != 0)
									highscore[15:0] = {BCD0, BCD1, BCD2, BCD3};
							end
						end
			end
			
			3'b100:	//4: stop switch switched to end counter
			begin
						display3out[3:0] = BCD3[3:0]; //keeps score
						display2out[3:0] = BCD2[3:0];
						display1out[3:0] = BCD1[3:0];
						display0out[3:0] = BCD0[3:0];
						//ledselect [3:0] = (LFSRout % 9) + 2;
						
						counterReset = 0;
						counterEnable = 0; //keeps the counter number the same
						
						LFSRenable = 0;
						
						downCounterEnable = 0;
						
						//high score compared
						if(highscore > {BCD0, BCD1, BCD2, BCD3})
						begin
							if({BCD0, BCD1, BCD2, BCD3} != 0)
								highscore[15:0] = {BCD0, BCD1, BCD2, BCD3};
						end
			end
			/*
			default:	//everything off by default
			begin
						display3out[3:0] = 0;
						display2out[3:0] = 0;
						display1out[3:0] = 0;
						display0out[3:0] = 0;
						ledselect[3:0] = 4'b0000;
						counterReset = 0;
						counterEnable = 0;
						LFSRenable = 1;
						downCounterEnable = 0;
			end
			*/
		endcase
	end

	//LED decoder
	always @(ledselect)
	begin
		case(ledselect)
			0: leds[9:1] = 9'b000000000;
			1: leds[9:1] = 9'b000000001;
			2: leds[9:1] = 9'b000000010;
			3: leds[9:1] = 9'b000000100;
			4: leds[9:1] = 9'b000001000;
			5: leds[9:1] = 9'b000010000;
			6: leds[9:1] = 9'b000100000;
			7: leds[9:1] = 9'b001000000;
			8: leds[9:1] = 9'b010000000;
			9: leds[9:1] = 9'b100000000;
			default: leds[9:1] = 9'b000000000;
		endcase
	end
	
	//Assigning LEDs to desired output
	assign LEDR[9:1] = leds[9:1];
	
endmodule
