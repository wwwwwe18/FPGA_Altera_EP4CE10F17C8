//*****************************************************
// Project		: 4_touch_led
// File			: touch_led
// Editor		: Wenmei Wang
// Date			: 23/07/2024
// Description	: Press TPAD to control LED1
//*****************************************************

module touch_led(
	input 		sys_clk  ,
	input 		sys_rst_n,
	
	input		touch_key,
	output	reg	led
);

// Define reg
reg		touch_key_d0;
reg		touch_key_d1;

// Define wire
wire	touch_en;

//*****************************************************
//**                    main code
//*****************************************************

// Generate pulse signal when TPAD is pressed
assign touch_en = (~touch_key_d1) & touch_key_d0;

// Delayed data from TPAD
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		touch_key_d0 <= 1'b0;
		touch_key_d1 <= 1'b0;
	end
	else begin
		touch_key_d0 <= touch_key;
		touch_key_d1 <= touch_key_d0;
	end
end

// Control LED
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		led <= 1'b1;
	else begin
		if(touch_en)
			led <= ~led;
	end	
end

endmodule