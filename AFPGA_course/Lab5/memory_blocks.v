module memory_blocks(
  input [9:0] SW,
  input CLOCK_50,
  output reg [0:0] LEDR,      
  output [6:0] HEX0,
  output [6:0] HEX1,
  output [6:0] HEX2,
  output [6:0] HEX3
);

    // 除頻
	wire CLK_1HZ, CLK_1000HZ;
    clk_divider clk_divider_uut0(CLOCK_50, CLK_1HZ);
    clk_divider clk_divider_uut1(CLOCK_50, CLK_1000HZ);
    defparam clk_divider_uut1.freq = 1000;

    wire SLOW_CLK;
    assign SLOW_CLK = (KEY[1]) ? CLK_1HZ : CLK_1000HZ;

    // Clock
    wire CLK;
    assign CLK = !KEY[0];
    
    
    reg [3:0] count;

    // from ramlpm.v
    ramlpm (
	.address(),
	.clock(),
	.data(),
	.wren(),
	.q());
    // display on HEX0
    

endmodule