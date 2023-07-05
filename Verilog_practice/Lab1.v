module simple(a, b, Cin, SW, sum, LEDR, SEVEN_SEGMENT_DIGIT);
    input[3:0] a, b;
	input Cin; 
    input [17:0] SW;
    output [5:0] sum;
	output [17:0] LEDR;
	output [3:0] SEVEN_SEGMENT_DIGIT;
	 
    reg [3:0] s, cs;
    wire [2:0] co;
    reg [5:0] sum;         // 可不用宣告
	 
    always@(a or b or Cin)
    begin
        {cs[0], s[0]} = a[0] + b[0] + Cin;
        {cs[1], s[1]} = a[1] + b[1]; 
        {cs[2], s[2]} = a[2] + b[2]; 
        {cs[3], s[3]} = a[3] + b[3];
    end
    assign sum[0] = s[0];
    assign {co[0], sum[1]} = cs[0] + s[1];
    assign {co[1], sum[2]} = cs[1] + s[2] + co[0];
    assign {co[2], sum[3]} = cs[2] + s[3] + co[1];
    assign {sum[5], sum[4]} = cs[3] + co[2];
	 
	initial begin
        assign a[0] = SW[0];
        assign a[1] = SW[1];
        assign a[2] = SW[2];
        assign a[3] = SW[3];

        assign b[0] = SW[4];
        assign b[1] = SW[5];
        assign b[2] = SW[6];
        assign b[3] = SW[7];
        assign SW[17:9] = 9'b000000000;
	 
        assign LEDR[0] = sum[0];
        assign LEDR[1] = sum[1];
        assign LEDR[2] = sum[2];
        assign LEDR[3] = sum[3];
        assign LEDR[4] = sum[4];
        assign LEDR[5] = sum[5];
        assign LEDR[17:6] = 12'b000000000000;
	 
	 end
	 
	 /*
	 always @(*) begin
        case (SW[3:0])
            4'b0000: SEVEN_SEGMENT_DIGIT = 7'b1000000;
            4'b0001: SEVEN_SEGMENT_DIGIT = 7'b1111001;
            4'b0010: SEVEN_SEGMENT_DIGIT = 7'b0100100;
            4'b0011: SEVEN_SEGMENT_DIGIT = 7'b0110000;
            4'b0100: SEVEN_SEGMENT_DIGIT = 7'b0011001;
            4'b0101: SEVEN_SEGMENT_DIGIT = 7'b0010010;
            4'b0110: SEVEN_SEGMENT_DIGIT = 7'b0000010;
            4'b0111: SEVEN_SEGMENT_DIGIT = 7'b1111000;
            4'b1000: SEVEN_SEGMENT_DIGIT = 7'b0000000;
            4'b1001: SEVEN_SEGMENT_DIGIT = 7'b0010000;
            default: SEVEN_SEGMENT_DIGIT = 7'b1111111; // blank
        endcase
    end
	 */
	 
endmodule


// 課本的
module example verilog (SW, LEDR, LEDG);
input [2:0] SW;
output [2:0] LEDR;
output [0:0] LEDG;
wire x1, x2, x3, f;
assign x1 = SW[0];
assign x2 = SW[1];
assign x3 = SW[2];
assign LEDR = SW;
assign f = (x1 & x2) ( x2 & x3);
assign LEDG[0] = f;
endmodule

// chatgpt wrong
module simple(Cin, SW, sum, LEDR, SEVEN_SEGMENT_DIGIT);
    input Cin; 
    input [17:0] SW;
    output [5:0] sum;
    output [17:0] LEDR;
    output [3:0] SEVEN_SEGMENT_DIGIT;

    reg [3:0] a, b;
    reg [3:0] s, cs;
    wire [2:0] co;

    always @* begin
        {cs[0], s[0]} = a[0] + b[0] + Cin;
        {cs[1], s[1]} = a[1] + b[1];
        {cs[2], s[2]} = a[2] + b[2];
        {cs[3], s[3]} = a[3] + b[3];

        sum[0] = s[0];
        {co[0], sum[1]} = cs[0] + s[1];
        {co[1], sum[2]} = cs[1] + s[2] + co[0];
        {co[2], sum[3]} = cs[2] + s[3] + co[1];
        {sum[5], sum[4]} = cs[3] + co[2];

        a[0] = SW[0];
        a[1] = SW[1];
        a[2] = SW[2];
        a[3] = SW[3];

        b[0] = SW[4];
        b[1] = SW[5];
        b[2] = SW[6];
        b[3] = SW[7];
    end

    assign LEDR[0] = sum[0];
    assign LEDR[1] = sum[1];
    assign LEDR[2] = sum[2];
    assign LEDR[3] = sum[3];
    assign LEDR[4] = sum[4];
    assign LEDR[5] = sum[5];
    assign LEDR[17:6] = 12'b000000000000;

    always @(*) begin
        case (SW[3:0])
            4'b0000: SEVEN_SEGMENT_DIGIT = 7'b1000000;
            4'b0001: SEVEN_SEGMENT_DIGIT = 7'b1111001;
            4'b0010: SEVEN_SEGMENT_DIGIT = 7'b0100100;
            4'b0011: SEVEN_SEGMENT_DIGIT = 7'b0110000;
            4'b0100: SEVEN_SEGMENT_DIGIT = 7'b0011001;
            4'b0101: SEVEN_SEGMENT_DIGIT = 7'b0010010;
            4'b0110: SEVEN_SEGMENT_DIGIT = 7'b0000010;
            4'b0111: SEVEN_SEGMENT_DIGIT = 7'b1111000;
            4'b1000: SEVEN_SEGMENT_DIGIT = 7'b0000000;
            4'b1001: SEVEN_SEGMENT_DIGIT = 7'b0010000;
            default: SEVEN_SEGMENT_DIGIT = 7'b1111111; // blank
        endcase
    end

endmodule
