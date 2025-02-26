//*****************************************************
// Project		: 19_hdmi_block_move_top
// File			: video_display
// Editor		: Wenmei Wang
// Date			: 24/02/2025
// Description	: Video display - moving block
//*****************************************************

/*

Displsy on HDMI: moving block

*/

module video_display (

	input				pixel_clk	,	// Pixel clock
	input				sys_rst_n	,
	
	input		[10:0]	pixel_xpos	,	// X position
	input		[10:0]	pixel_ypos	,	// Y position
	
	output	reg	[23:0]	pixel_data		// Pixel data

);

	// **********************************
	// Parameter
	// **********************************
	parameter  H_DISP = 11'd1280;						// Horizontal resolution
	parameter  V_DISP = 11'd720;                        // Vertical resolution

	localparam WHITE  = 24'b11111111_11111111_11111111;	// RGB888 white
	localparam BLACK  = 24'b00000000_00000000_00000000;	// RGB888 black
	localparam RED    = 24'b11111111_00001100_00000000;	// RGB888 red
	localparam GREEN  = 24'b00000000_11111111_00000000;	// RGB888 green
	localparam BLUE   = 24'b00000000_00000000_11111111;	// RGB888 blue
	
	localparam SIDE_W  = 11'd40;                    	// Frame width
	localparam BLOCK_W = 11'd97;                    	// Block width
	
	//localparam NCNT = 22'd742500;
	localparam NCNT = 22'd542500;
	
	// **********************************
	// reg
	// **********************************
	reg	[10:0]	block_x = SIDE_W;	// Block origin - X position
	reg	[10:0]	block_y = SIDE_W;	// Block origin - Y position
	
	reg [21:0]	div_cnt;			// Clock counter
	
	reg			h_direct;			// Block horizontal direction - 1: R, 0: L
	reg			v_direct;			// Block vertical direction - 1: Down, 0: Up
	
	reg	[13:0]	rom_addr;			// ROM address
	
	// **********************************
	// Wire
	// **********************************
	wire		move_en;			// Move block enable, approx. 100Hz
	
	wire		rom_rd_en	;		// ROM read enable
	wire[15:0]	rom_rd_data	;		// ROM data
	
	// **********************************
	
	assign move_en = (div_cnt == NCNT) ? 1'b1 : 1'b0;
	
	assign rom_rd_en = 1'b1;	// ROM read enable (always on)
	
	// Clock counter (approx. 10ms)
	always @(posedge pixel_clk) begin
		
		if(!sys_rst_n)
		
			div_cnt <= 22'd0;
			
		else begin
		
			if(div_cnt < NCNT)
			
				div_cnt <= div_cnt + 1'b1;
				
			else
			
				div_cnt <= 22'd0;
		
		end
	
	end
	
	// Define the block direction according to its position
	always @(posedge pixel_clk) begin
	
		if(!sys_rst_n) begin	// Reset
		
			h_direct <= 1'b1;	// Move to right
			v_direct <= 1'b1;	// Move to down
		
		end
		else begin
			
			// Horizontal direction
			if(block_x == SIDE_W - 1'b1)	// When reaching left edge, change direction to right
			
				h_direct <= 1'b1;
				
			else if(block_x == H_DISP - SIDE_W - BLOCK_W)	// When reaching right edge, change direction to left
		
				h_direct <= 1'b0;
				
			else
			
				h_direct <= h_direct;
				
			// Vertical direction
			if(block_y == SIDE_W - 1'b1)	// When reaching top edge, change direction to down
			
				v_direct <= 1'b1;
				
			else if(block_y == V_DISP - SIDE_W - BLOCK_W)	// When reaching bottom edge, change direction to up
		
				v_direct <= 1'b0;
				
			else
			
				v_direct <= v_direct;
		
		end
	
	end
	
	// Update the X & Y positions of block according to directions
	always @(posedge pixel_clk) begin
		
		if(!sys_rst_n) begin
			
			block_x <= SIDE_W;	// Origin
			block_y <= SIDE_W;
		
		end
		else if(move_en) begin	// Move the block
		
			// Update X position
			if(h_direct)		// Move to right
			
				block_x <= block_x + 1'b1;
				
			else				// Move to left
			
				block_x <= block_x - 1'b1;
				
			// Update Y position
			if(v_direct)		// Move to down
			
				block_y <= block_y + 1'b1;
				
			else				// Move to up
			
				block_y <= block_y - 1'b1;
		
		end
		else begin	// No movement
		
			block_x <= block_x;
			block_y <= block_y;
		
		end
	
	end
	
	// Generate pixel_data
	always @(posedge pixel_clk) begin
	
		if(!sys_rst_n)
		
			pixel_data <= BLACK;
			
		else begin
		
			// Frame - blue
			if((pixel_xpos < SIDE_W) || (pixel_xpos >= H_DISP - SIDE_W) || (pixel_ypos < SIDE_W) || (pixel_ypos >= V_DISP - SIDE_W))
			
				pixel_data <= BLUE;
				
			// Block - black
			else if((pixel_xpos >= block_x) && (pixel_xpos < block_x + BLOCK_W) && (pixel_ypos >= block_y) && (pixel_ypos < block_y + BLOCK_W))
			
				//pixel_data <= BLACK;
				pixel_data <= rom_rd_data;
				
			else
			
				pixel_data <= WHITE;
		
		end
	
	end
	
	// **********************************
	// Get rom_addr
	// **********************************
	always @(posedge pixel_clk) begin
		
		if(!sys_rst_n)
		
			rom_addr <= 14'd0;
		
		// Increment of rom_addr when displaying picture
		else if((pixel_xpos >= block_x) && (pixel_xpos < block_x + BLOCK_W) && (pixel_ypos >= block_y) && (pixel_ypos < block_y + BLOCK_W))
		
			rom_addr <= rom_addr + 1'b1;
		
		// Reset when completing picture display
		else if((pixel_ypos >= block_y + BLOCK_W))
	
			rom_addr <= 14'd0;
	
	end
	
	// **********************************
	// ROM: store Picture
	// **********************************
	rom_10000x16b u_rom_10000x16b(
	
		.address	(rom_addr		),  
		.clock		(pixel_clk		),   
		.rden		(rom_rd_en		),  
		.q			(rom_rd_data	)
	
	);

endmodule