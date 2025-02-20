//*****************************************************
// Project		: 12_ip_2port_ram
// File			: ip_2port_ram
// Editor		: Wenmei Wang
// Date			: 20/02/2025
// Description	: Top
//*****************************************************

module ip_2port_ram (

	input	sys_clk,
	input	sys_rst_n

);

	wire			clk_50m		;
	wire			clk_25m		;
	wire			locked		;
	
	wire			ram_wr_en	;
	wire	[4:0]	ram_wr_addr ;
	wire	[7:0]	ram_wr_data ;
	
	wire			ram_rd_en	;
	wire	[4:0]	ram_rd_addr ;
	wire	[7:0]	ram_rd_data ;
	
	wire			rst_n		;
	
	assign rst_n = sys_rst_n & locked;

	pll_clk	u_pll_clk (
	
		.areset			(~sys_rst_n		),
		.inclk0 		(sys_clk		),
		.c0				(clk_50m		),
		.c1 			(clk_25m		),
		.locked 		(locked			)
		
	);
	
	ram_wr u_ram_wr (
	
		.clk			(clk_50m		),
		.rst_n		    (rst_n			),
		
		.ram_wr_en	    (ram_wr_en		),
		.ram_wr_addr    (ram_wr_addr	),
		.ram_wr_data    (ram_wr_data	)
	
	);
	
	ram_2port u_ram_2port (
	
		.data			(ram_wr_data	),
		.rdaddress		(ram_rd_addr	),
		.rdclock		(clk_25m		),
		.rden			(ram_rd_en		),
		.wraddress		(ram_wr_addr	),
		.wrclock		(clk_50m		),
		.wren			(ram_wr_en		),
		.q				(ram_rd_data	)
	
	);
	
	ram_rd u_ram_rd (
		
		.clk	    	(clk_25m		),
		.rst_n      	(rst_n			),
		
		.ram_rd_en		(ram_rd_en		),
		.ram_rd_addr	(ram_rd_addr	),
		
	    .ram_rd_data	(ram_rd_data	)
		
	);
	
endmodule