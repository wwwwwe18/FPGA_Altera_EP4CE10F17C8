//*****************************************************
// Project		: 7_seg_led_dynamic
// File			: count
// Editor		: Wenmei Wang
// Date			: 24/07/2024
// Description	: Count module
//*****************************************************

module count(
	input				sys_clk  ,
	input				sys_rst_n,
	
	output	reg	[19:0]	data     ,	// Data to display on LED segment display
	output	reg	[5:0]	point    ,	// Point, set HIGH to turn on
	output	reg			sign     ,	// "-" sign, set HIGH to turn on
	output	reg			en			// Enable LED segment display
);

// Define parameter
parameter MAX_NUM = 23'd5_000_000;	// 5e6 * 20ns = 100ms

// Define reg
reg	[22:0]	cnt ;	// Counter
reg			flag;

//*****************************************************
//**                    Main code
//*****************************************************

// Generate pulse signal when the counter counts system clock to 100ms
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n) begin
		cnt <= 23'b0;
		flag <= 1'b0;
	end
	else if(cnt <= MAX_NUM - 1'b1) begin
		cnt <= cnt + 1'b1;
		flag <= 1'b0;
	end
	else begin
		cnt <= 23'b0;
		flag <= 1'b1;
	end
end

// LED segment display data from 0 to 999_999
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n) begin
		data <= 20'b0;
		point <= 6'b0;
		sign <= 1'b0;
		en <= 1'b0;
	end
	else begin
		point <= 6'b0;	// Turn off point
		sign <= 1'b0;	// Turn off "-" sign
		en <= 1'b1;		// Enable
		if(flag) begin	// Add 1 every 100ms
			if(data < 20'd999_999)
				data <= data + 1'b1;
			else
				data <= 20'b0;
		end
	end
end

endmodule