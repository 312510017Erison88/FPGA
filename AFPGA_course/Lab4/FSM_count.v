// chatgpt vision
module counter(
  input [2:0] SW,
  input [0:0] KEY,      // KEY is CLOCK
  output [6:0] HEX[0],
);
    
    wire reset;
    assign reset = !SW[0];
    
    input [1:0] w,
    input manual_clock,
    output reg [3:0] count
    reg [2:0] state;
    reg [1:0] next_state;

    always @(posedge clk) begin
    if (reset)
        state <= 0;
    else
        state <= next_state;
    end

    always @(state, w, manual_clock) begin
    case (state)
        3'b000: begin
        next_state = (w == 2'b00) ? 3'b000 : 3'b001;
        end
        3'b001: begin
        next_state = (w == 2'b00) ? 3'b001 : 3'b010;
        end
        3'b010: begin
        next_state = (w == 2'b00) ? 3'b010 : 3'b011;
        end
        3'b011: begin
        next_state = (w == 2'b00) ? 3'b011 : 3'b000;
        end
    endcase
    end

    always @(posedge manual_clock) begin
    if (state == 3'b011)
        count <= (count == 4'b1001) ? 4'b0000 : count + 1;
    else if (state == 3'b010)
        count <= (count == 4'b1000) ? 4'b0000 : count + 2;
    else if (state == 3'b001)
        count <= (count == 4'b0000) ? 4'b1001 : count - 1;
    end

endmodule
