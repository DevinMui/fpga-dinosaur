`timescale 1ns / 1ps

module ee354_test_tb;

	reg move_clk;
	reg up;
	reg rst;
	reg [9:0] hc;
	reg [9:0] vc;
	reg [6*8:0] state_string; // 6-character string for symbolic display of state

	wire [11:0] rgb;
	wire [15:0] score;
    wire q_I;
	wire q_Game;
	wire q_Done;

	integer i;
	reg j;
	integer k;
	integer file;

	block_controller sc(
		.clk(move_clk), 
		.bright(bright), 
		.rst(rst), 
		.up(up), 
		.hCount(hc), 
		.vCount(vc), 
		.rgb(rgb), 
		.score(score),
        .q_I(q_I),
        .q_Game(q_Game),
        .q_Done(q_Done)
		);
		
		
		always  begin #5; move_clk = ~ move_clk; end
		initial begin
		// Initialize Inputs
		file = $fopen("ee354_final_project_output.txt", "w");
		move_clk = 0;
		
		//reset control
		@(posedge move_clk); //wait until we get a posedge in the Clk signal
		@(posedge move_clk);
		#1;
		rst=1;
		@(posedge move_clk);
		#1;
		rst=0;
		
		
		//make start signal active for one clock
        // wait for ini
		wait(q_I);
		@(posedge move_clk);
		#1;
		up=1;
		@(posedge move_clk);
		#1;
		up=0;


		//Test 1
		k = 0;
		$display("Start");
		while(q_Game)
			begin
					@(posedge move_clk);
					up = 1;
					@(posedge move_clk);
					#1;
					up = 0;
					k = k + 1;
			end
		#1;
		$display("Unlimited Jumps");
		$fwrite(file, "Unlimited Jumps\n");
		$display("Blocks Jumped: %d Score: %d", k, score);
		$fwrite(file, "Blocks Jumped: %d Score: %d", k, score);
		//$fclose(file);
		$display("Finished");
		$display(" ");
		$fwrite(file, "\n\n");
		
		up=1;
		@(posedge move_clk);
		#1;
		up=0;


		//Test 2
		k = 0;
		$display("Start");
		while(k < 5 && q_Game)
			begin
					@(posedge move_clk);
					up = 1;
					@(posedge move_clk);
					#1;
					up = 0;
					k = k + 1;
			end
		#1;
		$display("Limited Jumps (5)");
		$fwrite(file, "Limited Jumps(5)\n");
		$display("Blocks Jumped: %d Score: %d", k, score);
		$fwrite(file, "Blocks Jumped: %d Score: %d", k, score);
		$fclose(file);
		$display("Finished");
		$display(" ");
		//$fwrite(file, "\n\n");
		
		up=1;
		@(posedge move_clk);
		#1;
		up=0;
		
		#20;
							
		

	end
	
	always @(*)
		begin
			case ({q_I, q_Game, q_Done})    // Note the concatenation operator {}
				3'b100: state_string = "q_I   ";  // ****** TODO ******
				3'b010: state_string = "q_Game ";  // Fill-in the three lines
				3'b001: state_string = "q_Done";			
			endcase
		end
 
      
endmodule