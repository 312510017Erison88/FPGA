module FSM_counter(
  input [2:0] SW,
  input [0:0] KEY,      // KEY is CLOCK
  output [6:0] HEX0
);
    // reset
    wire reset;
    assign reset = !SW[0];

    // Clock
    wire CLK;
    assign CLK = !KEY[0];
    
    // input condition 
    wire [1:0] in;
    assign in = {SW[2], SW[1]};

    // state name
    parameter [1:0] No_change = 2'b00,
                    Add_one = 2'b01,
                    Add_two = 2'b10,
                    Sub_one = 2'b11;
    
    reg [3:0] count;
   
    // current state machine
    always @(posedge CLK or posedge reset) begin
        if(reset) begin
            count <= 4'd0;
        end
        else begin
            // output logic
            case (in)
            Add_one:
                count <= (count == 4'b1001) ? 4'b0000 : count + 1;
            Add_two: begin
                if (count == 4'd8)
                    count <= 4'd0;
                else if (count == 4'd9)
                    count <= 4'd1;
                else 
                    count <= count + 2;
                end
            Sub_one:
                count <= (count == 4'b0000) ? 4'b1001 : count - 1;
            default:
                count <= count;
        endcase
        end
    end

    // display on HEX0
    BCD_to_seven_segment(count, HEX0);

endmodule