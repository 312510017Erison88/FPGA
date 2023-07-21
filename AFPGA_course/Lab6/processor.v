module processor(
    input [9:0] SW,
    input CLOCK_50,
    output wire [9:0] LEDR,
    input [2:0] KEY,      
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5
);
    // declare variables
    wire [7:0] DIN;
    wire Run;
    reg Done;
    wire resetn;
    reg [7:0] BusWires;

    assign DIN [7:0] = SW[7:0];
    assign Run = SW[9];
    assign LEDR[9] = Done;
    assign resetn = !KEY[0];
    assign M_clock = !KEY[1];
    assign P_clock = !KEY[2];
    
    reg Tstep_Q [1:0];
    reg I [1:0];
    wire IR [7:0];
    reg Xreg [7:0];
    reg Yreg [7:0];

    upcount Tstep(resetn, CLOCK_50, Tstep_Q);
    assign I = IR[1:0];
    dec3to8 decX(IR[4:2], 1'b1, Xreg);
    dec3to8 decX(IR[7:5], 1'b1, Yreg);

    always@(Tstep_Q, I, Xreg, Yreg)
    begin
    // specify initail value

        case(Tstep_Q)
            2'b00:      // store DIN in IR in time step0
            begin 
                IRin = 1'b1;
            end
            2'b01:      // define signals in time step1
            case(I)

            endcase
            2'b10:      // define signals in time step2
            case(I) 

            endcase
            2'b11:      // define signals in time step3
            case(I)

            endcase
        endcase
    end

    regn reg_0(BusWires, Rin[0], CLOCK_50, R0);
    // ... instantiate other registers and the adder/substactor unit
    // ... define the bus

endmodule

module upcount(clear, CLOCK_50, Q);
    input clear, CLOCK_50;
    output reg [1:0] Q;

    // 除頻
	wire CLK_1HZ;
    clk_divider clk_1HZ(CLOCK_50, CLK_1HZ);

    always@ (posedge CLK_1HZ)
        if(clear)
            Q <= 2'b00;
        else
            Q <= Q + 2'b01;
endmodule


module dec3to8(W, En, Y);
    input [2:0] W;
    input En;
    output reg [7:0] Y;

    always@ (W or En) 
    begin 
        if(En == 1'b1) begin
            case(W)
                3'b000: Y = 8'b10000000;
                3'b000: Y = 8'b01000000;
                3'b000: Y = 8'b00100000;
                3'b000: Y = 8'b00010000;
                3'b000: Y = 8'b00001000;
                3'b000: Y = 8'b00000100;
                3'b000: Y = 8'b00000010;
                3'b000: Y = 8'b00000001;
            endcase
        end
        else
            Y = 8'b00000000;
    end
endmodule

module regn(R, Rin, CLOCK_50, Q);
    parameter n = 8;
    input [n-1:0] R;
    input Rin, CLOCK_50;
    output reg[n-1:0] Q;

    always@ (posedge CLOCK_50)
        if(Rin)
            Q <= R;
        else
            Q <= Q;
endmodule
