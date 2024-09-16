//*****************************************************
// Project		: 6_seg_led_static_top
// File			: seg_led_static
// Editor		: Wenmei Wang
// Date			: 24/07/2024
// Description	: Segment display from 111111 to FFFFFF
//*****************************************************

module seg_led_static(
	input				sys_clk  ,
	input 				sys_rst_n,
	
	input				add_flag ,
	output	reg	[5:0]	seg_sel  ,
	output	reg	[7:0]	seg_led
);

// Define reg
reg [3:0] num;

//*****************************************************
//**                    main code
//*****************************************************

// Number accumulates from 0 to 15
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		num <= 1'b0;
	else if(add_flag) begin
		if(num < 4'hf)
			num <= num + 1'b1;
		else
			num <= 1'b0;
	end
	else
		num <= num;
end

// Control seg_sel
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		seg_sel <= 6'b11_1111;
	else
		seg_sel <= 6'b00_0000;
end

// Decode
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		seg_led <= 8'b0;
	else begin
		case(num)
			4'h0: 		seg_led <= 8'b1100_0000;
			4'h1: 		seg_led <= 8'b1111_1001;
			4'h2: 		seg_led <= 8'b1010_0100;
			4'h3: 		seg_led <= 8'b1011_0000;
			4'h4: 		seg_led <= 8'b1001_1001;
			4'h5: 		seg_led <= 8'b1001_0010;
			4'h6: 		seg_led <= 8'b1000_0010;
			4'h7: 		seg_led <= 8'b1111_1000;
			4'h8: 		seg_led <= 8'b1000_0000;
			4'h9: 		seg_led <= 8'b1001_0000;
			4'ha: 		seg_led <= 8'b1000_1000;
			4'hb: 		seg_led <= 8'b1000_0011;
			4'hc: 		seg_led <= 8'b1100_0110;
			4'hd: 		seg_led <= 8'b1010_0001;
			4'he: 		seg_led <= 8'b1000_0110;
			4'hf: 		seg_led <= 8'b1000_1110;
			default:	seg_led <= 8'b0000_0000;
        endcase
	end
end

endmodule