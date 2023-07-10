module time_of_day_clock(
  input [9:0] SW,
  input CLOCK_50,
  input [1:0] KEY,      // KEY is reset
  output [6:0] HEX0,
  output [6:0] HEX1,
  output [6:0] HEX2,
  output [6:0] HEX3,
  output [6:0] HEX4,
  output [6:0] HEX5
);
	
	 wire CLK_1HZ, CLK_1000HZ;
    clk_divider clk_divider_uut0(CLOCK_50, CLK_1HZ);
    clk_divider clk_divider_uut1(CLOCK_50, CLK_1000HZ);
    defparam clk_divider_uut1.freq = 1000;

    wire SLOW_CLK;
    assign SLOW_CLK = (KEY[1]) ? CLK_1HZ : CLK_1000HZ;
	 
    // current_time
    reg [3:0] hour_1, hour_0, minute_1, minute_0, second_1, second_0;
    // user setting time
    reg [3:0] set_hour_1, set_hour_0, set_minute_1, set_minute_0, set_second_1, set_second_0;
    
    // determine the set_time condition
    always@ (posedge CLOCK_50) begin
        if(SW[9]) begin
            if(SW[3:0] <= 4'd9)
                set_hour_0 <= SW[3:0];
            else
                set_hour_0 <= 4'd0;
					 
            if((SW[7:4] <= 4'd1) && (SW[3:0] <= 4'd9)) begin
                set_hour_1 <= SW[7:4];
				end
				else if ((SW[7: 4] == 4'd2) && (SW[3: 0] <= 4'd3)) begin
                set_hour_1 <= SW[7: 4];
            end
            else begin
                set_hour_1 <= 4'd0;
				end
        end

        else begin
            if(SW[3:0] <= 4'd9)
                set_minute_0 <= SW[3:0];
            else
                set_minute_0 <= 4'd0;
            if((SW[7:4] <= 4'd5) && (SW[3:0] <= 4'd9))
                set_minute_1 <= SW[7:4];
            else
                set_minute_1 <= 4'd0;
        end
    end

    // set the value of next time
    // priority: reset > set > count
    wire reset;
    assign reset = !KEY[0];
    always@( posedge reset, posedge SW[8], posedge SLOW_CLK) begin
        if(reset)begin
            hour_1 <= 4'd0;
            hour_0 <= 4'd0;
            minute_1 <= 4'd0;
            minute_0 <= 4'd0;
            second_1 <= 4'd0;
            second_0 <= 4'd0;
        end
        else if(SW[8]) begin
            // user setting value
            if(SW[9]) begin
                hour_1 <= set_hour_1;
                hour_0 <= set_hour_0;
            end
            else begin
                minute_0 <= set_minute_0;
                minute_1 <= set_minute_1;
            end
        end
        else begin
            second_0 <= second_0 + 4'd1;
            if(second_0 > 4'd9) begin
                second_0 <= 4'd0;
                second_1 <= second_1 + 4'd1;
                if(second_1 > 4'd5) begin
                    second_1 <= 4'd0;
                    minute_0 <= minute_0 + 4'd1;
                    if(minute_0 > 4'd9) begin
                        minute_0 <= 4'd0;
                        minute_1 <= minute_1 + 4'd1;
                        if(minute_1 > 4'd5) begin
                            minute_1 <= 4'd0;
                            hour_0 <= hour_0 + 4'd1;
                            if(hour_0 > 4'd9) begin
                                hour_0 <= 4'd0;
                                hour_1 <= hour_1 + 4'd1;
                                if((hour_1 == 4'd2) && (hour_0 > 4'd3 )) begin
                                    hour_1 <= 4'd0;
                                end
                            end
                        end
                    end
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

/*
問問題
1. KEY是共楊極嗎
2. CLK那部份看不太懂 呼叫SLOW_CLK
3. 下面演匴法部分為什麼是==9
4. 
*/