//*****************************************************
// Project		: 11_ip_1port_ram
// File			: ip_1port_ram_tb
// Editor		: Wenmei Wang
// Date			: 20/02/2025
// Description	: Testbench
//*****************************************************

`timescale 1ns/1ns	// Simulation <time_unit>/<time_precision>

module ip_1port_ram_tb();

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

	ip_1port_ram u_ip_1port_ram(

		.sys_clk			(sys_clk),
		.sys_rst_n			(sys_rst_n)
		
	);
	
endmodule
