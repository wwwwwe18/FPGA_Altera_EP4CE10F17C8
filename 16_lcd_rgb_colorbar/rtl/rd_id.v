//*****************************************************
// Project		: 16_lcd_rgb_colorbar
// File			: rd_id
// Editor		: Wenmei Wang
// Date			: 23/02/2025
// Description	: Read LCD ID
//*****************************************************

module rd_id (

	input				clk			,
	input				rst_n		,

	input		[15:0]	lcd_rgb		,	// RGB LCD pixel data (to read ID)
	
	output	reg	[15:0]	lcd_id			// LCD ID

);

	reg					rd_flag;
	
	// **********************************
	// Get rd_flag & lcd_id (M2:B4  M1:G5  M0:R4)
	// **********************************
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n) begin
			
			rd_flag <= 1'b0;
			lcd_id <= 16'd0;
		
		end
		else begin
		
			if(rd_flag == 1'b0) begin
			
				rd_flag <= 1'b1;
				
				case({lcd_rgb[4], lcd_rgb[10], lcd_rgb[15]})
				
					3'b000: lcd_id <= 16'h4342;	// 4.3' RGB LCD  RES:480x272
					3'b001: lcd_id <= 16'h7084;	// 7'   RGB LCD  RES:800x480
					3'b010: lcd_id <= 16'h7016;	// 7'   RGB LCD  RES:1024x600
					3'b100: lcd_id <= 16'h4384;	// 4.3' RGB LCD  RES:800x480
					3'b101: lcd_id <= 16'h1018;	// 10'  RGB LCD  RES:1280x800
					default: lcd_id <= 16'd0;
				
				endcase
			
			end
		
		end
	
	end

endmodule