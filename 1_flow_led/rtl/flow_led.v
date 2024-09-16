//*****************************************************
// Project		: 1_flow_led
// File			: flow_led
// Editor		: Wenmei Wang
// Date			: 22/07/2024
// Description	: LEDs flash from LED1 to LED4 (0.2s each)
//*****************************************************

module flow_led(
	input				sys_clk  ,
	input				sys_rst_n,
	output	reg	[3:0]	led
);

parameter MAX_NUM = 24'd10_000_000; // 0.2s
//parameter MAX_NUM = 24'd10; // Simulation only

// Define reg
reg	[23:0] counter;

//*****************************************************
//**                    main code
//*****************************************************

// Count to 10,000,000 - 1 = 0.2sec
always @(posedge sys_clk or negedge sys_rst_n) begin
	if(!sys_rst_n)
		counter <= 24'd0;
	else if(counter < MAX_NUM - 1'b1)
		counter <= counter + 1'b1;
	else
		counter <= 24'd0;
end

// 0001 -> 0010 -> 0100 -> 1000 -> 0001 ...
always @(posedge sys_clk or negedge sys_rst_n) begin
	if(!sys_rst_n)
		led <= 4'b0001;
	else if(counter == MAX_NUM - 1'b1)
		led <= {led[2:0],led[3]};
	else
		led <= led;
end

endmodule