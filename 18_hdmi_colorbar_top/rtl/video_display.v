//*****************************************************
// Project		: 18_hdmi_colorbar_top
// File			: video_display
// Editor		: Wenmei Wang
// Date			: 24/02/2025
// Description	: Video display
//*****************************************************

/*

Displsy on HDMI

|			|			|			|			|			|
|			|			|			|			|			|
|	WHITE	|	BLACK	|	RED		|	GREEN	|	BLUE	|
|			|			|			|			|			|
|			|			|			|			|			|

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
	
	// Generate pixel_data
	always @(posedge pixel_clk) begin
	
		if(!sys_rst_n)
		
			pixel_data <= BLACK;
			
		else begin
		
			if((pixel_xpos >= 11'd0) && (pixel_xpos < 1 * H_DISP / 5))
			
				pixel_data <= WHITE;
			
			else if((pixel_xpos >= 1 * H_DISP / 5) && (pixel_xpos < 2 * H_DISP / 5))
		
				pixel_data <= BLACK;
				
			else if((pixel_xpos >= 2 * H_DISP / 5) && (pixel_xpos < 3 * H_DISP / 5))
		
				pixel_data <= RED;
				
			else if((pixel_xpos >= 3 * H_DISP / 5) && (pixel_xpos < 4 * H_DISP / 5))
		
				pixel_data <= GREEN;
				
			else
			
				pixel_data <= BLUE;
		
		end
	
	end

endmodule