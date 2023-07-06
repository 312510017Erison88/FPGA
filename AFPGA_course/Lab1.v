module seven_seg(in, seg);
input [3:0] in;     // 輸入4_bit
output [6:0] seg;   // 輸出7_bit
reg [6:0] seg;   // 輸出7_bit
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
    // not sure
    if (A > 9 || B > 9)
      LEDR[9] = 1;
    else
      LEDR[9] = 0;
	end
	 
	assign LEDR[3:0] = SW;

    //seven_seg s0(.in(a), .seg(seg0));
    //seven_seg s1(.in(b), .seg(seg1));
    //seven_seg s2(.in(sum), .seg(seg2));

endmodule


// if-else一定要在always裡面!!
// always 給值一定要宣告reg 
// 在always 裡面 ex:if-else只要超過一行 都要加 begin end
