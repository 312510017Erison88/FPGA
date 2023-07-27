module upcount(clear, clk, q);
    // 1 clock cycle
    input clear,  clk;
    output reg q;

    always @(posedge clk or posedge clear) begin
        if (clear)
            q <= 1'b0;
        else
            q <= q + 1'b1;
    end
endmodule