//*****************************************************
// Project		: 3_top_key_beep
// File			: key_debounce
// Editor		: Wenmei Wang
// Date			: 23/07/2024
// Description	: Debounce key
//*****************************************************

module key_debounce(
	input 	    sys_clk  ,
	input 	    sys_rst_n,
	
	input 	    key      ,
	output  reg key_value,
	output  reg key_flag
);

// Define reg
reg [31:0]	delay_cnt;
reg			key_reg  ;

//*****************************************************
//**                    main code
//*****************************************************

always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		delay_cnt <= 32'd0;
		key_reg <= 1'b1;
	end
	else begin
		key_reg <= key;
		if(key_reg != key)				// Init counter when key status changes (20ms)
			delay_cnt <= 32'd1_000_000;
            //delay_cnt <= 32'd10; // Simulation only
		else if(key_reg == key)begin	// If key status is stable, counter counts down
			if(delay_cnt > 32'd0)
				delay_cnt <= delay_cnt - 1'b1;
			else
				delay_cnt <= delay_cnt;
		end
	end
end

always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)begin
		key_flag <= 1'b0;
		key_value <= 1'b1;
	end
	else begin
		if(delay_cnt == 32'd1)begin
			key_flag <= 1'b1;
			key_value <= key;
		end
		else begin
			key_flag <= 1'b0;
			key_value <= key_value;
		end
	end
end

endmodule