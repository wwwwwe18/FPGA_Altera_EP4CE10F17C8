//*****************************************************
// Project		: 7_seg_led_dynamic
// File			: seg_led_dynamic
// Editor		: Wenmei Wang
// Date			: 24/07/2024
// Description	: Top module - display from 0 to 999999
//*****************************************************

module seg_led_dynamic(
	input			sys_clk  ,
	input			sys_rst_n,

	output	[5:0]	seg_sel  ,
	output	[7:0]	seg_led
);

// Define wire
wire	[19:0]	data;
wire	[ 5:0]	point;
wire			sign;
wire			en;

//*****************************************************
//**                    main code
//*****************************************************

count u_count(
	.sys_clk  	(sys_clk  ),
	.sys_rst_n	(sys_rst_n),
	
	.data     	(data     ),
	.point    	(point    ),
	.sign     	(sign     ),
	.en			(en       )
);

seg_led u_seg_led(
	.sys_clk  	(sys_clk  ),
	.sys_rst_n	(sys_rst_n),
	
	.data     	(data     ),
	.point    	(point    ),
	.sign     	(sign     ),
	.en       	(en       ),
	
	.seg_sel  	(seg_sel  ),
	.seg_led	(seg_led  )
);

endmodule