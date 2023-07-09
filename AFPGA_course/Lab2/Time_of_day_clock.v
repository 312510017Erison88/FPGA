module time_of_day_clock(
  input [9:0] SW,
  input clk,
  input [1:0] KEY,        // KEY is reset
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
  reg [3:0] temp_hours_1;
  reg [3:0] temp_hours_0;
  reg [3:0] temp_minutes_1;
  reg [3:0] temp_minutes_0;
  reg [3:0] temp_seconds_1;
  reg [3:0] temp_seconds_0;

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


  always @(hours)
    begin
      temp_hours_1 = hours / 10;
      temp_hours_2 = hours % 10;
    end
    
    always @(minutes)
    begin
      temp_minutes_1 = minutes / 10;
      temp_minutes_2 = minutes % 10;
    end
    
    always @(seconds)
    begin
      temp_seconds_1 = seconds / 10;
      temp_seconds_2 = seconds % 10;
    end

  // Display hours on HEX5 and HEX4
  BCD_to_seven_segment_1 display_hour_1(temp_hours_1, HEX5);
  BCD_to_seven_segment_1 display_hour_0(temp_hours_0, HEX4);
  // Display minutes on HEX3 and HEX2
  BCD_to_seven_segment_1 display_minute_1(temp_minutes_1, HEX2);
  BCD_to_seven_segment_1 display_minute_0(temp_minutes_0, HEX2);
  // Display seconds on HEX1 and HEX0
  BCD_to_seven_segment_1 display_second_1(temp_seconds_1, HEX1);
  BCD_to_seven_segment_1 display_second_0(temp_seconds_0, HEX0);

endmodule




// call module(實例化)要放在always外面 
// 在同一個always下 temp_hours那些數值不能同時附值