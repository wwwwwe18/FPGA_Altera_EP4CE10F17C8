//*****************************************************
// Project		: 18_hdmi_colorbar_top
// File			: asyn_rst_syn
// Editor		: Wenmei Wang
// Date			: 24/02/2025
// Description	: Async reset, sync release (active H)
//*****************************************************

module asyn_rst_syn (

	input	clk			,
	input	reset_n		,	// Async reset, active L
	
	output	syn_reset		// Sync reset, active H

);

	reg reset_1;
	reg reset_2;
	
	assign syn_reset = reset_2;
	
	always @(posedge clk or negedge reset_n) begin
	
		if(!reset_n) begin
		
			reset_1 <= 1'b1;
			reset_2 <= 1'b1;
		
		end
		else begin
			
			reset_1 <= 1'b0;
			reset_2 <= reset_1;
		
		end
	
	end

endmodule