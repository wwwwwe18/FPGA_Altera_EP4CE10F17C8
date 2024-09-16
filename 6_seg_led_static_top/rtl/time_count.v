//*****************************************************
// Project		: 6_seg_led_static_top
// File			: time_count
// Editor		: Wenmei Wang
// Date			: 24/07/2024
// Description	: Count module
//*****************************************************

module time_count(
	input		sys_clk  ,
	input 		sys_rst_n,
	output	reg	add_flag
);

// Define parameter
parameter MAX_NUM = 25_000_000;	// 0.5s

// Define reg
reg [24:0] cnt;

//*****************************************************
//**                    main code
//*****************************************************

always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n) begin
		cnt <= 1'b0;
		add_flag <= 1'b0;
	end
	else begin
		if(cnt < MAX_NUM - 1'b1) begin
			cnt <= cnt + 1'b1;
			add_flag <= 1'b0;
		end
		else begin
			cnt <= 1'b0;
			add_flag <= 1'b1;
		end
	end
end

endmodule