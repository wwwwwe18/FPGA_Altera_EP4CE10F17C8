//*****************************************************
// Project		: 7_seg_led_dynamic
// File			: seg_led
// Editor		: Wenmei Wang
// Date			: 24/07/2024
// Description	: LED segment dynamic display module
//*****************************************************

module seg_led(
	input				sys_clk  ,
	input				sys_rst_n,
	
	input		[19:0]	data     ,	// Data to display on LED segment display
	input		[5:0]	point    ,	// Point, set HIGH to turn on
	input				sign     ,	// "-" sign, set HIGH to turn on
	input				en       ,	// Enable LED segment display
	
	output	reg	[5:0]	seg_sel  ,	// Digit
	output	reg	[7:0]	seg_led		// Scan
);

// Define parameter
parameter CLK_DIV = 4'd10;		// Clock division
parameter MAX_NUM = 13'd5_000;	// 5e3 * 200ns = 1ms

// Define wire
wire	[ 3:0]	data0;
wire	[ 3:0]	data1;
wire	[ 3:0]	data2;
wire	[ 3:0]	data3;
wire	[ 3:0]	data4;
wire	[ 3:0]	data5;

// Define reg
reg 			drive_clk;	// Clock for segment display 5MHz
reg		[ 3:0]	clk_cnt;	// Counter for clock division
reg		[23:0]	num;

reg		[12:0]	cnt0;
reg 			flag;

reg		[ 2:0]	cnt_sel;

reg		[ 3:0]	num_disp;
reg 			dot_disp;

//*****************************************************
//**                    Main code
//*****************************************************

