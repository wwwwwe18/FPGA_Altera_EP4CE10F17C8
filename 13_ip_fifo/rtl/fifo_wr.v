//*****************************************************
// Project		: 13_ip_fifo
// File			: fifo_wr
// Editor		: Wenmei Wang
// Date			: 21/02/2025
// Description	: FIFO write
//*****************************************************

module fifo_wr (

	input				clk		,
	input				rst_n	,
		
	input				wr_full	,
	input				wr_empty,
	
	output				wr_req	,
	output	reg	[7:0]	wr_data

);

	reg		wr_req_t;
	
	// **********************************
	// Avoid writing when FIFO is full
	// **********************************
	assign	wr_req = wr_req_t & (~wr_full);

	// wr_req_t
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n)
		
			wr_req_t <= 1'b0;
			
		else if(wr_empty)	// Start to write to FIFO when it is empty
		
			wr_req_t <= 1'b1;
			
		else if(wr_full)	// Stop writing to FIFO when it is full
		
			wr_req_t <= 1'b0;
			
		//else
		
		//	wr_req <= wr_req;
	
	end
	
	// wr_data
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n)
		
			wr_data <= 8'd0;
			
		else if(wr_req)	// Increment
			
			wr_data <= wr_data + 1'b1;
			
		else
		
			wr_data <= 8'd0;
	
	end

endmodule