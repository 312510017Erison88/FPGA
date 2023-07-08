module time_of_day_clock(
  input [9:0] SW,
  input clk;
  output reg [6:0] HEX0,
  output reg [6:0] HEX1,
  output reg [6:0] HEX2,
  output reg [6:0] HEX3,
  output reg [6:0] HEX4,
  output reg [6:0] HEX5
);

  reg [5:0] hours;
  reg [5:0] minutes;
  reg [5:0] seconds;
  // reg [3:0] display_hours;
  // reg [5:0] display_minutes;
  // reg [5:0] display_seconds;

  always@(posedge SW[8])
  begin
    if(SW[9] == 1) // Setting the hour
      hours <= SW[7:0];
    else // Setting the minute
      minutes <= SW[7:0];
  end

  always@(posedge clk)
  begin
    // Increment seconds
    if(seconds < 60)
      seconds <= seconds + 1;
    else // Reset seconds and increment minutes
    begin
      seconds <= 0;
      if (minutes < 60)
        minutes <= minutes + 1;
      else // Reset minutes and increment hours
      begin
        minutes <= 0;
        if (hours < 24)
          hours <= hours + 1;
        else // Reset hours
          hours <= 0;
      end
    end
  end

  always@(hours, minutes, seconds)
  begin
    // Display hours on HEX5 and HEX4
    BCD_to_seven_segment_1 display_hours (hours, HEX4, HEX5);

    // Display minutes on HEX3 and HEX2
    BCD_to_seven_segment_1 display_minutes (minutes, HEX3, HEX2);

    // Display seconds on HEX1 and HEX0
    BCD_to_seven_segment_1 display_seconds (seconds, HEX1, HEX0);
  end

endmodule


module BCD_to_seven_segment_1(in, seg1, seg0);
input [5:0] in;
output reg [6:0] seg1, seg0;
always@(in)
    case(in)
      0: seg0 = 7'b1000000, seg1 = 7'b1111111;    // 0
      1: seg0 = 7'b1111001, seg1 = 7'b1111111;    // 1
      2: seg0 = 7'b0100100, seg1 = 7'b1111111;    // 2
      3: seg0 = 7'b0110000, seg1 = 7'b1111111;    // 3
      4: seg0 = 7'b0011001, seg1 = 7'b1111111;    // 4
      5: seg0 = 7'b0010010, seg1 = 7'b1111111;    // 5
      6: seg0 = 7'b0000010, seg1 = 7'b1111111;    // 6
      7: seg0 = 7'b1111000, seg1 = 7'b1111111;    // 7
      8: seg0 = 7'b0000000, seg1 = 7'b1111111;    // 8
      9: seg0 = 7'b0010000, seg1 = 7'b1111111;    // 9
      10: seg0 = 7'b1000000, seg1 = 7'b1111001;    // 0
      11: seg0 = 7'b1111001, seg1 = 7'b1111001;    // 1
      12: seg0 = 7'b0100100, seg1 = 7'b1111001;    // 2
      13: seg0 = 7'b0110000, seg1 = 7'b1111001;    // 3
      14: seg0 = 7'b0011001, seg1 = 7'b1111001;    // 4
      15: seg0 = 7'b0010010, seg1 = 7'b1111001;    // 5
      16: seg0 = 7'b0000010, seg1 = 7'b1111001;    // 6
      17: seg0 = 7'b1111000, seg1 = 7'b1111001;    // 7
      18: seg0 = 7'b0000000, seg1 = 7'b1111001;    // 8
      19: seg0 = 7'b0010000, seg1 = 7'b1111001;    // 9
      20: seg0 = 7'b1000000, seg1 = 7'b0100100;    // 0
      21: seg0 = 7'b1111001, seg1 = 7'b0100100;    // 1
      22: seg0 = 7'b0100100, seg1 = 7'b0100100;    // 2
      23: seg0 = 7'b0110000, seg1 = 7'b0100100;    // 3
      24: seg0 = 7'b0011001, seg1 = 7'b0100100;    // 4
      25: seg0 = 7'b0010010, seg1 = 7'b0100100;    // 5
      26: seg0 = 7'b0000010, seg1 = 7'b0100100;    // 6
      27: seg0 = 7'b1111000, seg1 = 7'b0100100;    // 7
      28: seg0 = 7'b0000000, seg1 = 7'b0100100;    // 8
      29: seg0 = 7'b0010000, seg1 = 7'b0100100;    // 9
      30: seg0 = 7'b1000000, seg1 = 7'b0110000;    // 0
      31: seg0 = 7'b1111001, seg1 = 7'b0110000;    // 1
      32: seg0 = 7'b0100100, seg1 = 7'b0110000;    // 2
      33: seg0 = 7'b0110000, seg1 = 7'b0110000;    // 3
      34: seg0 = 7'b0011001, seg1 = 7'b0110000;    // 4
      35: seg0 = 7'b0010010, seg1 = 7'b0110000;    // 5
      36: seg0 = 7'b0000010, seg1 = 7'b0110000;    // 6
      37: seg0 = 7'b1111000, seg1 = 7'b0110000;    // 7
      38: seg0 = 7'b0000000, seg1 = 7'b0110000;    // 8
      39: seg0 = 7'b0010000, seg1 = 7'b0110000;    // 9
      40: seg0 = 7'b1000000, seg1 = 7'b0011001;    // 0
      41: seg0 = 7'b1111001, seg1 = 7'b0011001;    // 1
      42: seg0 = 7'b0100100, seg1 = 7'b0011001;    // 2
      43: seg0 = 7'b0110000, seg1 = 7'b0011001;    // 3
      44: seg0 = 7'b0011001, seg1 = 7'b0011001;    // 4
      45: seg0 = 7'b0010010, seg1 = 7'b0011001;    // 5
      46: seg0 = 7'b0000010, seg1 = 7'b0011001;    // 6
      47: seg0 = 7'b1111000, seg1 = 7'b0011001;    // 7
      48: seg0 = 7'b0000000, seg1 = 7'b0011001;    // 8
      49: seg0 = 7'b0010000, seg1 = 7'b0011001;    // 9
      50: seg0 = 7'b1000000, seg1 = 7'b0010010;    // 0
      51: seg0 = 7'b1111001, seg1 = 7'b0010010;    // 1
      52: seg0 = 7'b0100100, seg1 = 7'b0010010;    // 2
      53: seg0 = 7'b0110000, seg1 = 7'b0010010;    // 3
      54: seg0 = 7'b0011001, seg1 = 7'b0010010;    // 4
      55: seg0 = 7'b0010010, seg1 = 7'b0010010;    // 5
      56: seg0 = 7'b0000010, seg1 = 7'b0010010;    // 6
      57: seg0 = 7'b1111000, seg1 = 7'b0010010;    // 7
      58: seg0 = 7'b0000000, seg1 = 7'b0010010;    // 8
      59: seg0 = 7'b0010000, seg1 = 7'b0010010;    // 9
      default: seg0 = 7'b1111111, seg1 = 7'b1111111;    // blank
    endcase
endmodule 