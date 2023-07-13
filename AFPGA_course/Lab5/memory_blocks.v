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

    // write enable
    wire enable;

    // count in RAM
    reg [4:0] count;

    assign enable = ((!pre_SW9) && (SW[9]));

    always@(posedge SLOW_CLK) begin
        if(enable) begin
            count = count + 1;
        end
    end

    // 5-bit write address
    wire address;
    assign address = SW[4:0];

    // 8-bit write data
    wire [7:0] data;
    assign data = SW[7:0];
	
    
    
    reg [3:0] count;
    reg [3:0] data_out;

    // from ramlpm.v
    ramlpm myramfunction (
	.address(address),
	.clock(CLOCK_50),
	.data(data),
	.wren(enable),
	.q(data_out));

    // Display address
    HEX_to_seven_segment display_HEX3({3'b000, address[4]}, HEX3);
	HEX_to_seven_segment display_HEX2(address[3:0], HEX2);
   
    // Display read out data
    HEX_to_seven_segment display_HEX1(data_out[7:4], HEX1);
	HEX_to_seven_segment display_HEX0(data_out[3:0], HEX0);

endmodule