// Data on each digit
assign data0 = data % 4'd10;
assign data1 = (data / 4'd10) % 4'd10;
assign data2 = (data / 7'd100) % 4'd10;
assign data3 = (data / 10'd1000) % 4'd10;
assign data4 = (data / 14'd10000) % 4'd10;
assign data5 = data / 17'd100000;

// Generate 5MHz clock
always @(posedge sys_clk or negedge sys_rst_n)begin
	if(!sys_rst_n) begin
		clk_cnt <= 4'd0;
		drive_clk <= 1'b1;
	end
	else if(clk_cnt == CLK_DIV / 2 - 1'b1) begin
		clk_cnt <= 4'd0;
		drive_clk <= ~drive_clk;
    end
	else begin
		clk_cnt <= clk_cnt + 1'b1;
		drive_clk <= drive_clk;
	end
end

// Convert 24'b to 8421bcd (use 4'b to display one-digit decimal)
always @(posedge drive_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		num <= 24'd0;
	else begin
		if(data5 || point[5]) begin			// 6-digit decimal
			num[23:20] <= data5;
			num[19:16] <= data4;
			num[15:12] <= data3;
			num[11:8] <= data2;
			num[7:4] <= data1;
			num[3:0] <= data0;
		end
		else begin
			if(data4 || point[4]) begin		// 5-digit decimal
				num[19:0] <= {data4,data3,data2,data1,data0};
				if(sign)
					num[23:20] <= 4'd11;	// Display "-"
				else
					num[23:20] <= 4'd10;	// No display on 6th digit
			end
			else begin
				if(data3 || point[3]) begin	// 4-digit decimal
					num[15:0] <= {data3,data2,data1,data0};
					num[23:20] <= 4'd10;	// No display on 6th digit
					if(sign)
						num[19:16] <= 4'd11;
					else
						num[19:16] <= 4'd10;
				end
				else begin
					if(data2 || point[2]) begin
						num[11:0] <= {data2,data1,data0};
						num[23:16] <= {2{4'd10}};
						if(sign)
							num[15:12] <= 4'd11;
						else
							num[15:12] <= 4'd10;
					end
					else begin
						if(data1 || point[1]) begin
							num[7:0] <= {data1,data0};
							num[23:12] <= {3{4'd10}};
							if(sign)
								num[11:8] <= 4'd11;
							else
								num[11:8] <= 4'd10;
                        end
						else begin
							num[3:0] <= data0;
							num[23:8] <= {4{4'd10}};
							if(sign)
								num[7:4] <= 4'd11;
							else
								num[7:4] <= 4'd10;
						end
					end
				end
			end
		end
	end
end

// Generate pulse signal when the counter counts drive clock to 1ms
always @(posedge drive_clk or negedge sys_rst_n)begin
	if(!sys_rst_n) begin
		cnt0 <= 13'b0;
		flag <= 1'b0;
	end
	else if(cnt0 <= MAX_NUM - 1'b1) begin
		cnt0 <= cnt0 + 1'b1;
		flag <= 1'b0;
	end
	else begin
		cnt0 <= 13'b0;
		flag <= 1'b1;
	end
end

// cnt_sel counts from 0 to 5 - select digit to display
always @(posedge drive_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		cnt_sel <= 3'b0;
	else if(flag) begin
		if(cnt_sel < 3'd5)
			cnt_sel <= cnt_sel +1'b1;
		else
			cnt_sel <= 3'd0;
	end
	else
		cnt_sel <= cnt_sel;
end

// Data to display on digit
always @(posedge drive_clk or negedge sys_rst_n)begin
	if(!sys_rst_n) begin
		seg_sel <= 6'b111_111;	// Common anode, set HIGH to turn off
		num_disp <= 4'b0;
		dot_disp <= 1'b1;		// Common anode, set HIGH to turn off
	end
	else begin
		if(en) begin
			case(cnt_sel)
				3'd0: begin
					seg_sel <= 6'b111_110;
					num_disp <= num[3:0];
					dot_disp <= ~point[0];
				end
				3'd1: begin
					seg_sel <= 6'b111_101;
					num_disp <= num[7:4];
					dot_disp <= ~point[1];
				end
				3'd2: begin
					seg_sel <= 6'b111_011;
					num_disp <= num[11:8];
					dot_disp <= ~point[2];
				end
				3'd3: begin
					seg_sel <= 6'b110_111;
					num_disp <= num[15:12];
					dot_disp <= ~point[3];
				end
				3'd4: begin
					seg_sel <= 6'b101_111;
					num_disp <= num[19:16];
					dot_disp <= ~point[4];
				end
				3'd5: begin
					seg_sel <= 6'b011_111;
					num_disp <= num[23:20];
					dot_disp <= ~point[5];
				end
				default: begin
					seg_sel <= 6'b111_111;
					num_disp <= 4'b0;
					dot_disp <= 1'b1;
				end
			endcase
		end
		else begin
			seg_sel <= 6'b111_111;
			num_disp <= 4'b0;
			dot_disp <= 1'b1;
		end
	end
end

// Decode
always @(posedge drive_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		seg_led <= 8'b0;
	else begin
		case(num_disp)
			4'd0: seg_led <= {dot_disp, 7'b100_0000};		// Display 0
			4'd1: seg_led <= {dot_disp, 7'b111_1001};		// Display 1
			4'd2: seg_led <= {dot_disp, 7'b010_0100};		// Display 2
			4'd3: seg_led <= {dot_disp, 7'b011_0000};		// Display 3
			4'd4: seg_led <= {dot_disp, 7'b001_1001};		// Display 4
			4'd5: seg_led <= {dot_disp, 7'b001_0010};		// Display 5
			4'd6: seg_led <= {dot_disp, 7'b000_0010};		// Display 6
			4'd7: seg_led <= {dot_disp, 7'b111_1000};		// Display 7
			4'd8: seg_led <= {dot_disp, 7'b000_0000};		// Display 8
			4'd9: seg_led <= {dot_disp, 7'b001_0000};		// Display 9
			4'd10: seg_led <= 8'b1111_1111;					// No display
			4'd11: seg_led <= 8'b1011_1111;					// Display "-"
			default: seg_led <= {dot_disp, 7'b100_0000};	// Display 0
		endcase
	end
end

endmodule