//*****************************************************
// Project		: 17_lcd_rgb_char
// File			: lcd_rgb_char
// Editor		: Wenmei Wang
// Date			: 23/02/2025
// Description	: Top
//*****************************************************

module lcd_rgb_char (

	input				sys_clk		,
	input				sys_rst_n	,
	
	// RGB LCD
	output				lcd_de		,	// Data enable
	output				lcd_hs		,	// Horizontal sync signal
	output				lcd_vs		,	// Vertical sync signal
	output				lcd_bl		,	// Back light
	output				lcd_clk		,	// LCD clock
	inout		[15:0]	lcd_rgb		,	// RGB565 colour data
	output				lcd_rst			// LCD reset

);

	wire	[15:0]	lcd_id		;	// LCD ID
	
	wire			lcd_pclk	;	// LCD pixel clock
	
	wire	[10:0]  pixel_xpos	;	// X position
	wire	[10:0]  pixel_ypos	;	// Y position
	wire	[10:0]  h_disp		;	// Horizontal resolution
	wire	[10:0]  v_disp		;	// Vertical resolution
	wire	[15:0]  pixel_data	;	// Pixel data
	
	wire	[15:0]	lcd_rgb_o	;	// LCD output pixel data
	wire	[15:0]	lcd_rgb_i	;	// LCD input pixel data
	
	// Direction of pixel data
	assign lcd_rgb = lcd_de ? lcd_rgb_o : {16{1'bz}};
	assign lcd_rgb_i = lcd_rgb;

	// Read LCD ID
	rd_id u_rd_id (
	
		.clk		(sys_clk	),
		.rst_n	    (sys_rst_n	),
		.lcd_rgb    (lcd_rgb_i	),
		.lcd_id     (lcd_id		)
	
	);
	
	// Clock divider
	clk_div u_clk_div (
	
		.clk		(sys_clk	),
		.rst_n	    (sys_rst_n	),
		
		.lcd_id	    (lcd_id		),
		.lcd_pclk   (lcd_pclk	)

	);
	
	// Generate LCD display
	lcd_display u_lcd_display (
	
		.lcd_pclk	(lcd_pclk	),
		.rst_n		(sys_rst_n	),
		
		.pixel_xpos	(pixel_xpos	),
		.pixel_ypos	(pixel_ypos	),
		.pixel_data	(pixel_data	)
		
	);
	
	// LCD driver
	lcd_driver u_lcd_driver (
	
		.lcd_pclk	(lcd_pclk	),
		.rst_n		(sys_rst_n	),
		
		.lcd_id		(lcd_id		),
		.pixel_data	(pixel_data	),
		
		.pixel_xpos	(pixel_xpos	),
		.pixel_ypos	(pixel_ypos	),
		.h_disp		(h_disp		),
		.v_disp		(v_disp		),
		
		.lcd_de		(lcd_de		),
		.lcd_hs		(lcd_hs		),
	    .lcd_vs		(lcd_vs		),
	    .lcd_bl		(lcd_bl		),
	    .lcd_clk	(lcd_clk	),	
	    .lcd_rgb	(lcd_rgb_o	),	
	    .lcd_rst	(lcd_rst	)
		
	);

endmodule