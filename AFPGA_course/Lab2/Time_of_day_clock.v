module time_of_day_clock(
  input [9:0] SW,
  output reg [6:0] HEX0,
  output reg [6:0] HEX1,
  output reg [6:0] HEX2,
  output reg [6:0] HEX3,
  output reg [6:0] HEX4,
  output reg [6:0] HEX5
);

  reg [3:0] hours;
  reg [5:0] minutes;
  reg [5:0] seconds;
  reg [3:0] display_hours;
  reg [5:0] display_minutes;
  reg [5:0] display_seconds;

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

  always @(hours, minutes, seconds)
  begin
    // Display hours on HEX5 and HEX4
    display_hours[3:0] = hours;
    if (hours > 9)
      display_hours[6] = 1;
    else
      display_hours[6] = 0;
    HEX5 = display_hours;

    // Display minutes on HEX3 and HEX2
    display_minutes[5:0] = minutes;
    if (minutes > 9)
      display_minutes[6] = 1;
    else
      display_minutes[6] = 0;
    HEX3 = display_minutes;

    // Display seconds on HEX1 and HEX0
    display_seconds[5:0] = seconds;
    if (seconds > 9)
      display_seconds[6] = 1;
    else
      display_seconds[6] = 0;
    HEX1 = display_seconds;
  end

endmodule