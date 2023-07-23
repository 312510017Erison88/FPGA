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
    //wire Run;
    //reg Done;
    wire resetn;
    reg [7:0] BusWires;

    assign DIN [7:0] = SW[7:0];
    assign Run = SW[9];
    assign LEDR[9] = Done;
    assign resetn = !KEY[0];
    assign M_clock = !KEY[1];
    assign P_clock = !KEY[2];
    
    reg I [1:0];
    reg IR [7:0];
    reg Xreg [7:0];
    reg Yreg [7:0];

    upcount Tstep(resetn, CLOCK_50, Tstep_Q);
    assign I = IR[1:0];
    dec3to8 decX1(IR[4:2], 1'b1, Xreg);
    dec3to8 decX0(IR[7:5], 1'b1, Yreg);

    always@(I, Xreg, Yreg)
    begin
        case(I)
            2'b00:                  // Ry are loaded into Rx
                BusWires <= Yreg;
            2'b01:                  // constant Din out is loaded in to Rx
                BusWires <= Din;
            2'b10:                  // Rx add Ry result is loaded in to Rx
                BusWires <= Xreg + Yreg;    // Add Xreg and Yreg and store the result in Rx
            2'b11:                  // Rx substrate Ry result is loaded in to Rx
                BusWires <= Xreg - Yreg;    // Substrate Yreg from Xreg and store the result in Rx
        endcase
    end

    always@ (P_clock, resetn)
        if(resetn) begin
            Xreg <= 8'd0;
            Yreg <= 8'd0;
            BusWires <= 8'd0;
            IR <= 8'd0;
        end
        else begin

        end

    always@ (M_clock)



    regn reg_0(BusWires, Rin[0], CLOCK_50, R0); // Rin is not defined
    // ... instantiate other registers and the adder/substactor unit
    // ... define the bus

    // Display value of DIN
    HEX_to_seven_segment DIN1(DIN[7:4], HEX5);
    HEX_to_seven_segment DIN0(DIN[3:0], HEX4);
    // Display value of Rx
    HEX_to_seven_segment RX1(BusWires[7:4], HEX3);
    HEX_to_seven_segment Rx0(BusWires[3:0], HEX2);

    // Display value of Ry
    HEX_to_seven_segment Ry1(Yreg[7:4], HEX1);
    HEX_to_seven_segment Ry0(Yreg[3:0], HEX0);

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
