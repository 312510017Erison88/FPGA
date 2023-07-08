module Counter(rst, en, clk, Q, HEX0, HEX1, HEX2, HEX3);
	input wire rst, en , clk;
	reg [3:0] Q1, Q2, Q3, Q4;
    output [6:0] HEX0, HEX1, HEX2, HEX3;

    assign rst = SW[0];
    assign en = SW[1];
    assign clk = KEY[0];
	
	// TFF
	always@ (posedge clk)
	begin
		if (rst)
			Q1 <= 4'b0000;
		else if(en)
			Q1 <= ~Q4;
        else 
            Q1 <= Q4;
	end

    always@ (posedge clk)
	begin
		if (rst)
			Q2 <= 4'b0000;
		else if(en)
			Q2 <= ~Q1;
        else 
            Q2 <= Q1;
	end

    always@ (posedge clk)
	begin
		if (rst)
			Q3 <= 4'b0000;
		else if(en)
			Q3 <= ~Q2;
        else 
            Q3 <= Q2;
	end

    always@ (posedge clk)
	begin
		if (rst)
			Q4 <= 4'b0000;
		else if(en)
			Q4 <= ~Q3;
        else 
            Q4 <= Q3;
	end

    BCD_to_seven_segment_1 out1 (Q1, HEX0);
    BCD_to_seven_segment_1 out2 (Q2, HEX1);
    BCD_to_seven_segment_1 out3 (Q3, HEX2);
    BCD_to_seven_segment_1 out4 (Q4, HEX3);
	
	
endmodule
