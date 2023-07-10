module time_of_day_clock(
  input [9:0] SW,
  input [3:0] KEY,      // KEY is reset
  output reg [9:0] LEDR;
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
    always@ (KEY[0]) begin
        pre_SW9 <= SW[9];
    end
    assign set_value = ((!pre_SW9)&&(SW[9]));

    wire reset;
	assign reset = !KEY[0];
    // priority: reset > write enable > SW[8] > KEY2
    always@ (*) begin
        // reset
        if (reset) begin
            a <= 8'd0;
            b <= 8'd0;
            c <= 8'd0;
            d <= 8'd0;
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
                {Cout, sum} = a*b + c*d;
                if(Cout) begin
                    LEDR[9] = 1;
                end
                else begin
                    LEDR[9] = 0;
                end
            end
        end
    end
    
    
    

    // Display hours on HEX5 and HEX4
    BCD_to_seven_segment display_hour_1(hour_1, HEX5);
    BCD_to_seven_segment display_hour_0(hour_0, HEX4);
    // Display minutes on HEX3 and HEX2
    BCD_to_seven_segment display_minute_1(minute_1, HEX3);
    BCD_to_seven_segment display_minute_0(minute_0, HEX2);
    // Display seconds on HEX1 and HEX0
    BCD_to_seven_segment display_second_1(second_1, HEX1);
    BCD_to_seven_segment display_second_0(second_0, HEX0);
endmodule