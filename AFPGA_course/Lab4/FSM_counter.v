module FSM_counter(
  input [2:0] SW,
  input [0:0] KEY,      // KEY is CLOCK
  output [6:0] HEX[0],
);
    // reset
    wire reset;
    assign reset = !SW[0];

    // Clock
    wire CLK;
    assign CLK = !KEY[0];
    
    // input condition 
    wire [1:0] in,
    assign in = {SW[2], SW[1]};

    // state name
    parameter [1:0] Add_one = 2'b00,
                    Add_two = 2'b01,
                    Sub_one = 2'b10,
                    No_change = 2'b11;
    
    reg [3:0] count
    reg [1:0] cur_state;
    reg [1:0] next_state;

    // current state machine
    always @(posedge CLK) begin
    if(reset)
        cur_state <= 0;
    else
        cur_state <= next_state;
    end

    // sub-state machine
    always @(cur_state, w, CLK) begin   // CLK can take off ?
    case (cur_state)
        Add_one: begin
        if(w == Add_one)
            next_state <= Add_one;
        else if(w == Add_two)
            next_state <= Add_two;
        else if(w == Sub_one)
            next_state <= Sub_one;
        else
            next_state <= No_change;
        end
        Add_two: begin
        if(w == Add_one)
            next_state <= Add_one;
        else if(w == Add_two)
            next_state <= Add_two;
        else if(w == Sub_one)
            next_state <= Sub_one;
        else
            next_state <= No_change;
        end
        Sub_one: begin
        if(w == Add_one)
            next_state <= Add_one;
        else if(w == Add_two)
            next_state <= Add_two;
        else if(w == Sub_one)
            next_state <= Sub_one;
        else
            next_state <= No_change;
        end
        No_change: begin
        if(w == Add_one)
            next_state <= Add_one;
        else if(w == Add_two)
            next_state <= Add_two;
        else if(w == Sub_one)
            next_state <= Sub_one;
        else
            next_state <= No_change;
        end
    endcase
    end

    // output logic
    always @(posedge CLK) begin
    if (cur_state == Add_one)
        count <= (count == 4'b1001) ? 4'b0000 : count + 1;
    else if (cur_state == Add_two)
        count <= (count == 4'b1000) ? 4'b0000 : count + 2;
    else if (cur_state == Sub_one)
        count <= (count == 4'b0000) ? 4'b1001 : count - 1;
    else
        count <= count;
    end

    // display on HEX0
    BCD_to_seven_segment(count, HEX0);

endmodule
