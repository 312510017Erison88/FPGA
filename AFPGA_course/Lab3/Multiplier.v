module multiplier(
  input [9:0] SW,
  input [3:0] KEY,      // KEY is reset
  output reg [9:9] LEDR,
  output [6:0] HEX0,
  output [6:0] HEX1,
  output [6:0] HEX2,
  output [6:0] HEX3
);
	 
    reg [7:0] a, b, c, d;
    reg [15:0] sum;
	reg Cout;
    
    // use register to store pre_SW[9] status
    // important!!
    wire enable;
    assign enable = SW[9];

    wire reset, CLK;
	assign reset = !KEY[0];
    assign CLK = !KEY[1];
    // priority: reset > write enable > SW[8] > KEY[2] (Clock)
    always@ (posedge reset or posedge CLK) begin
        // reset
        if (reset) begin
            a <= 8'd0;
            b <= 8'd0;
            c <= 8'd0;
            d <= 8'd0;
            sum <= 16'd0;
            Cout <= 1'd0;
            LEDR[9] <= 0;
        end
        else begin
            if(enable) begin
                if(SW[8]) begin     // set a or b
                    if(!KEY[2]) begin
                        a <= SW[7:0];
                    end
                    else begin
                        b <= SW[7:0];
                    end
                end
                else begin              // set c or d
                    if(!KEY[2]) begin
                        c <= SW[7:0];
                    end
                    else begin
                        d <= SW[7:0];
                    end
                end
            end
            else begin
                {Cout, sum} <= (a * b) + (c * d);
                LEDR[9] <= Cout;
            end
        end
    end

    reg [7:0] a_or_c, b_or_d;

    always@ (*) begin
        if(KEY[3]) begin
            if(SW[8]) begin
                a_or_c = a;
                b_or_d = b;
            end
            else begin
                a_or_c = c;
                b_or_d = d;
            end
        end
        else begin                  // To display the sum
            a_or_c = sum[15:8];
            b_or_d = sum[7:0];
        end
    end

    // Display a or c on HEX3 and HEX2
    HEX_to_seven_segment display_HEX3(a_or_c[7:4], HEX3);
	HEX_to_seven_segment display_HEX2(a_or_c[3:0], HEX2);
   
    // Display b or d on HEX1 and HEX0
    HEX_to_seven_segment display_HEX1(b_or_d[7:4], HEX1);
	HEX_to_seven_segment display_HEX0(b_or_d[3:0], HEX0);

endmodule