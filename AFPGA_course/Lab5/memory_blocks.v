module memory_blocks(
  input [9:0] SW,
  input CLOCK_50,
  output reg [0:0] LEDR,      
  output [6:0] HEX0,
  output [6:0] HEX1,
  output [6:0] HEX2,
  output [6:0] HEX3
);

    // CLK divide
	wire CLK_1HZ, CLK_1000HZ;
    clk_divider clk_divider_uut0(CLOCK_50, CLK_1HZ);

    wire SLOW_CLK;
    assign SLOW_CLK = CLK_1HZ;

    // use register to store pre_SW[8] status
    // important!!
    reg pre_SW9;
    always@ (posedge SLOW_CLK) begin
        pre_SW9 <= SW[9];
    end

    wire settime;
    assign settime = ((!pre_SW8) && (SW[8]));
	
    
    
    reg [3:0] count;

    // from ramlpm.v
    ramlpm addname (
	.address(),
	.clock(),
	.data(),
	.wren(),
	.q());
    // display on HEX0
    

endmodule