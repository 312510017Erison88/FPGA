module count_addr(reset, clk, Q);
    input reset, clk;
    output reg [4:0] Q;
    always @(posedge clk, posedge reset) begin
        if(reset)
            Q <= 5'd0;
        else
            Q <= Q + 1'b1;
    end
endmodule