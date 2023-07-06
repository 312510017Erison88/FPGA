module full_adder(SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	input [8:0] SW;
	output reg [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	reg [3:0] s_out0, s_out1;
	wire [3:0] a, b;
	wire Cin; 
	
	reg [3:0] sum;
	reg Cout;
	reg [2:0] co;
	reg [4:0] temp;
	 
	assign a = SW[7:4];
	assign b = SW[3:0];
	assign Cin = SW[8];
	 
	always@(a or b or Cin)
	begin
		 {co[0], sum[0]} = a[0] + b[0] + Cin;
		 {co[1], sum[1]} = a[1] + b[1] + co[0]; 
		 {co[2], sum[2]} = a[2] + b[2] + co[1]; 
		 {Cout, sum[3]} = a[3] + b[3] + co[2];
		 temp = {Cout, sum};
	end
	 
	//assign LEDR[8:0] = SW;
	
	BCD_to_seven_segment a1 (a, HEX2);
	BCD_to_seven_segment a2 (10, HEX3);
	BCD_to_seven_segment b1 (b, HEX0);
	BCD_to_seven_segment b2 (10, HEX1);
	BCD_to_seven_segment sum1 (s_out0, HEX4);
	BCD_to_seven_segment sum2 (s_out1, HEX5);
	
	always@(*)
	begin
		if(temp <= 9)begin
			s_out1 = 0;
			s_out0 = sum;
		end
		
		else begin
			s_out1 = 1;
			s_out0 = sum + 6;
		end
	end
	 
	 always@(*)
	 begin
		 if (a > 9 || b > 9)
			LEDR[9] = 1;
		 else
			LEDR[9] = 0;
	 end
	 
endmodule

// reminder
// if-else一定要在always裡面!!
// always 給值一定要宣告reg 
// 在always 裡面 ex:if-else只要超過一行 都要加 begin end
