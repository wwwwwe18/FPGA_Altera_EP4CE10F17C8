//*****************************************************
// Project		: 3_top_key_beep
// File			: top_key_beep
// Editor		: Wenmei Wang
// Date			: 23/07/2024
// Description	: Top module - press key[0] to control beep
//*****************************************************

module top_key_beep(
	input 	sys_clk  ,
	input 	sys_rst_n,
	
	input 	key      ,
	output	beep
);

// Define wire
wire key_flag;
wire key_value;

//*****************************************************
//**                    main code
//*****************************************************

key_debounce u_key_debounce(
	.sys_clk  	(sys_clk)  ,
	.sys_rst_n	(sys_rst_n),
	
	.key      	(key)      ,
	.key_value	(key_value),
	.key_flag	(key_flag)
);

beep_control u_beep_control(
	.sys_clk  	(sys_clk)  ,
	.sys_rst_n	(sys_rst_n),
	
	.key_value	(key_value),
	.key_flag 	(key_flag) ,
	.beep		(beep)
);

endmodule