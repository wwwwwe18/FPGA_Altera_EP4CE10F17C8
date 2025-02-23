//*****************************************************
// Project		: 16_lcd_rgb_colorbar
// File			: lcd_display
// Editor		: Wenmei Wang
// Date			: 23/02/2025
// Description	: LCD display
//*****************************************************

/*

Displsy on LCD

|			|			|			|			|			|
|			|			|			|			|			|
|	WHITE	|	BLACK	|	RED		|	GREEN	|	BLUE	|
|			|			|			|			|			|
|			|			|			|			|			|

*/

module lcd_display (

	input				lcd_pclk	,	// LCD pixel clock
	input				rst_n		,
	
	input		[10:0]	pixel_xpos	,	// X position
	input		[10:0]	pixel_ypos	,	// Y position
	input		[10:0]	h_disp		,	// Horizontal resolution
	input		[10:0]	v_disp		,	// Vertical resolution
	
	output	reg	[15:0]	pixel_data		// Pixel data

);

	// **********************************
	// Parameter
	// **********************************
	parameter WHITE	= 16'b11111_111111_11111;
	parameter BLACK = 16'b00000_000000_00000;
	parameter RED	= 16'b11111_000000_00000;
	parameter GREEN	= 16'b00000_111111_00000;
	parameter BLUE	= 16'b00000_000000_11111;
	
	// Generate pixel_data
	always @(posedge lcd_pclk or negedge rst_n) begin
	
		if(!rst_n)
		
			pixel_data <= BLACK;
			
		else begin
		
			if((pixel_xpos >= 11'd0) && (pixel_xpos < 1 * h_disp / 5))
			
				pixel_data <= WHITE;
			
			else if((pixel_xpos >= 1 * h_disp / 5) && (pixel_xpos < 2 * h_disp / 5))
		
				pixel_data <= BLACK;
				
			else if((pixel_xpos >= 2 * h_disp / 5) && (pixel_xpos < 3 * h_disp / 5))
		
				pixel_data <= RED;
				
			else if((pixel_xpos >= 3 * h_disp / 5) && (pixel_xpos < 4 * h_disp / 5))
		
				pixel_data <= GREEN;
				
			else
			
				pixel_data <= BLUE;
		
		end
	
	end

endmodule