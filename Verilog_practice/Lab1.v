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
	 assign SW[0] = a[0];
	 assign SW[1] = a[1];
	 assign SW[2] = a[2];
	 assign SW[3] = a[3];
	 assign SW[4] = b[0];
	 assign SW[5] = b[1];
	 assign SW[6] = b[2];
	 assign SW[7] = b[3];
	 assign SW[8] = Cin;
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