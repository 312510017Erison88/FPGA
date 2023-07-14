module memory_blocks(
  input [9:0] SW,
  input CLOCK_50,
  output wire [0:0] LEDR,      
  output [6:0] HEX0,
  output [6:0] HEX1,
  output [6:0] HEX2,
  output [6:0] HEX3
);

    // CLK divide
	wire SLOW_CLK;
    clk_divider clk_divider_1HZ(CLOCK_50, SLOW_CLK);

    // use register to store pre_SW[9] status
    // important!!
    reg pre_SW9;
    always@ (posedge SLOW_CLK) begin
        pre_SW9 <= SW[9];
    end

    // write enable
    wire enable;
    assign enable = ((!pre_SW9) && (SW[9]));

    // count in RAM
    reg [4:0] count;

    // count++
    always@(posedge SLOW_CLK) begin
        count <= count + 1;
    end

    // 5-bit write address
    reg [4:0] address;
    // 8-bit write data
    reg [7:0] data;

    // data_out_reg
    reg [7:0] data_out_reg;
    always@ (posedge CLOCK_50) begin
        data_out_reg <= data_out;
    end

    always@(posedge CLOCK_50) begin
        if(enable) begin
            address <= SW[4:0];
            myramfunction.data <= SW[7:0];
        end
        else begin
            address <= count;
            myramfunction.data <= 8'd0;
        end
    end

    assign LEDR[0] = SW[9];
    wire [7:0] data_out;

    // from ramlpm.v
    ramlpm myramfunction (
        .address(address),      // 5 bits
        .clock(CLOCK_50),       
        .data(data_out_reg),            // 8 bits
        .wren(enable),
        .q(data_out));          // 8 bits

    // Display address
    HEX_to_seven_segment display_addr1({3'b000, address[4]}, HEX3);
	HEX_to_seven_segment display_addr0(address[3:0], HEX2);
   
    // Display read out data
    HEX_to_seven_segment display_data1(data_out[7:4], HEX1);
	HEX_to_seven_segment display_data0(data_out[3:0], HEX0);

endmodule