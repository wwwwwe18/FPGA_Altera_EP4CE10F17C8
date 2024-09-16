//*****************************************************
// Project		: 10_ip_pll
// File			: ip_pll
// Editor		: Wenmei Wang
// Date			: 25/07/2024
// Description	: Top module
//*****************************************************

module ip_pll(
    input   sys_clk         ,
    input   sys_rst_n       ,
    
    output  clk_100m        ,
    output  clk_100m_180deg ,
    output  clk_50m         ,
    output  clk_25m
);

// Define wire
wire rst_n;
wire locked;

//*****************************************************
//**                    Main code
//*****************************************************

assign rst_n = sys_rst_n & locked;

pll_clk	u_pll_clk (
	.areset	(~sys_rst_n		),
	.inclk0	(sys_clk		),
	.c0		(clk_100m		),
	.c1		(clk_100m_180deg),
	.c2		(clk_50m		),
	.c3		(clk_25m		),
	.locked	(locked			)
	);

endmodule