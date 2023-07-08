module multiplexer2_1(SW, LEDR);

	input [8:0] SW;
	output wire [3:0] LEDR;
	wire [3:0] X, Y;
	wire [3:0] result;
	
    assign X = SW[3:0];
	assign Y = SW[7:4];
	assign sel = SW[8];

    assign result = (~sel & X) | (sel & Y);
	assign LEDR[3:0] = result[3:0];
	
endmodule