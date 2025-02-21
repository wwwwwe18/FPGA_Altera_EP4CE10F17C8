//*****************************************************
// Project		: 13_ip_fifo
// File			: fifo_rd
// Editor		: Wenmei Wang
// Date			: 21/02/2025
// Description	: FIFO read
//*****************************************************

module fifo_rd (

	input				clk		,
	input				rst_n	,
		
	input				rd_full	,
	input				rd_empty,
	
	output				rd_req	,
	
	input		[7:0]	rd_data

);

	reg		rd_req_t;
	
	// **********************************
	// Avoid reading when FIFO is empty
	// **********************************
	assign	rd_req = rd_req_t & (~rd_empty);

	// rd_req_t
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n)
		
			rd_req_t <= 1'b0;
			
		else if(rd_full)	// Start to read to FIFO when it is full
		
			rd_req_t <= 1'b1;
			
		else if(rd_empty)	// Stop reading to FIFO when it is empty
		
			rd_req_t <= 1'b0;
	
	end

endmodule