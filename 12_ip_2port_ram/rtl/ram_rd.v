//*****************************************************
// Project		: 12_ip_2port_ram
// File			: ram_rd
// Editor		: Wenmei Wang
// Date			: 20/02/2025
// Description	: RAM read
//*****************************************************

module ram_rd (

	input				clk			,
	input				rst_n		,
	
	output				ram_rd_en	,
	output	reg	[4:0]	ram_rd_addr	,
	
	input		[7:0]	ram_rd_data

);

	// **********************************
	// Counter 0 - 63
	// **********************************
	reg [5:0]	rd_cnt;
	
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n)
		
			rd_cnt <= 6'd0;
			
		else if(rd_cnt == 6'd63)
		
			rd_cnt <= 6'd0;
			
		else
		
			rd_cnt <= rd_cnt + 1'b1;
	
	end
	
	// **********************************
	// Read address 0 - 31 only when rd_cnt is 0 to 31
	// **********************************
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n)
		
			ram_rd_addr <= 5'd0;
			
		else if((rd_cnt >= 6'd0) && (rd_cnt <= 6'd31))
		
			ram_rd_addr <= ram_rd_addr + 1'b1;
			
		else
		
			ram_rd_addr <= 5'd0;
	
	end
	
	// Read enable when rd_cnt is 0 to 31
	assign ram_rd_en = ((rd_cnt >= 6'd0) && (rd_cnt <= 6'd31) && rst_n) ? 1'b1 : 1'b0;
	
endmodule