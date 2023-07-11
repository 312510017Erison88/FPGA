module multiplier(
  input [9:0] SW,
  input [3:0] KEY,      // KEY is reset
  output reg [9:0] LEDR,
  output [6:0] HEX0,
  output [6:0] HEX1,
  output [6:0] HEX2,
  output [6:0] HEX3,
  output [6:0] HEX4,
  output [6:0] HEX5
);
	 
    reg [7:0] a, b, c, d;
    reg [15:0] sum;
	reg Cout;
    
    // use register to store pre_SW[9] status
    // important!!
    wire set_value;
    reg pre_SW9;
    always@ (KEY[1]) begin
        pre_SW9 <= SW[9];
    end
    assign set_value = ((!pre_SW9) && (SW[9]));

    wire reset;
	assign reset = !KEY[0];
    // priority: reset > write enable > SW[8] > KEY[2] (Clock)
    always@ (reset, !KEY[1], set_value) begin
        // reset
        if (reset) begin
            a <= 8'd0;
            b <= 8'd0;
            c <= 8'd0;
            d <= 8'd0;
            LEDR[9] <= 0;
        end
        else begin
            if(set_value) begin
                if(SW[8]) begin
                    if(!KEY[2]) begin
                        b <= SW[7:0];
                    end
                    else begin
                        a <= SW[7:0];
                    end
                end
                else begin
                    if(!KEY[2]) begin
                        d <= SW[7:0];
                    end
                    else begin
                        c <= SW[7:0];
                    end
                end
            end
            else begin
                {Cout, sum} = a * b + c * d;
                LEDR[9] <= Cout;
            end
        end
    end

    reg [7:0] a_or_c, b_or_d;

    always@ (*) begin
        if(!KEY[3]) begin
            if(SW[8]) begin
                a_or_c <= a;
                b_or_d <= b;
            end
            else begin
                a_or_c <= c;
                b_or_d <= d;
            end
        end
        else begin
            a_or_c <= sum[15:8];
            b_or_d <= sum[7:0];
        end
    end

    // Display a or c on HEX3 and HEX2
    BCD_to_seven_segment display_HEX3(a_or_c[7:4], HEX3);
	BCD_to_seven_segment display_HEX2(a_or_c[3:0], HEX2);
   
    // Display b or d on HEX1 and HEX0
    BCD_to_seven_segment display_HEX1(b_or_d[7:4], HEX1);
	BCD_to_seven_segment display_HEX0(b_or_d[3:0], HEX0);

endmodule