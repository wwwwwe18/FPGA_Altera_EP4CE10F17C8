//*****************************************************
// Project		: 16_lcd_rgb_colorbar
// File			: clk_div
// Editor		: Wenmei Wang
// Date			: 23/02/2025
// Description	: Clock divider
//*****************************************************

module clk_div (

	input				clk			,	// 50MHz
	input				rst_n		,
	
	input		[15:0]	lcd_id		,

	output	reg			lcd_pclk

);

	reg		clk_25m		;
	reg		clk_12_5m	;
	reg		div_4_cnt	;
	
	// **********************************
	// clk_25m - 25MHz
	// **********************************
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n)
		
			clk_25m <= 1'b0;
			
		else
		
			clk_25m <= ~clk_25m;
	
	end
	
	// **********************************
	// clk_12_5m - 12.5MHz
	// **********************************
	always @(posedge clk or negedge rst_n) begin
	
		if(!rst_n) begin
		
			div_4_cnt <= 1'b0;
			clk_12_5m <= 1'b0;
		
		end
		else begin
		
			div_4_cnt <= div_4_cnt + 1'b1;
			
			if(div_4_cnt == 1'b1)
			
				clk_12_5m <= ~clk_12_5m;
				
		end
	
	end
	
	// **********************************
	// lcd_pclk
	// **********************************
	always @(*) begin
	
		case(lcd_id)
		
			16'h4342: lcd_pclk = clk_12_5m;	// 4.3' RGB LCD  RES:480x272
			16'h7084: lcd_pclk = clk_25m;	// 7'   RGB LCD  RES:800x480
			16'h7016: lcd_pclk = clk;		// 7'   RGB LCD  RES:1024x600
			16'h4384: lcd_pclk = clk_25m;	// 4.3' RGB LCD  RES:800x480
			16'h1018: lcd_pclk = clk;		// 10'  RGB LCD  RES:1280x800
			default: lcd_pclk = 0;
		
		endcase
	
	end

endmodule