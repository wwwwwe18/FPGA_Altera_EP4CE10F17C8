//*****************************************************
// Project		: 14_uart_loopback_top
// File			: uart_recv
// Editor		: Wenmei Wang
// Date			: 22/02/2025
// Description	: USART receiver
//*****************************************************

module uart_recv (

	input				sys_clk		,
	input				sys_rst_n	,
	
	input				uart_rxd	,
	
	output	reg	[7:0]	uart_data	,
	output	reg			uart_done

);

	// **********************************
	// Parameter
	// **********************************
	parameter	CLK_FREQ	= 50_000_000		;	// 50MHz
	parameter	UART_BPS	= 115200			;	// Baud rate
	localparam	BPS_cnt		= CLK_FREQ/UART_BPS	;	// 434

	reg			uart_rxd_d0	;
	reg			uart_rxd_d1	;
	
	reg			rx_flag		;
	
	reg	[3:0]	rx_cnt		;	// 0 to 9
	reg	[8:0]	clk_cnt		;	// 0 to (BPS_cnt - 1)
	
	reg	[7:0]	rx_data		;
	
	wire		start_flag	;
	
	// **********************************
	// start_flag: capture falling edge of uart_rxd
	// **********************************
	assign	start_flag = (~uart_rxd_d0) & uart_rxd_d1;
	
	// Generate uart_rxd_d0 & uart_rxd_d1
	always @(posedge sys_clk or negedge sys_rst_n) begin
	
		if(!sys_rst_n) begin	// Active low reset
		
			uart_rxd_d0 <= 1'b0;
			uart_rxd_d1 <= 1'b0;
		
		end
		else begin
		
			uart_rxd_d0 <= uart_rxd;
			uart_rxd_d1 <= uart_rxd_d0;
		
		end
	
	end
	
	// **********************************
	// rx_flag
	// **********************************
	always @(posedge sys_clk or negedge sys_rst_n) begin
	
		if(!sys_rst_n)
			
			rx_flag <= 1'b0;
			
		else begin
		
			if(start_flag)
			
				rx_flag <= 1'b1;
				
			else if((rx_cnt == 4'd9) && (clk_cnt == BPS_cnt/2))
			
				rx_flag <= 1'b0;
				
			else
			
				rx_flag <= rx_flag;
		
		end	
	
	end
	
	// **********************************
	// clk_cnt: 0 to (BPS_cnt - 1)
	// **********************************
	always @(posedge sys_clk or negedge sys_rst_n) begin
		
		if(!sys_rst_n)
		
			clk_cnt <= 9'd0;
			
		else if(rx_flag) begin
		
			if(clk_cnt < BPS_cnt - 1)
			
				clk_cnt <= clk_cnt + 1'b1;
				
			else
			
				clk_cnt <= 9'd0;
		
		end
		else
		
			clk_cnt <= 9'd0;
	
	end
	
	// **********************************
	// rx_cnt: 0 to 9
	// **********************************
	always @(posedge sys_clk or negedge sys_rst_n) begin
		
		if(!sys_rst_n)
		
			rx_cnt <= 4'd0;
		
		else if(rx_flag) begin
		
			if(clk_cnt == BPS_cnt - 1)
			
				rx_cnt <= rx_cnt + 1'b1;
				
			else
			
				rx_cnt <= rx_cnt;
		
		end
		else
		
			rx_cnt <= 4'd0;
		
	end
	
	// **********************************
	// rx_data: serial to parallel
	// **********************************
	always @(posedge sys_clk or negedge sys_rst_n) begin
		
		if(!sys_rst_n)
		
			rx_data <= 8'd0;
			
		else if(rx_flag) begin
		
			if(clk_cnt == BPS_cnt/2) begin
			
				case(rx_cnt)
				
					4'd1: rx_data[0] <= uart_rxd_d1;	// LSB to MSB
					4'd2: rx_data[1] <= uart_rxd_d1;
					4'd3: rx_data[2] <= uart_rxd_d1;
					4'd4: rx_data[3] <= uart_rxd_d1;
					4'd5: rx_data[4] <= uart_rxd_d1;
					4'd6: rx_data[5] <= uart_rxd_d1;
					4'd7: rx_data[6] <= uart_rxd_d1;
					4'd8: rx_data[7] <= uart_rxd_d1;
					default: ;
				
				endcase
			
			end
			else
			
				rx_data <= rx_data;
			
		end
		else
		
			rx_data <= 8'd0;
		
	end
	
	// **********************************
	// uart_data & uart_done
	// **********************************
	always @(posedge sys_clk or negedge sys_rst_n) begin
		
		if(!sys_rst_n) begin
		
			uart_data <= 8'd0;
			uart_done <= 1'b0;
		
		end
		else if(rx_cnt == 4'd9) begin
		
			uart_data <= rx_data;
			uart_done <= 1'b1;
		
		end
		else begin
		
			uart_data <= 8'd0;
			uart_done <= 1'b0;
		
		end
		
	end

endmodule