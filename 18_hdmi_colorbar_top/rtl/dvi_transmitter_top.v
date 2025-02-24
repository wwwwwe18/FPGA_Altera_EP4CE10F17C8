//*****************************************************
// Project		: 18_hdmi_colorbar_top
// File			: dvi_transmitter_top
// Editor		: Wenmei Wang
// Date			: 24/02/2025
// Description	: DVI transmitter top
//*****************************************************

module dvi_transmitter_top (

	input			pclk		,	// Pixel clock 1x
	input			pclk_x5		,	// Pixel clock 5x
	input			reset_n		,	// Reset (active L)
					
	input			video_de	,	// Data enable
	input			video_hsync	,	// Horizontal sync signal
	input			video_vsync	,	// Vertical sync signal
	input	[23:0]	video_din	,	// RGB888 data
	
	output			tmds_clk_p	,	// Clock channels
	output			tmds_clk_n	,	
    output	[2:0]	tmds_data_p	,	// Data channels (BGR)
    output	[2:0]	tmds_data_n	

);

	wire			reset		;
	
	// Parallel data
	wire	[9:0]	red_10bit	;
	wire	[9:0]	green_10bit	;
	wire	[9:0]	blue_10bit	;
	wire	[9:0]	clk_10bit	;
	
	assign clk_10bit = 10'b1111100000;
	
	// Async reset, sync release (active H)
	asyn_rst_syn u_asyn_rst_syn (
	
		.clk			(pclk		),
	    .reset_n		(reset_n	),
		
	    .syn_reset	    (reset		)
		
	);
	
	// DVI encoder
	dvi_encoder u_dvi_encoder_b (
	
		.clkin			(pclk				),
	    .rstin			(reset				),	// Reset - active H
		
	    .din			(video_din[7:0]		),
	    .c0				(video_hsync		),
	    .c1				(video_vsync		),
	    .de				(video_de			),
	    .dout			(blue_10bit			)	// Parallel data
	
	);
	
	dvi_encoder u_dvi_encoder_g (
	
		.clkin			(pclk				),
	    .rstin			(reset				),
		
	    .din			(video_din[15:8]	),
	    .c0				(1'b0				),
	    .c1				(1'b0				),
	    .de				(video_de			),
	    .dout			(green_10bit		)
	
	);
	
	dvi_encoder u_dvi_encoder_r (
	
		.clkin			(pclk				),
	    .rstin			(reset				),
		
	    .din			(video_din[23:16]	),
	    .c0				(1'b0				),
	    .c1				(1'b0				),
	    .de				(video_de			),
	    .dout			(red_10bit			)
	
	);
	
	// Parallel to serial 10:1
	serializer_10_to_1 u_serializer_10_to_1_b (
	
		.serial_clk_5x	(pclk_x5			),
		.parallel_data	(blue_10bit			),
		
	    .serial_data_p	(tmds_data_p[0]		),
	    .serial_data_n  (tmds_data_n[0]		)
	
	);
	
	serializer_10_to_1 u_serializer_10_to_1_g (
	
		.serial_clk_5x	(pclk_x5			),
		.parallel_data	(green_10bit		),
		
	    .serial_data_p	(tmds_data_p[1]		),
	    .serial_data_n  (tmds_data_n[1]		)
	
	);
	
	serializer_10_to_1 u_serializer_10_to_1_r (
	
		.serial_clk_5x	(pclk_x5			),
		.parallel_data	(red_10bit			),
		
	    .serial_data_p	(tmds_data_p[2]		),
	    .serial_data_n  (tmds_data_n[2]		)
	
	);
	
	serializer_10_to_1 u_serializer_10_to_1_clk (
	
		.serial_clk_5x	(pclk_x5			),
		.parallel_data	(clk_10bit			),
		
	    .serial_data_p	(tmds_clk_p			),
	    .serial_data_n  (tmds_clk_n			)
	
	);

endmodule