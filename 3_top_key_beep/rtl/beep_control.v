//*****************************************************
// Project		: 3_top_key_beep
// File			: beep_control
// Editor		: Wenmei Wang
// Date			: 23/07/2024
// Description	: Control beep
//*****************************************************

module beep_control(
	input 		sys_clk  ,
	input 		sys_rst_n,
	
	input 		key_value,
	input 		key_flag ,
	output	reg	beep
);

//*****************************************************
//**                    main code
//*****************************************************

always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		beep <= 1'b1;
	else if(key_flag && (~key_value))
		beep <= ~beep;
end

endmodule