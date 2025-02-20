//*****************************************************
// Project		: 11_ip_1port_ram
// File			: ip_1port_ram
// Editor		: Wenmei Wang
// Date			: 20/02/2025
// Description	: Top
//*****************************************************

module ip_1port_ram (

	input	sys_clk,
	input	sys_rst_n

);

	wire			ram_wr_en	;
	wire			ram_rd_en	;
	wire	[4:0]	ram_addr	;
	wire	[7:0]	ram_wr_data	;
	wire	[7:0]	ram_rd_data	;
	
	ram_rw u_ram_rw (
	
		.clk			(sys_clk		),
		.rst_n          (sys_rst_n		),
		
		.ram_wr_en      (ram_wr_en		),
		.ram_rd_en      (ram_rd_en		),
		.ram_addr       (ram_addr		),
		.ram_wr_data    (ram_wr_data	),
		.ram_rd_data    (ram_rd_data	)
	
	);
	
	ram_1port u_ram_1port (
	
		.address		(ram_addr		),
		.clock			(sys_clk		),
		.data			(ram_wr_data	),
		.rden			(ram_rd_en		),
		.wren			(ram_wr_en		),
		.q				(ram_rd_data	)
	
	);

endmodule