//*****************************************************
// Project		: 2_key_led
// File			: key_led
// Editor		: Wenmei Wang
// Date			: 23/07/2024
// Description	: Press key to control LEDs
//				  Key0 - LEDs flash from R to L
//				  Key1 - LEDs flash from L to R
//				  Key2 - LEDs all flash
//				  Key3 - LEDs all on
//*****************************************************

module key_led(
	input				sys_clk  ,
	input				sys_rst_n,
	
	input		[3:0]	key      ,
	output reg	[3:0]	led
);

// Define reg
reg [23:0]	cnt;
reg [ 1:0]  led_control;

//*****************************************************
//**                    main code
//*****************************************************

// Count to 10,000,000 - 1 = 0.2sec
always @(posedge sys_clk or negedge sys_rst_n) begin
	if(!sys_rst_n)
		cnt <= 24'd9_999_999;
	else if(cnt < 24'd9_999_999)
		cnt <= cnt + 1'b1;
	else
		cnt <= 24'd0;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
	if(!sys_rst_n)
		led_control <= 2'b0;
	else if(cnt == 24'd9_999_999)
		led_control <= led_control + 1'b1;
	else
		led_control <= led_control;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
	if(!sys_rst_n)
		led <= 4'b0000;
	else if(key[0] == 0)	// Key0 - LEDs flash from R to L
		case(led_control)
			2'b00	: led <= 4'b1000;
			2'b01	: led <= 4'b0100;
			2'b10	: led <= 4'b0010;
			2'b11	: led <= 4'b0001;
			default	: led <= 4'b0000;
		endcase
	else if(key[1] == 0)	// Key1 - LEDs flash from L to R
		case(led_control)
			2'b00	: led <= 4'b0001;
			2'b01	: led <= 4'b0010;
			2'b10	: led <= 4'b0100;
			2'b11	: led <= 4'b1000;
			default	: led <= 4'b0000;
		endcase
	else if(key[2] == 0)	// Key2 - LEDs all flash
		case(led_control)
			2'b00	: led <= 4'b1111;
			2'b01	: led <= 4'b0000;
			2'b10	: led <= 4'b1111;
			2'b11	: led <= 4'b0000;
			default	: led <= 4'b0000;
		endcase
	else if(key[3] == 0)	// Key3 - LEDs all on
		led <= 4'b1111;
	else
		led <= 4'b0000;
end

endmodule