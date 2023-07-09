module clk_divider(BOARD_CLK, SLOW_CLK);
    input BOARD_CLK;
    output reg SLOW_CLK;

    // default freqency = 1
    parameter freq = 1;
    //integer max_count = 50 / freq;
    integer max_count = 50_000000 / freq;
    

    reg [31: 0] count = 0;
    always@(posedge BOARD_CLK) begin
        count <= (count == max_count - 1) ? 0 : count + 1;
        SLOW_CLK <= (count < max_count / 2) ? 1'b0 : 1'b1;
    end
endmodule