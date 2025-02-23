//*****************************************************
// Project		: 14_uart_loopback_top
// File			: uart_send
// Editor		: Wenmei Wang
// Date			: 22/02/2025
// Description	: USART transmitter
//*****************************************************

module uart_send (

	input				sys_clk		,
	input				sys_rst_n	,
	
	input				uart_en		,
	input	[7:0]		uart_din	,
	
	output	reg			uart_txd	,
	output				uart_tx_busy

);
	
	// **********************************
	// Parameter
	// **********************************
	parameter	CLK_FREQ	= 50_000_000		;	// 50MHz
	parameter	UART_BPS	= 115200			;	// Baud rate
	localparam	BPS_cnt		= CLK_FREQ/UART_BPS	;	// 434

	reg			uart_en_d0	;
	reg			uart_en_d1	;
	
	reg			tx_flag		;
	
	reg	[3:0]	tx_cnt		;	// 0 to 9
	reg	[8:0]	clk_cnt		;	// 0 to (BPS_cnt - 1)
	
	reg	[7:0]	tx_data		;
	
	wire		en_flag		;
	
	// **********************************
	// uart_tx_busy
	// **********************************
	assign	uart_tx_busy = tx_flag;

	// **********************************
	// en_flag: capture rising edge of uart_en
	// **********************************
	assign	en_flag = uart_en_d0 & (~uart_en_d1);
	
	// Generate uart_en_d0 & uart_en_d1
	always @(posedge sys_clk or negedge sys_rst_n) begin
	
		if(!sys_rst_n) begin	// Active low reset
		
			uart_en_d0 <= 1'b0;
			uart_en_d1 <= 1'b0;
		
		end
		else begin
		
			uart_en_d0 <= uart_en;
			uart_en_d1 <= uart_en_d0;
		
		end
	
	end
	
	// **********************************
	// tx_flag & tx_data
	// **********************************
	always @(posedge sys_clk or negedge sys_rst_n) begin
	
		if(!sys_rst_n) begin
			
			tx_flag <= 1'b0;
			tx_data <= 8'd0;
		
		end
		else if(en_flag) begin
		
			tx_flag <= 1'b1;
			tx_data <= uart_din;
		
		end
		else if((tx_cnt == 4'd9) && (clk_cnt == BPS_cnt - BPS_cnt/16)) begin	// (15/16) * BPS_cnt
		
			tx_flag <= 1'b0;
			tx_data <= 8'd0;
		
		end
		else begin
		
			tx_flag <= tx_flag;
			tx_data <= tx_data;
		
		end
	
	end
	
	// **********************************
	// clk_cnt: 0 to (BPS_cnt - 1)
	// **********************************
	always @(posedge sys_clk or negedge sys_rst_n) begin
		
		if(!sys_rst_n)
		
			clk_cnt <= 9'd0;
			
		else if(tx_flag) begin
		
			if(clk_cnt < BPS_cnt - 1)
			
				clk_cnt <= clk_cnt + 1'b1;
				
			else
			
				clk_cnt <= 9'd0;
		
		end
		else
		
			clk_cnt <= 9'd0;
	
	end
	
	// **********************************
	// tx_cnt: 0 to 9
	// **********************************
	always @(posedge sys_clk or negedge sys_rst_n) begin
		
		if(!sys_rst_n)
		
			tx_cnt <= 4'd0;
		
		else if(tx_flag) begin
		
			if(clk_cnt == BPS_cnt - 1)
			
				tx_cnt <= tx_cnt + 1'b1;
				
			else
			
				tx_cnt <= tx_cnt;
		
		end
		else
		
			tx_cnt <= 4'd0;
		
	end
	
	// **********************************
	// uart_txd: parallel to serial
	// **********************************
	always @(posedge sys_clk or negedge sys_rst_n) begin
		
		if(!sys_rst_n)
		
			uart_txd <= 1'b1;
			
		else if(tx_flag) begin
		
			case(tx_cnt)
			
				4'd0: uart_txd <= 1'b0;			// Start bit
				4'd1: uart_txd <= tx_data[0];	// LSB to MSB
				4'd2: uart_txd <= tx_data[1];
				4'd3: uart_txd <= tx_data[2];
				4'd4: uart_txd <= tx_data[3];
				4'd5: uart_txd <= tx_data[4];
				4'd6: uart_txd <= tx_data[5];
				4'd7: uart_txd <= tx_data[6];
				4'd8: uart_txd <= tx_data[7];
				4'd9: uart_txd <= 1'b1;			// Stop bit
				default: ;
			
			endcase
		
		end
		else
		
			uart_txd <= 1'b1;
			
	end

endmodule