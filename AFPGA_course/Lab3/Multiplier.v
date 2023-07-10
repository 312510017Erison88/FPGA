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
    always@ (reset, negedge KEY[1]) begin
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

    reg [7:0] temp_a, temp_b, temp_c, temp_d;
    reg [15:0] temp_sum;

    always@ (*) begin
        if(!KEY[3]) begin
            if(SW[8]) begin
                temp_a <= a;
                temp_b <= b;
                temp_c <= 8'd0;
                temp_d <= 8'd0;
            end
            else begin
                temp_a <= 8'd0;
                temp_b <= 8'd0;
                temp_c <= c;
                temp_d <= d;
            end
        end
        else begin
            temp_sum <= sum;
            temp_a <= 8'd0;
            temp_b <= 8'd0;
            temp_c <= 8'd0;
            temp_d <= 8'd0;
        end
    end


    // Display a or c on HEX3 and HEX2
    BCD_to_seven_segment display_a1(temp_a[7:4], HEX3);
	BCD_to_seven_segment display_a0(temp_a[3:0], HEX2);
    BCD_to_seven_segment display_c1(temp_c[7:4], HEX3);
	BCD_to_seven_segment display_c0(temp_c[3:0], HEX2);
    // Display b or d on HEX1 and HEX0
    BCD_to_seven_segment display_b1(temp_b[7:4], HEX1);
	BCD_to_seven_segment display_b0(temp_b[3:0], HEX0);
    BCD_to_seven_segment display_d1(temp_b[7:4], HEX1);
	BCD_to_seven_segment display_d0(temp_b[3:0], HEX0);

    // Display sum on HEX3~HEX0
    BCD_to_seven_segment display_sum3(temp_sum[15:12], HEX3);
    BCD_to_seven_segment display_sum2(temp_sum[11:8], HEX2);
    BCD_to_seven_segment display_sum1(temp_sum[7:4], HEX1);
    BCD_to_seven_segment display_sum0(temp_sum[3:0], HEX0);

endmodule