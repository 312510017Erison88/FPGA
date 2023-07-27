module reg_nbits (IRin, clk, reset, DIN, Q);
    parameter N = 8;
    input IRin, clk, reset;
    input [N-1:0] DIN;
    output reg [N-1:0] Q;

    always @(posedge clk or posedge reset) begin
        if (reset)
            Q <= 0;
        else if (IRin)
            Q <= DIN;
        else
            Q <= Q;
    end
endmodule