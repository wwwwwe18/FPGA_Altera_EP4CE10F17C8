//*****************************************************
// Project		: 18_hdmi_colorbar_top
// File			: hdmi_colorbar_top
// Editor		: Wenmei Wang
// Date			: 24/02/2025
// Description	: Top
//*****************************************************

module hdmi_colorbar_top (

	input			sys_clk		,
    input			sys_rst_n	,
	
	// TMDS
	output			tmds_clk_p	,	// Clock channels
	output			tmds_clk_n	,
	output	[2:0]	tmds_data_p	,	// Data channels (BGR)
	output	[2:0]	tmds_data_n	

);

	wire			pixel_clk		;
	wire			pixel_clk_5x	;
	wire			clk_locked		;
	
	wire	[10:0]	pixel_xpos_w	;
	wire	[10:0]	pixel_ypos_w	;
	wire	[23:0]	pixel_data_w	;
	
	wire			video_de		;
	wire			video_hs		;
	wire			video_vs		;
	wire	[23:0]	video_rgb		;
	
	wire			rst_n			;
	
	assign rst_n = sys_rst_n & clk_locked;

	// PLL: generate pixel clock (1x and 5x)
	pll_clk	u_pll_clk (
	
		.areset		(~sys_rst_n		),
		.inclk0		(sys_clk		),
		
		.c0			(pixel_clk		),
		.c1			(pixel_clk_5x	),
		.locked		(clk_locked		)
		
	);
	
	// Video display
	video_display u_video_display (
	
		.pixel_clk	(pixel_clk		),
	    .sys_rst_n	(sys_rst_n		),
		
	    .pixel_xpos	(pixel_xpos_w	),
	    .pixel_ypos	(pixel_ypos_w	),
		
	    .pixel_data	(pixel_data_w	)
	
	);
	
	// Video driver
	video_driver u_video_driver (
	
		.pixel_clk	(pixel_clk		),
	    .sys_rst_n	(sys_rst_n		),
		
	    .pixel_data	(pixel_data_w	),
	    .pixel_xpos	(pixel_xpos_w	),
	    .pixel_ypos	(pixel_ypos_w	),
		
	    .video_de	(video_de		),
	    .video_hs	(video_hs		),
	    .video_vs	(video_vs		),
	    .video_rgb	(video_rgb		)
	
	);
	
	// DVI transmitter
	dvi_transmitter_top u_dvi_transmitter_top (
	
		.pclk			(pixel_clk		),
	    .pclk_x5		(pixel_clk_5x	),
	    .reset_n		(rst_n			),
		
	    .video_de		(video_de		),
	    .video_hsync	(video_hs		),
	    .video_vsync	(video_vs		),
	    .video_din		(video_rgb		),
		
	    .tmds_clk_p		(tmds_clk_p		),
	    .tmds_clk_n		(tmds_clk_n		),
	    .tmds_data_p	(tmds_data_p	),	
	    .tmds_data_n	(tmds_data_n	)
	
	);

endmodule