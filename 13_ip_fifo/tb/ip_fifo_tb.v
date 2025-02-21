//*****************************************************
// Project		: 13_ip_fifo
// File			: ip_fifo_tb
// Editor		: Wenmei Wang
// Date			: 21/02/2025
// Description	: Testbench
//*****************************************************

`timescale 1ns/1ns

module ip_fifo_tb();

	parameter	T = 20		;

	reg			sys_clk		;
	reg			sys_rst_n	;

	initial begin
	
		sys_clk = 1'b0;
		sys_rst_n = 1'b0;
		#(T+1)
		sys_rst_n = 1'b1;
		
	end

	always #(T/2) sys_clk = ~sys_clk;

	ip_fifo u_ip_fifo (

		.sys_clk			(sys_clk),
		.sys_rst_n			(sys_rst_n)
		
	);
	
endmodule
