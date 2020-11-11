//////////////////////////////////////////////////////////////////////////////////
// Author:			Shideh Shahidi, Bilal Zafar, Gandhi Puvvada
// Create Date:   02/25/08, 10/13/08
// File Name:		ee354_GCD_tb.v 
// Description: 
//
//
// Revision: 		2.1
// Additional Comments:  
// 10/13/2008 Clock Enable (CEN) has been added by Gandhi
// 3/1/2010 Signal names are changed in line with the divider_verilog design
//  02/20/2020 Nexys-3 to Nexys-4 conversion done by Yue (Julien) Niu
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module ee354_test_tb;

	// Inputs
	/*reg Clk, CEN;
	reg Reset;
	reg Start;
	reg Ack;
	reg [7:0] Ain;
	reg [7:0] Bin;*/

	reg move_clk;
	reg [1:0] up;
	reg [9:0] hc;
	reg [9:0] vc;

	wire [11:0] rgb;
	wire [15:0] score;

	integer i;
	integer j;
	integer file;
	//integer size = 50;

	// Outputs
	/*wire [7:0] A, B, AB_GCD, i_count;
	wire q_I;
	wire q_Sub;
	wire q_Mult;
	wire q_Done;
	reg [6*8:0] state_string; // 6-character string for symbolic display of state
	integer clk_cnt, start_clock_cnt,clocks_taken;*/

	
	// Instantiate the Unit Under Test (UUT)

	block_controller sc(
		.clk(move_clk), 
		.bright(bright), 
		.rst(BtnC), 
		.up(BtnU), 
		.hCount(hc), 
		.vCount(vc), 
		.rgb(rgb), 
		.score(score)
		);
		
		
		always  begin #5; move_clk = ~ move_clk; end
		//always@(posedge move_clk) //clk_cnt=clk_cnt+1; //don't want to use reset to clear the clk_cnt or initialize
		initial begin
		// Initialize Inputs
		//clk_cnt=0;
		file = $fopen("ee354_gcd_Part3_output.txt", "w");
		move_clk = 0;
		//CEN = 1; // ****** in Part 2 ******
				 // Here, in Part 1, we are enabling clock permanently by making CEN a '1' constantly.
				 // In Part 2, your TOP design provides single-stepping through SCEN control.
				 // We are not planning to write a testbench for the part 2 design. However, if we were 
				 // to write one, we will remove this line, and make CEN enabled and disabled to test 
				 // single stepping.
				 // One of the things you make sure in your core design (DUT) is that when state 
				 // transitions are stopped by making CEN = 0,
				 // the data transformations are also stopped.
		/*Reset = 0;
		Start = 0;
		Ack = 0;
		Ain = 0;
		Bin = 0;*/


		//generate Reset, Start, Ack, Ain, Bin signals according to the waveform on page 14/19
		//add start_clock_cnt and clocks_taken code in the correct areas
		//add $display statements per 6.10 on page 13/19
		
		
		//reset control
		@(posedge move_clk); //wait until we get a posedge in the Clk signal
		@(posedge move_clk);
		#1;
		up=1;
		@(posedge move_clk);
		#1;
		up=0;
		
		
		//make start signal active for one clock
		@(posedge move_clk);
		#1;
		up=1;
		@(posedge move_clk);
		#1;
		up=0;
		//leaving the q_I state, so start keeping track of the clocks taken

		
		j <= 0;
		for(i = 0; i < 5; i = i + 1)
			begin
				if(!(200 <= sc.xpos && sc.xpos <= 200 + sc.size &&
						515 - sc.size <= sc.ypos && sc.ypos <= 515
					) && (j == 0)) 
					begin
						up = 1;
						@(posedge move_clk);
						#1;
						up = 0;

						if(sc.state == sc.DONE)
							j <= 1;
					end
			end

		//wait(sc.state == sc.DONE); //wait until q_Done signal is a 1
		#1;
		$display("Blocks Jumped: %d ", sc.score);
		$fwrite(file,"Blocks Jumped: ", sc.score);
		//$display("It took %d clock(s) to compute the GCD", clocks_taken);
		//keep Ack signal high for one clock
		up=1;
		@(posedge move_clk);
		#1;
		up=0;
		
		
		/*//Second stimulus (5,15)
		Ain = 5;
		Bin = 15;
		@(posedge Clk);										
		
		// generate a Start pulse
		Start = 1;
		@(posedge Clk);
		Start = 0;

		wait(q_Sub)
		start_clock_cnt = clk_cnt;
			
		wait(q_Done);
		clocks_taken = clk_cnt - start_clock_cnt;
		// generate and Ack pulse
		#1;
		$display("Ain: %d Bin: %d, GCD: %d", Ain, Bin, AB_GCD);
		//$display("It took %d clock(s) to compute the GCD", clocks_taken);
		Ack = 1;
		@(posedge Clk);
		Ack = 0;*/
		
		#20;
		$fclose(file);					
		

	end
	
	/*always @(*)
		begin
			case ({q_I, q_Sub, q_Mult, q_Done})    // Note the concatenation operator {}
				4'b1000: state_string = "q_I   ";  // ****** TODO ******
				4'b0100: state_string = "q_Sub ";  // Fill-in the three lines
				4'b0010: state_string = "q_Mult";
				4'b0001: state_string = "q_Done";			
			endcase
		end*/
 
      
endmodule