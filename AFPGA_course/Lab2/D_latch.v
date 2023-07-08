module D_latch(D, clk, Qa, Qb, Qc);
	input D, clk;
	output reg Qa, Qb, Qc;
	
	// D_latch
	always@ (D, clk)
	begin
		if (clk)
			Qa = D;
		else
			Qa = Qa;
	end
	
	// DFF positive
	always@ (posedge clk)
	begin 
		Qb <= D;
	end
	
	// DFF negative
	always@ (negedge clk)
	begin 
		Qc <= D;
	end
	
endmodule