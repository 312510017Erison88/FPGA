module processor(
    //input CLOCK_50,
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
    wire resetn;
    reg [7:0] BusWires;
    wire M_clock, P_clock;
    wire [7:0] DIN;

    assign resetn = !KEY[0];
    assign M_clock = !KEY[1];
    assign P_clock = !KEY[2];
    
    // 5-bit read address
    reg [4:0] address;
    reg [7:0] dara;

    upcount counter(resetn, M_clock, address);
    rom myromfunction(.address(address), .clock(M_clock), .q(data)); 
    assign DIN[7:0] = data[7:0];
    //rom myromfunction(.address(DIN), .clock(P_clock), .q(BusWires)); 

    // declare processor parameter
    reg I [1:0];
    reg IR [7:0];
    reg Xreg [7:0];
    reg Yreg [7:0];

    assign I = IR[1:0];
    dec3to8 decX1(IR[4:2], 1'b1, Xreg);
    dec3to8 decX0(IR[7:5], 1'b1, Yreg);

/*
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
*/

    always@ (P_clock, resetn)
        if(resetn) begin
            Xreg <= 8'd0;
            Yreg <= 8'd0;
            BusWires <= 8'd0;
            IR <= 8'd0;
        end
        else begin
            case(I)
            2'b00:                  // Ry are loaded into Rx
                BusWires <= Yreg;
            2'b01:                  // constant Din out is loaded in to Rx
                BusWires <= DIN;
            2'b10:                  // Rx add Ry result is loaded in to Rx
                BusWires <= Xreg + Yreg;    // Add Xreg and Yreg and store the result in Rx
            2'b11:                  // Rx substrate Ry result is loaded in to Rx
                BusWires <= Xreg - Yreg;    // Substrate Yreg from Xreg and store the result in Rx
            endcase
        end


    regn reg_0(BusWires, Rin[0], P_clock, R0); // parameter is wierd!
    // ... instantiate other registers and the adder/substactor unit
    // ... define the bus

    // Display value of DIN
    HEX_to_seven_segment DIN1(DIN[7:4], HEX5);
    HEX_to_seven_segment DIN0(DIN[3:0], HEX4);
    // Display value of R0
    HEX_to_seven_segment RX1(data[7:4], HEX3);
    HEX_to_seven_segment Rx0(data[3:0], HEX2);
    // Display value of R1
    HEX_to_seven_segment Ry1(BusWires[7:4], HEX1);
    HEX_to_seven_segment Ry0(BusWires[3:0], HEX0);

endmodule


module upcount(clear, M_clock, Q);
    input clear, M_clock;
    output reg [4:0] Q;

    always@ (posedge M_clock)
        if(clear)
            Q <= 5'd0;
        else
            Q <= Q + 5'd1;
endmodule

// En is original from Tstep
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


module regn(R, Rin, P_clock, Q);
    parameter n = 8;
    input [n-1:0] R;
    input Rin, P_clock;
    output reg[n-1:0] Q;

    always@ (posedge P_clock)
        if(Rin)
            Q <= R;
        else
            Q <= Q;
endmodule



