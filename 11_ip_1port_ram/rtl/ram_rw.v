//*****************************************************
// Project		: 11_ip_1port_ram
// File			: ram_rw
// Editor		: Wenmei Wang
// Date			: 20/02/2025
// Description	: RAM read & write
//*****************************************************

module ram_rw (

	input				clk			,
	input				rst_n		,
	
	output				ram_wr_en	,
	output				ram_rd_en	,
	output	reg	[4:0]	ram_addr	,
	output	reg	[7:0]	ram_wr_data	,
	
	input		[7:0]	ram_rd_data

);

	// **********************************
	// Counter 0 - 63
	// **********************************
	reg [5:0]	rw_cnt;
	
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n)
		
			rw_cnt <= 6'd0;
			
		//else if(rw_cnt == 6'd63)
		
		//	rw_cnt <= 6'd0;
			
		else
		
			rw_cnt <= rw_cnt + 1'b1;
	
	end
	
	// **********************************
	// Write data 0 - 31
	// **********************************
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n)
		
			ram_wr_data <= 8'd0;
			
		else if((rw_cnt >= 6'd0) && (rw_cnt <= 6'd31))
		
			ram_wr_data <= ram_wr_data + 1'b1;
			
		else
		
			ram_wr_data <= 8'd0;
	
	end
	
	// **********************************
	// Address 0 - 31
	// **********************************
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n)
		
			ram_addr <= 5'd0;
			
		//else if(ram_addr == 5'd31)
		
		//	ram_addr <= 5'd0;
			
		else
		
			ram_addr <= ram_addr + 1'b1;
	
	end
	
	// Write enable when rw_cnt is 0 to 31
	assign ram_wr_en = ((rw_cnt >= 6'd0) && (rw_cnt <= 6'd31) && rst_n) ? 1'b1 : 1'b0;
	
	// Read enable when rw_cnt is 32 to 63
	assign ram_rd_en = ((rw_cnt >= 6'd32) && (rw_cnt <= 6'd63)) ? 1'b1 : 1'b0;

endmodule