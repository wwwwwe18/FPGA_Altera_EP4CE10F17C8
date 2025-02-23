//*****************************************************
// Project		: 17_lcd_rgb_char
// File			: lcd_driver
// Editor		: Wenmei Wang
// Date			: 23/02/2025
// Description	: LCD driver
//*****************************************************

module lcd_driver (

	input				lcd_pclk	,	// LCD pixel clock
	input				rst_n		,
	
	input		[15:0]	lcd_id		,	// LCD ID
	input		[15:0]	pixel_data	,	// Pixel data
	
	output		[10:0]	pixel_xpos	,	// X position
	output		[10:0]	pixel_ypos	,	// Y position
	output	reg	[10:0]	h_disp		,	// Horizontal resolution
	output	reg	[10:0]	v_disp		,	// Vertical resolution
	
	output				lcd_de		,	// Data enable
	output				lcd_hs		,	// Horizontal sync signal
	output				lcd_vs		,	// Vertical sync signal
	output	reg			lcd_bl		,	// Back light
	output				lcd_clk		,	// LCD clock
	output		[15:0]	lcd_rgb		,	// RGB565 colour data
	output	reg			lcd_rst			// LCD reset

);
	
	// **********************************
	// Parameter
	// **********************************
	// 4.3' 480*272
	// **********************************
	parameter  H_SYNC_4342   =  11'd41;     // Horizontal sync
	parameter  H_BACK_4342   =  11'd2;      // Horizontal display back
	parameter  H_DISP_4342   =  11'd480;    // Horizontal display valid
	parameter  H_FRONT_4342  =  11'd2;      // Horizontal display front
	parameter  H_TOTAL_4342  =  11'd525;    // Horizontal total period
	   
	parameter  V_SYNC_4342   =  11'd10;     // Vertical sync
	parameter  V_BACK_4342   =  11'd2;      // Vertical display back
	parameter  V_DISP_4342   =  11'd272;    // Vertical display valid
	parameter  V_FRONT_4342  =  11'd2;      // Vertical display front
	parameter  V_TOTAL_4342  =  11'd286;    // Vertical total period
	
	// **********************************
	// 7' 800*480
	// **********************************
	parameter  H_SYNC_7084   =  11'd128;    // Horizontal sync
	parameter  H_BACK_7084   =  11'd88;     // Horizontal display back
	parameter  H_DISP_7084   =  11'd800;    // Horizontal display valid
	parameter  H_FRONT_7084  =  11'd40;     // Horizontal display front
	parameter  H_TOTAL_7084  =  11'd1056;   // Horizontal total period
	   
	parameter  V_SYNC_7084   =  11'd2;      // Vertical sync
	parameter  V_BACK_7084   =  11'd33;     // Vertical display back
	parameter  V_DISP_7084   =  11'd480;    // Vertical display valid
	parameter  V_FRONT_7084  =  11'd10;     // Vertical display front
	parameter  V_TOTAL_7084  =  11'd525;    // Vertical total period
	
	// **********************************
	// 7' 1024*600
	// **********************************
	parameter  H_SYNC_7016   =  11'd20;     // Horizontal sync
	parameter  H_BACK_7016   =  11'd140;    // Horizontal display back
	parameter  H_DISP_7016   =  11'd1024;   // Horizontal display valid
	parameter  H_FRONT_7016  =  11'd160;    // Horizontal display front
	parameter  H_TOTAL_7016  =  11'd1344;   // Horizontal total period
	   
	parameter  V_SYNC_7016   =  11'd3;      // Vertical sync
	parameter  V_BACK_7016   =  11'd20;     // Vertical display back
	parameter  V_DISP_7016   =  11'd600;    // Vertical display valid
	parameter  V_FRONT_7016  =  11'd12;     // Vertical display front
	parameter  V_TOTAL_7016  =  11'd635;    // Vertical total period
	
	// **********************************
	// 10.1' 1280*800
	// **********************************
	parameter  H_SYNC_1018   =  11'd10;     // Horizontal sync
	parameter  H_BACK_1018   =  11'd80;     // Horizontal display back
	parameter  H_DISP_1018   =  11'd1280;   // Horizontal display valid
	parameter  H_FRONT_1018  =  11'd70;     // Horizontal display front
	parameter  H_TOTAL_1018  =  11'd1440;   // Horizontal total period
	   
	parameter  V_SYNC_1018   =  11'd3;      // Vertical sync
	parameter  V_BACK_1018   =  11'd10;     // Vertical display back
	parameter  V_DISP_1018   =  11'd800;    // Vertical display valid
	parameter  V_FRONT_1018  =  11'd10;     // Vertical display front
	parameter  V_TOTAL_1018  =  11'd823;    // Vertical total period
	
	// **********************************
	// 4.3' 800*480
	// **********************************
	parameter  H_SYNC_4384   =  11'd128;    // Horizontal sync
	parameter  H_BACK_4384   =  11'd88;     // Horizontal display back
	parameter  H_DISP_4384   =  11'd800;    // Horizontal display valid
	parameter  H_FRONT_4384  =  11'd40;     // Horizontal display front
	parameter  H_TOTAL_4384  =  11'd1056;   // Horizontal total period
	   
	parameter  V_SYNC_4384   =  11'd2;      // Vertical sync
	parameter  V_BACK_4384   =  11'd33;     // Vertical display back
	parameter  V_DISP_4384   =  11'd480;    // Vertical display valid
	parameter  V_FRONT_4384  =  11'd10;     // Vertical display front
	parameter  V_TOTAL_4384  =  11'd525;    // Vertical total period
	
	// **********************************
	// reg
	// **********************************
	reg	[10:0]	h_sync	;	// Horizontal sync
	reg	[10:0]	h_back	;   // Horizontal display back
	reg	[10:0]	h_total	;	// Horizontal total period
	
	reg	[10:0]	v_sync	;	// Vertical sync
	reg	[10:0]	v_back	;   // Vertical display back
	reg	[10:0]	v_total	;	// Vertical total period
	
	reg	[10:0]	h_cnt	;	// Horizontal count
	reg	[10:0]	v_cnt	;	// Vertical count
	
	// **********************************
	// wire
	// **********************************
	wire		lcd_en	;	// LCD enable
	wire		data_req;	// Require data
	
	// **********************************
	
	assign lcd_hs = 1'b1;		// Horizontal sync signal
	assign lcd_vs = 1'b1;		// Vertical sync signal
	
	assign lcd_clk = lcd_pclk;	// LCD pixel clock
	assign lcd_de = lcd_en;		// Data enable signal
	
	// lcd_en is H in horizontal & vertical display valid
	assign lcd_en = ((h_cnt >= h_sync + h_back) && (h_cnt < h_sync + h_back + h_disp) && (v_cnt >= v_sync + v_back) && (v_cnt < v_sync + v_back + v_disp)) ? 1'b1 : 1'b0;
	
	// Require data (1 clock in advance)
	assign data_req = ((h_cnt >= h_sync + h_back - 1'b1) && (h_cnt < h_sync + h_back + h_disp - 1'b1) && (v_cnt >= v_sync + v_back) && (v_cnt < v_sync + v_back + v_disp)) ? 1'b1 : 1'b0;
	
	// Pixel X, Y positions
	assign pixel_xpos = data_req ? (h_cnt - (h_sync + h_back - 1'b1)) : 1'b0;
	assign pixel_ypos = data_req ? (v_cnt - (v_sync + v_back - 1'b1)) : 1'b0;
	
	// RGB565 colour data
	assign lcd_rgb = lcd_en ? pixel_data : 16'd0;
	
	// Assign LCD parameters according to LCD ID
	always @(posedge lcd_pclk) begin
	
		case(lcd_id)
		
			16'h4342 : begin	// 4.3' RGB LCD  RES:480x272
			
				h_sync  <= H_SYNC_4342; 
				h_back  <= H_BACK_4342; 
				h_disp  <= H_DISP_4342; 
				h_total <= H_TOTAL_4342;
				v_sync  <= V_SYNC_4342; 
				v_back  <= V_BACK_4342; 
				v_disp  <= V_DISP_4342; 
				v_total <= V_TOTAL_4342;   
				
			end
			
			16'h7084 : begin	// 7'   RGB LCD  RES:800x480
			
				h_sync  <= H_SYNC_7084; 
				h_back  <= H_BACK_7084; 
				h_disp  <= H_DISP_7084; 
				h_total <= H_TOTAL_7084;
				v_sync  <= V_SYNC_7084; 
				v_back  <= V_BACK_7084; 
				v_disp  <= V_DISP_7084; 
				v_total <= V_TOTAL_7084;    
				
			end
			
			16'h7016 : begin	// 7'   RGB LCD  RES:1024x600
			
				h_sync  <= H_SYNC_7016; 
				h_back  <= H_BACK_7016; 
				h_disp  <= H_DISP_7016; 
				h_total <= H_TOTAL_7016;
				v_sync  <= V_SYNC_7016; 
				v_back  <= V_BACK_7016; 
				v_disp  <= V_DISP_7016; 
				v_total <= V_TOTAL_7016;    
				
			end
			
			16'h4384 : begin	// 4.3' RGB LCD  RES:800x480
			
				h_sync  <= H_SYNC_4384; 
				h_back  <= H_BACK_4384; 
				h_disp  <= H_DISP_4384; 
				h_total <= H_TOTAL_4384;
				v_sync  <= V_SYNC_4384; 
				v_back  <= V_BACK_4384; 
				v_disp  <= V_DISP_4384; 
				v_total <= V_TOTAL_4384;    
				
			end
			
			16'h1018 : begin	// 10'  RGB LCD  RES:1280x800
			
				h_sync  <= H_SYNC_1018; 
				h_back  <= H_BACK_1018; 
				h_disp  <= H_DISP_1018; 
				h_total <= H_TOTAL_1018;
				v_sync  <= V_SYNC_1018; 
				v_back  <= V_BACK_1018; 
				v_disp  <= V_DISP_1018; 
				v_total <= V_TOTAL_1018;  
				
			end
			
			default : begin
			
				h_sync  <= H_SYNC_4342; 
				h_back  <= H_BACK_4342; 
				h_disp  <= H_DISP_4342; 
				h_total <= H_TOTAL_4342;
				v_sync  <= V_SYNC_4342; 
				v_back  <= V_BACK_4342; 
				v_disp  <= V_DISP_4342; 
				v_total <= V_TOTAL_4342;    
				
			end
		
		endcase
	
	end
	
	// h_cnt: 0 to (h_total - 1)
	always @(posedge lcd_pclk or negedge rst_n) begin
	
		if(!rst_n)
		
			h_cnt <= 11'd0;
			
		else begin
		
			if(h_cnt == h_total - 1'b1)
			
				h_cnt <= 11'd0;
				
			else
			
				h_cnt <= h_cnt + 1'b1;
		
		end
	
	end
	
	// v_cnt: 0 to (v_total - 1)
	always @(posedge lcd_pclk or negedge rst_n) begin
	
		if(!rst_n)
		
			v_cnt <= 11'd0;
			
		else begin
		
			if(h_cnt == h_total - 1'b1) begin
			
				if(v_cnt == v_total - 1'b1)
			
					v_cnt <= 11'd0;
					
				else
				
					v_cnt <= v_cnt + 1'b1;

			end
		
		end
	
	end
	
	// lcd_rst & lcd_bl: always on
	always @(posedge lcd_pclk or negedge rst_n) begin
	
		if(!rst_n) begin
		
			lcd_rst <= 1'b0;
			lcd_bl <= 1'b0;
		
		end
		else begin
		
			lcd_rst <= 1'b1;
			lcd_bl <= 1'b1;
		
		end
	
	end

endmodule