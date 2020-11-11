`timescale 1ns / 1ps

module block_controller(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input rst,
	input up,
	input [9:0] hCount, 
	input [9:0] vCount,
	output reg [11:0] rgb,
	output reg [15:0] score
        output reg [3:0] state;
   );
	wire dinosaur_block_fill;
	wire obstacle_block_fill;
	
	// xpos represents the obstacle
	// ypos represents the dinosaur
	// velocity represents gravity or the change in pos
	// can_jump lets the dinosaur jump
	reg [9:0] xpos, ypos, yVelocity;
	reg [4:0] xVelocity;
	reg [5:0] show_msg;
	reg can_jump;

	integer size = 50;
	integer flash = 15;
	
	// the dinosaur will be red
	// the obstacle will be white
	parameter RED   = 12'b1111_0000_0000;
	parameter WHITE   = 12'b1111_1111_1111;

	localparam
	INI = 3'b001, // Initialize the game
	GAME = 3'b010, // Play the game
	DONE = 3'b100; // Game over
	
	

	// game messages (start, game over)
	assign start_msg_fill = state==INI && show_msg <= flash && 250-size/2 <= vCount && vCount <= 250+size/2 && 450-size/2 <= hCount && hCount <= 450+size/2;
	// display F
	assign end_msg_fill_1 = state==DONE && show_msg <= flash && 250-size <= vCount && vCount <= 250+size && 450-size/4 <= hCount && hCount <= 450+size/4;
	assign end_msg_fill_2 = state==DONE && show_msg <= flash && 250-size <= vCount && vCount <= 250-2*size/3 && 450-size/4 <= hCount && hCount <= 450+size;
	assign end_msg_fill_3 = state==DONE && show_msg <= flash && 250-size/3 <= vCount && vCount <= 250 && 450-size/4 <= hCount && hCount <= 450+size;

	// dinosaur will be at the bottom left
	// obstacle will be at the bottom right
	assign dinosaur_block_fill=state!=INI && vCount>=(ypos-size) && vCount<=(ypos) && hCount>=(200) && hCount<=(200+size);
	assign obstacle_block_fill=state!=INI && vCount>=(515-size) && vCount<=(515) && hCount>=(xpos-size/2) && hCount<=(xpos+size/2);

	always@ (*) begin
    	if(~bright )	//force black if not inside the display area
			rgb = 12'b0000_0000_0000;
		else if (dinosaur_block_fill) 
			rgb = RED; 
		else if (obstacle_block_fill) 
			rgb = WHITE;
		else if (start_msg_fill)
			rgb = RED;
		else if (end_msg_fill_1)
			rgb = RED;
		else if (end_msg_fill_2)
			rgb = RED;
		else if (end_msg_fill_3)
			rgb = RED;
		else	
			rgb = 12'b0000_0000_0000;
	end
	
	always@(posedge clk, posedge rst) 
	begin
		if(rst)
		begin 
			state <= INI;
			xpos <= 9'bXXXXXXXXX; 
			ypos <= 9'bXXXXXXXXX;
			xVelocity <= 4'bXXXX;
			yVelocity <= 9'bXXXXXXXXX;
			can_jump <= 1'bX;
			score <= 8'bXXXXXXXX;
			show_msg <= 0;
		end
		else if (clk) begin
		/* Note that the top left of the screen does NOT correlate to vCount=0 and hCount=0. The display_controller.v file has the 
			synchronizing pulses for both the horizontal sync and the vertical sync begin at vcount=0 and hcount=0. Recall that after 
			the length of the pulse, there is also a short period called the back porch before the display area begins. So effectively, 
			the top left corner corresponds to (hcount,vcount)~(144,35). Which means with a 640x480 resolution, the bottom right corner 
			corresponds to ~(783,515).  
		*/
			(* full_case, parallel_case *)
			case (state)
				INI:
				begin
					if(up)
						state <= GAME;
					xpos<=783;
					ypos<=515;
					xVelocity<=6;
					yVelocity<=0;
					can_jump<=1;
					score<=0;
					// draw start
					show_msg<=show_msg + 1;
					if(up)
						show_msg<=0;
				end
				GAME:
				begin
					// collision detection to change state
					if(200 <= xpos && xpos <= 200 + size &&
						515 - size <= ypos && ypos <= 515
					)
						state <= DONE;

					score <= score + 1;

					// move obstacle
					xpos <= xpos - xVelocity;
					// loop back + change speed
					if(xpos <= 150) begin
						xVelocity <= xVelocity + 1;
						if(xVelocity == 15)
							xVelocity <= 6;
						xpos <= 800;
					end

					// handle jumps
					if(can_jump && up) begin
						yVelocity <= -30;
						can_jump <= 0;
					end

					if(!can_jump) begin
						yVelocity <= yVelocity + 2;
						ypos <= ypos + yVelocity;
					end

					if(!can_jump && ypos > 515) begin
						can_jump <= 1;
						ypos <= 515;
						yVelocity <= 0;
					end
				end
				DONE:
				begin
					if(up)
						state <= INI;

					// draw game over
					show_msg<=show_msg + 1;
					if(up)
						show_msg<=0;
				end
			endcase
		end
	end
endmodule
