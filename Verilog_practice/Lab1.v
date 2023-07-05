module seven_seg(in, seg);
input [3:0] in;     // 輸入4_bit
output [6:0] seg;   // 輸出7_bit
always@(in)
begin
    case(in)
        4'b0000: seg = 7'b1000000;
        4'b0001: seg = 7'b1111001;
        4'b0010: seg = 7'b0100100;
        4'b0011: seg = 7'b0110000;
        4'b0100: seg = 7'b0011001;
        4'b0101: seg = 7'b0010010;
        4'b0110: seg = 7'b0000010;
        4'b0111: seg = 7'b1111000;
        4'b1000: seg = 7'b0000000;
        4'b1001: seg = 7'b0010000;
        default: seg = 7'b1111111; // blank
    endcase
end
endmodule


module full_adder(a, b, Cin, SW, sum, Cout, LEDR, seg0, seg1, seg2);
    input[3:0] a, b;
	input Cin; 
    input [17:0] SW;
    output [3:0] sum;
    output Cout;
	output [17:0] LEDR;
	output [6:0] seg0, seg1, seg2;
	 
    reg [3:0] s, cs;
    wire [2:0] co;
    reg [3:0] sum;         // 可不用宣告
	 
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
    assign {Cout, sum[4]} = cs[3] + co[2];
	 
	initial 
    begin
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
    //seven_seg s0(.in(a), .seg(seg0));
    //seven_seg s1(.in(b), .seg(seg1));
    //seven_seg s2(.in(sum), .seg(seg2));
endmodule

// correct one!
module full_adder(SW, LEDR);
	
	input [8:0] SW;
	output [9:0] LEDR;
	wire [3:0] a, b;
	wire Cin; 
	
	reg [3:0] sum;
	reg Cout;
	//output [6:0] seg0, seg1, seg2;
	 
	reg [2:0] co;
	 
	assign a = SW[3:0];
	assign b = SW[7:4];
	assign Cin = SW[8];
	 
	always@(a or b or Cin)
	begin
		 {co[0], sum[0]} = a[0] + b[0] + Cin;
		 {co[1], sum[1]} = a[1] + b[1] + co[0]; 
		 {co[2], sum[2]} = a[2] + b[2] + co[1]; 
		 {Cout, sum[3]} = a[3] + b[3] + co[2];
	end
	 
	assign LEDR[3:0] = sum;

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

module full_adder(
  input [8:0] SW,    // FPGA switches
  output [9:0] LEDR  // FPGA LEDs
);
  wire [3:0] A, B;
  wire Cin;
  wire [3:0] sum;
  wire Cout;
  wire [1:0] hex_sum, hex_A, hex_B;

  assign A = SW[3:0];
  assign B = SW[7:4];
  assign Cin = SW[8];

  assign sum = A + B + Cin;
  assign Cout = sum[4];

  assign hex_sum = sum[3:2];
  assign hex_A = A[3:2];
  assign hex_B = B[3:2];

  always @(*)
  begin
    case (hex_sum)
      2'b00: LEDR[5:4] = 4'b0011;
      2'b01: LEDR[5:4] = 4'b0001;
      2'b10: LEDR[5:4] = 4'b0101;
      2'b11: LEDR[5:4] = 4'b0111;
      default: LEDR[5:4] = 4'b1111;
    endcase

    case (hex_A)
      2'b00: LEDR[3:2] = 4'b0011;
      2'b01: LEDR[3:2] = 4'b0001;
      2'b10: LEDR[3:2] = 4'b0101;
      2'b11: LEDR[3:2] = 4'b0111;
      default: LEDR[3:2] = 4'b1111;
    endcase

    case (hex_B)
      2'b00: LEDR[1:0] = 4'b0011;
      2'b01: LEDR[1:0] = 4'b0001;
      2'b10: LEDR[1:0] = 4'b0101;
      2'b11: LEDR[1:0] = 4'b0111;
      default: LEDR[1:0] = 4'b1111;
    endcase

    if (A > 9 || B > 9)
      LEDR[9] = 1;
    else
      LEDR[9] = 0;
  end
endmodule

