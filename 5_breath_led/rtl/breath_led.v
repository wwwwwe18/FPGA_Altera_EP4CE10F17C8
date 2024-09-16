//*****************************************************
// Project		: 5_breath_led
// File			: breath_led
// Editor		: Wenmei Wang
// Date			: 23/07/2024
// Description	: Breathing effect of LED1
//*****************************************************

module breath_led(
	input	sys_clk  ,
	input 	sys_rst_n,
    
//    output  reg   [15:0]	period_cnt,
//    output  reg   [15:0]	duty_cycle,
//    output  reg			inc_dec_flag,
	
	output	led
);

// Define parameter
parameter MAX_NUM = 16'd50_000;	// Max for period_cnt
parameter DUTY_STEP = 16'd25;	// Ascend/descend step

//parameter MAX_NUM = 16'd50;	// Simulation only
//parameter DUTY_STEP = 16'd5;	// Simulation only

// Define reg
reg [15:0]	period_cnt;
reg [15:0]	duty_cycle;
reg			inc_dec_flag;

//*****************************************************
//**                    main code
//*****************************************************

// Generate led according to value of period_cnt and duty_cycle
assign led = (period_cnt >= duty_cycle)?1'b1:1'b0;

// 1KHz, 1ms, 50_000
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		period_cnt <= 16'd0;
	else if(period_cnt == MAX_NUM)
		period_cnt <= 16'd0;
	else
		period_cnt <= period_cnt + 1'b1;
end

// Ascend/descend duty_cycle
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		duty_cycle <= 16'd0;
		inc_dec_flag <= 1'b0;
	end
	else begin
		if(period_cnt == MAX_NUM)begin
			if(inc_dec_flag == 1'b0)begin	// Ascending
				if(duty_cycle == MAX_NUM)
					inc_dec_flag <= 1'b1;
				else
					duty_cycle <= duty_cycle + DUTY_STEP;
			end
			else begin						// Descending
				if(duty_cycle == 16'd0)
					inc_dec_flag <= 1'b0;
				else
					duty_cycle <= duty_cycle - DUTY_STEP;
			end
		end
	end
end

endmodule