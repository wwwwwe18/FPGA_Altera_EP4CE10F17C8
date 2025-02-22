
package require ::quartus::project

#system clock:50Mhz
set_location_assignment PIN_M2 -to sys_clk

#system reset
set_location_assignment PIN_M1 -to sys_rst_n

#USB UART
set_location_assignment PIN_N5  -to uart_rxd
set_location_assignment PIN_M7  -to uart_txd
