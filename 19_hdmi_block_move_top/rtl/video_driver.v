//*****************************************************
// Project		: 19_hdmi_block_move_top
// File			: video_driver
// Editor		: Wenmei Wang
// Date			: 24/02/2025
// Description	: Video driver
//*****************************************************

module video_driver (

	input				pixel_clk	,	// Pixel clock
	input				sys_rst_n	,

	input		[23:0]	pixel_data	,	// Pixel data
	output		[10:0]	pixel_xpos	,	// X position
	output		[10:0]	pixel_ypos	,	// Y position
	
	output				video_de	,	// Data enable
	output				video_hs	,	// Horizontal sync signal
	output				video_vs	,	// Vertical sync signal
	output		[23:0]	video_rgb		// RGB888 colour data

);
	
	// **********************************
	// Parameter
	// **********************************
	// 1280*720
	// **********************************
	parameter  H_SYNC   =  11'd40	;	// Horizontal sync
	parameter  H_BACK   =  11'd220	;	// Horizontal display back
	parameter  H_DISP   =  11'd1280	;	// Horizontal display valid
	parameter  H_FRONT  =  11'd110	;	// Horizontal display front
	parameter  H_TOTAL  =  11'd1650	;	// Horizontal total period

	parameter  V_SYNC   =  11'd5	;	// Vertical sync
	parameter  V_BACK   =  11'd20	;	// Vertical display back
	parameter  V_DISP   =  11'd720	;	// Vertical display valid
	parameter  V_FRONT  =  11'd5	;	// Vertical display front
	parameter  V_TOTAL  =  11'd750	;	// Vertical total period

	// **********************************
	// reg
	// **********************************
	reg	[10:0]	h_cnt	;	// Horizontal count
	reg	[10:0]	v_cnt	;	// Vertical count
	
	// **********************************
	// wire
	// **********************************
	wire		video_en;	// Video enable
	wire		data_req;	// Require data
	
	// **********************************
	
	assign video_de = video_en;		// Data enable signal
	
	assign video_hs = (h_cnt < H_SYNC) ? 1'b0 : 1'b1;	// Horizontal sync signal
	assign video_vs = (v_cnt < V_SYNC) ? 1'b0 : 1'b1;	// Vertical sync signal
	
	// video_en is H in horizontal & vertical display valid
	assign video_en = ((h_cnt >= H_SYNC + H_BACK) && (h_cnt < H_SYNC + H_BACK + H_DISP) && (v_cnt >= V_SYNC + V_BACK) && (v_cnt < V_SYNC + V_BACK + V_DISP)) ? 1'b1 : 1'b0;
	
	// Require data (1 clock in advance)
	assign data_req = ((h_cnt >= H_SYNC + H_BACK - 1'b1) && (h_cnt < H_SYNC + H_BACK + H_DISP - 1'b1) && (v_cnt >= V_SYNC + V_BACK) && (v_cnt < V_SYNC + V_BACK + V_DISP)) ? 1'b1 : 1'b0;
	
	// Pixel X, Y positions
	assign pixel_xpos = data_req ? (h_cnt - (H_SYNC + H_BACK - 1'b1)) : 11'd0;
	assign pixel_ypos = data_req ? (v_cnt - (V_SYNC + V_BACK - 1'b1)) : 11'd0;
	
	// RGB888 colour data
	assign video_rgb = video_en ? pixel_data : 24'd0;
	
	// h_cnt: 0 to (H_TOTAL - 1)
	always @(posedge pixel_clk) begin
	
		if(!sys_rst_n)
		
			h_cnt <= 11'd0;
			
		else begin
		
			if(h_cnt == H_TOTAL - 1'b1)
			
				h_cnt <= 11'd0;
				
			else
			
				h_cnt <= h_cnt + 1'b1;
		
		end
	
	end
	
	// v_cnt: 0 to (V_TOTAL - 1)
	always @(posedge pixel_clk) begin
	
		if(!sys_rst_n)
		
			v_cnt <= 11'd0;
			
		else begin
		
			if(h_cnt == H_TOTAL - 1'b1) begin
			
				if(v_cnt == V_TOTAL - 1'b1)
			
					v_cnt <= 11'd0;
					
				else
				
					v_cnt <= v_cnt + 1'b1;

			end
		
		end
	
	end

endmodule