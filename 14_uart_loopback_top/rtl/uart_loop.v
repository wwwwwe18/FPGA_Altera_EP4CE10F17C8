//*****************************************************
// Project		: 14_uart_loopback_top
// File			: uart_loop
// Editor		: Wenmei Wang
// Date			: 22/02/2025
// Description	: USART loop
//*****************************************************

module uart_loop (

	input				sys_clk		,
	input				sys_rst_n	,
	
	input				recv_done	,
	input		[7:0]	recv_data	,

	input				tx_busy		,
	output	reg			send_en		,
	output	reg	[7:0]	send_data

);

	reg			recv_done_d0	;
	reg			recv_done_d1	;
    
    reg         tx_ready		;
	
	wire		recv_done_flag	;
	
	// **********************************
	// recv_done_flag: capture rising edge of recv_done
	// **********************************
	assign	recv_done_flag = recv_done_d0 & (~recv_done_d1);
	
	// Generate recv_done_d0 & recv_done_d1
	always @(posedge sys_clk or negedge sys_rst_n) begin
	
		if(!sys_rst_n) begin	// Active low reset
		
			recv_done_d0 <= 1'b0;
			recv_done_d1 <= 1'b0;
		
		end
		else begin
		
			recv_done_d0 <= recv_done;
			recv_done_d1 <= recv_done_d0;
		
		end
		
	end
	
	// **********************************
	// send_en, send_data & tx_ready
	// **********************************
	always @(posedge sys_clk or negedge sys_rst_n) begin
	
		if(!sys_rst_n) begin
		
			send_en <= 1'b0;
			send_data <= 8'd0;
			tx_ready <= 1'b0;
		
		end
		else begin
		
			if(recv_done_flag) begin				// Ready to send
			
				send_en <= 1'b0;
				send_data <= recv_data;
				tx_ready <= 1'b1;
			
			end
			else if((~tx_busy) && (tx_ready)) begin	// Send data
			
				send_en <= 1'b1;
				tx_ready <= 1'b0;
			
			end
		
		
		
		end
		
	end
	


endmodule