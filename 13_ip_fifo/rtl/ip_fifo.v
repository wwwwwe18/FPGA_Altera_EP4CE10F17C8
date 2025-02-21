//*****************************************************
// Project		: 13_ip_fifo
// File			: ip_fifo
// Editor		: Wenmei Wang
// Date			: 21/02/2025
// Description	: Top
//*****************************************************

module ip_fifo (

	input	sys_clk,
	input	sys_rst_n

);

	wire			clk_50m		;
	wire			clk_25m		;
	wire			locked		;
	
	wire			rst_n		;
	
	wire	[7:0]	wr_usedw	;
	wire	[7:0]	rd_usedw	;
	
	wire			wr_full		;
	wire			wr_empty	;
	wire			wr_req		;
	wire	[7:0]	wr_data		;
	
	wire			rd_full		;
	wire			rd_empty	;
	wire			rd_req		;
	wire	[7:0]	rd_data		;
	
	assign rst_n = sys_rst_n & locked;

	pll_clk u_pll_clk (
	
		.areset		(~sys_rst_n	),
		.inclk0 	(sys_clk	),
		.c0			(clk_50m	),
		.c1 		(clk_25m	),
		.locked 	(locked		)
		
	);
	
	fifo_wr u_fifo_wr (
		
		.clk		(clk_50m	),
		.rst_n	   	(rst_n		),
		
		.wr_full	(wr_full	),
		.wr_empty  	(wr_empty	),
	    .wr_req	   	(wr_req		),
	    .wr_data   	(wr_data	)
	);
	
	async_fifo	u_async_fifo (
	
		.aclr		(~rst_n		),
		.data		(wr_data	),
		.rdclk		(clk_25m	),
		.rdreq		(rd_req		),
		.wrclk		(clk_50m	),
		.wrreq		(wr_req		),
		.q			(rd_data	),
		.rdempty	(rd_empty	),
		.rdfull		(rd_full	),
		.rdusedw	(rd_usedw	),
		.wrempty	(wr_empty	),
		.wrfull		(wr_full	),
		.wrusedw	(wr_usedw	)
		
	);
	
	fifo_rd u_fifo_rd (
	
		.clk		(clk_25m	),
		.rst_n	   	(rst_n		),
		
		.rd_full	(rd_full	),
		.rd_empty  	(rd_empty	),
	    .rd_req	   	(rd_req		),
		
	    .rd_data   	(rd_data	)
		
	);
	
endmodule