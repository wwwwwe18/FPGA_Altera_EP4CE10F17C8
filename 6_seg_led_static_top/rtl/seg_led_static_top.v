//*****************************************************
// Project		: 6_seg_led_static_top
// File			: seg_led_static_top
// Editor		: Wenmei Wang
// Date			: 24/07/2024
// Description	: Top module - display from 111111 to FFFFFF
//*****************************************************

module seg_led_static_top(
	input			sys_clk  ,
	input 			sys_rst_n,
	
	output	[5:0]	seg_sel  ,
	output	[7:0]	seg_led
);

// Define parameter
parameter MAX_NUM = 25_000_000;

// Define wire
wire add_flag;

//*****************************************************
//**                    main code
//*****************************************************

time_count #(
	.MAX_NUM	(MAX_NUM)
	)

	u_time_count(
	.sys_clk	(sys_clk  ),
	.sys_rst_n	(sys_rst_n),
	.add_flag	(add_flag )
);

seg_led_static u_seg_led_static(
	.sys_clk  	(sys_clk  ),
	.sys_rst_n	(sys_rst_n),
	
	.add_flag 	(add_flag ),
	.seg_sel  	(seg_sel  ),
	.seg_led	(seg_led  )
);

endmodule