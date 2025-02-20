//*****************************************************
// Project		: 12_ip_2port_ram
// File			: ram_wr
// Editor		: Wenmei Wang
// Date			: 20/02/2025
// Description	: RAM write
//*****************************************************

module ram_wr (

	input				clk			,
	input				rst_n		,
	
	output				ram_wr_en	,
	output	reg	[4:0]	ram_wr_addr	,
	output	reg	[7:0]	ram_wr_data

);

	// **********************************
	// Counter 0 - 63 (then no change)
	// **********************************
	reg [5:0]	wr_cnt;
	
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n)
		
			wr_cnt <= 6'd0;
			
		else if(wr_cnt == 6'd63)
		
			wr_cnt <= wr_cnt;
			
		else
		
			wr_cnt <= wr_cnt + 1'b1;
	
	end
	
	// **********************************
	// Write data 0 - 31
	// **********************************
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n)
		
			ram_wr_data <= 8'd0;
			
		else if((wr_cnt >= 6'd0) && (wr_cnt <= 6'd31))
		
			ram_wr_data <= ram_wr_data + 1'b1;
			
		else
		
			ram_wr_data <= 8'd0;
	
	end
	
	// **********************************
	// Write address 0 - 31 only when wr_cnt is 0 to 31
	// **********************************
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n)
		
			ram_wr_addr <= 5'd0;
			
		else if((wr_cnt >= 6'd0) && (wr_cnt <= 6'd31))
		
			ram_wr_addr <= ram_wr_addr + 1'b1;
			
		else
		
			ram_wr_addr <= 5'd0;
	
	end
	
	// Write enable when wr_cnt is 0 to 31
	assign ram_wr_en = ((wr_cnt >= 6'd0) && (wr_cnt <= 6'd31) && rst_n) ? 1'b1 : 1'b0;
	
endmodule