module simple(a, b, Cin, SW, sum, LEDR, SEVEN_SEGMENT_DIGIT);
    input[3:0] a, b;
	input Cin; 
    input [17:0] SW;
    output [5:0] sum;
	output [17:0] LEDR;
	output [3:0] SEVEN_SEGMENT_DIGIT;
	 
    reg [3:0] s, cs;
    wire [2:0] co;
    wire [5:0] sum;         // 可不用宣告
	 
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
	 
        assign sum[0] = LEDR[0];
        assign sum[1] = LEDR[1];
        assign sum[2] = LEDR[2];
        assign sum[3] = LEDR[3];
        assign sum[4] = LEDR[4];
        assign sum[5] = LEDR[5];
        assign LEDR[17:6] = 12'b000000000000;
	 
	 end
	 
	 
	 /*
	 assign SEVEN_SEGMENT_DIGIT[0000] = 7'b1000000;
	 assign SEVEN_SEGMENT_DIGIT[0001] = 7'b1111001;
	 assign SEVEN_SEGMENT_DIGIT[0010] = 7'b0100100;
	 assign SEVEN_SEGMENT_DIGIT[0011] = 7'b0110000;
	 assign SEVEN_SEGMENT_DIGIT[0100] = 7'b0011001;
	 assign SEVEN_SEGMENT_DIGIT[0101] = 7'b0010010;
	 assign SEVEN_SEGMENT_DIGIT[0110] = 7'b0000010;
	 assign SEVEN_SEGMENT_DIGIT[0111] = 7'b1111000;
	 assign SEVEN_SEGMENT_DIGIT[1000] = 7'b0000000;
	 assign SEVEN_SEGMENT_DIGIT[1001] = 7'b0010000;
	 default: SEVEN_SEGMENT_DIGIT <= 7'b1111111; //blank
	 */
	 
endmodule