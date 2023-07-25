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
	wire SLOW_CLK, QUICK_800HZ, QUICK_8000HZ;
    clk_divider clk_divider_1HZ(CLOCK_50, SLOW_CLK);
    clk_divider clk_divider_1000HZ(CLOCK_50, QUICK_800HZ);
    clk_divider clk_divider_10000HZ(CLOCK_50, QUICK_8000HZ);
    defparam clk_divider_800HZ.freq = 800;
    defparam clk_divider_8000HZ.freq = 8000;

    // use register to store SW9_open status
    reg SW9_open;
    always@(posedge QUICK_800HZ) begin
        if (SW[9])
            SW9_open <= ~SW9_open;
        else
            SW9_open <= 0;
    end

    // write enable
    reg wren;

    // count in RAM
    reg [4:0] count;

    // count++
    always@(posedge SLOW_CLK) begin
        count <= count + 1;
    end

    // 5-bit write address
    reg [4:0] address, address_show;

    // 8-bit write data
    reg [7:0] data;
    wire [7:0] data_out;
    reg [7:0] data_show;

    // LED show when write
    assign LEDR[0] = SW[9];

    // do write else read
    always@(posedge QUICK_8000HZ) begin
        address_show <= address_show;
        data_show <= data_show;

        if(SW9_open) begin
            address <= SW[4:0];
            data <= SW[7:0];
            wren <= 1;
        end
        else begin
            address <= count;
            data <= 8'd0;
            wren <= 0;
            address_show <= address;
            data_show <= data_out;
        end
    end

    // from ramlpm.v
    ramlpm myramfunction (
        .address(address),      // 5 bits
        .clock(CLOCK_50),       
        .data(data),            // 8 bits
        .wren(wren),
        .q(data_out));          // 8 bits

    // Display address
    HEX_to_seven_segment display_addr1({3'b000, address_show[4]}, HEX3);
	HEX_to_seven_segment display_addr0(address_show[3:0], HEX2);
   
    // Display read out data
    HEX_to_seven_segment display_data1(data_show[7:4], HEX1);
	HEX_to_seven_segment display_data0(data_show[3:0], HEX0);

endmodule