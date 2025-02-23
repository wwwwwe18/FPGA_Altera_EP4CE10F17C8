//*****************************************************
// Project		: 17_lcd_rgb_char
// File			: lcd_display
// Editor		: Wenmei Wang
// Date			: 23/02/2025
// Description	: LCD display
//*****************************************************

/*

Picture		(100 * 100)

Characters	(128 * 32)

*/

module lcd_display (

	input				lcd_pclk	,	// LCD pixel clock
	input				rst_n		,
	
	input		[10:0]	pixel_xpos	,	// X position
	input		[10:0]	pixel_ypos	,	// Y position
	
	output	reg	[15:0]	pixel_data		// Pixel data

);

	// **********************************
	// Parameter
	// **********************************
	// Picture
	localparam PIC_X_START	= 11'd1		;	// X starting position
	localparam PIC_Y_START	= 11'd1		;	// Y starting position
	localparam PIC_WIDTH	= 11'd100	;	// Width
	localparam PIC_HEIGHT	= 11'd100	;	// Height
	
	// Characters
	localparam CHAR_X_START	= 11'd1		;	// X starting position
	localparam CHAR_Y_START	= 11'd110	;	// Y starting position
	localparam CHAR_WIDTH	= 11'd128	;	// Width
	localparam CHAR_HEIGHT	= 11'd32	;	// Height
						   
	localparam BACK_COLOR	= 16'hE7FF	;	// Back colour - light blue
	localparam CHAR_COLOR	= 16'hF800	;	// Character colour - red
	
	// **********************************
	// reg
	// **********************************
	reg		[127:0]	char[31:0]	;	// Characters width 128, depth 32
	reg		[13:0]	rom_addr	;	// ROM address
	
	// **********************************
	// wire
	// **********************************
	wire	[10:0]	x_cnt		;	// X counter
	wire	[10:0]	y_cnt		;	// Y counter
	wire			rom_rd_en	;	// ROM read enable
	wire	[15:0]	rom_rd_data	;	// ROM data
	
	// **********************************
	
	assign x_cnt = pixel_xpos - CHAR_X_START;	// X counter for Characters
	assign y_cnt = pixel_ypos - CHAR_Y_START;	// X counter for Characters
	
	assign rom_rd_en = 1'b1;					// ROM read enable (always on)
	
	// **********************************
	// Characters "正点原子" (128 * 32)
	// **********************************
	always @(posedge lcd_pclk) begin
	
		char[0 ] <= 128'h00000000000000000000000000000000;
		char[1 ] <= 128'h00000000000000000000000000000000;
		char[2 ] <= 128'h00000000000100000000002000000000;
		char[3 ] <= 128'h000000100001800002000070000000C0;
		char[4 ] <= 128'h000000380001800003FFFFF803FFFFE0;
		char[5 ] <= 128'h07FFFFFC0001800003006000000001E0;
		char[6 ] <= 128'h0000C000000180600300600000000300;
		char[7 ] <= 128'h0000C0000001FFF00300C00000000600;
		char[8 ] <= 128'h0000C000000180000310804000001800;
		char[9 ] <= 128'h0000C00000018000031FFFE000003000;
		char[10] <= 128'h0000C00000018000031800400001C000;
		char[11] <= 128'h0000C00000018000031800400001C000;
		char[12] <= 128'h00C0C000018181800318004000018000;
		char[13] <= 128'h00C0C00001FFFFC0031FFFC000018010;
		char[14] <= 128'h00C0C060018001800318004000018038;
		char[15] <= 128'h00C0FFF001800180031800403FFFFFFC;
		char[16] <= 128'h00C0C000018001800318004000018000;
		char[17] <= 128'h00C0C000018001800218004000018000;
		char[18] <= 128'h00C0C00001800180021FFFC000018000;
		char[19] <= 128'h00C0C000018001800210304000018000;
		char[20] <= 128'h00C0C00001FFFF800200300000018000;
		char[21] <= 128'h00C0C000018001800606300000018000;
		char[22] <= 128'h00C0C000018001000607370000018000;
		char[23] <= 128'h00C0C00000000000060E31C000018000;
		char[24] <= 128'h00C0C000001000400418307000018000;
		char[25] <= 128'h00C0C000020830600430303800018000;
		char[26] <= 128'h00C0C010020C18300860301800018000;
		char[27] <= 128'h00C0C038060E18180883700800018000;
		char[28] <= 128'h3FFFFFFC0C0618181100F008003F8000;
		char[29] <= 128'h000000001C0408182000600000070000;
		char[30] <= 128'h00000000000000000000000000020000;
		char[31] <= 128'h00000000000000000000000000000000;
		
	end
	
	// **********************************
	// Generate pixel_data
	// **********************************
	always @(posedge lcd_pclk or negedge rst_n) begin
	
		if(!rst_n)
		
			pixel_data <= BACK_COLOR;
		
		// Display picture
		else if((pixel_xpos >= PIC_X_START) && (pixel_xpos < PIC_X_START + PIC_WIDTH) && (pixel_ypos >= PIC_Y_START) && (pixel_ypos < PIC_Y_START + PIC_HEIGHT)) begin
		
			pixel_data <= rom_rd_data;
		
		end
		// Display characters
		else if((pixel_xpos >= CHAR_X_START) && (pixel_xpos < CHAR_X_START + CHAR_WIDTH) && (pixel_ypos >= CHAR_Y_START) && (pixel_ypos < CHAR_Y_START + CHAR_HEIGHT)) begin
		
			if(char[y_cnt][CHAR_WIDTH - 1'b1 - x_cnt])	// MSB to LSB
			
				pixel_data <= CHAR_COLOR;
				
			else
			
				pixel_data <= BACK_COLOR;	// Display back colour
		
		end
		else
		
			pixel_data <= BACK_COLOR;		// Display back colour
	
	end
	
	// **********************************
	// Get rom_addr
	// **********************************
	always @(posedge lcd_pclk or negedge rst_n) begin
		
		if(!rst_n)
		
			rom_addr <= 14'd0;
		
		// Increment of rom_addr when displaying picture
		else if((pixel_xpos >= PIC_X_START) && (pixel_xpos < PIC_X_START + PIC_WIDTH) && (pixel_ypos >= PIC_Y_START) && (pixel_ypos < PIC_Y_START + PIC_HEIGHT))
		
			rom_addr <= rom_addr + 1'b1;
		
		// Reset when completing picture display
		else if((pixel_ypos >= PIC_Y_START + PIC_HEIGHT))
	
			rom_addr <= 14'd0;
	
	end
	
	// **********************************
	// ROM: store Picture
	// **********************************
	rom_10000x16b u_rom_10000x16b(
	
		.address	(rom_addr		),  
		.clock		(lcd_pclk		),   
		.rden		(rom_rd_en		),  
		.q			(rom_rd_data	)
	
	);

endmodule