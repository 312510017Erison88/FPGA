module processor(
    //input CLOCK_50,
    output wire [7:0] LEDR,
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
    wire M_clock, P_clock;
    reg [7:0] BusWires;
    reg [7:0] Rin, Rout;        // eight 8-bit register's input and output
    reg [7:0] Sum; 
    reg IRin, DINout, Ain, Gin, Gout, AddSub;
    //wire [1:0] Tstep_Q;         // 2 different time input
    wire [1:0] I;               // 2-bit instruction decode
    wire [7:0] Xreg, Yreg;
    reg [7:0] R0, R1, R2, R3, R4, R5, R6, R7, A, G;
    reg [7:0] IR;              // IIXXXYYY
    wire [7:0] Sel;            // choose which Buswires

    assign resetn = !KEY[0];
    assign M_clock = !KEY[1];
    assign P_clock = !KEY[2];
    assign LEDR[7:0] = BusWires[7:0];
    assign I = IR[7:6];

    //upcount Tstep(resetn, P_clock, Tstep_Q);        // T0-T3 four period
    dec3to8 decX1(IR[5:3], 1'b1, Xreg);             // choose R0-R7
    dec3to8 decX0(IR[2:0], 1'b1, Yreg);

    /*    
    指令列表：
    00：    mv
    01:     mvi
    10:     add
    11:     sub
    */

    // 5-bit read address
    wire [4:0] address;
    wire [7:0] DIN;
    rom myromfunction(.address(address), .clock(M_clock), .q(DIN));
    count_add mycount_add(resetn, M_clock, address); 
    //assign IR[7:0] = DIN[7:0];
   
    
    always@(posedge P_clock)
    begin
        // specify initial values
        Ain <= 1'b0;
        Gin <= 1'b0;
        Gout <= 1'b0;
        AddSub <= 1'b0;
        IRin <= 1'b0;
        DINout <= 1'b0;
        Rin[7:0] <= 8'b0;
        Rout[7:0] <= 8'b0;
        IR[7:0] <= DIN[7:0];

        case(I)
            2'b00:   // mv Rx,Ry
            begin
                Rout <= Yreg;
                Rin <= Xreg;
            end
            2'b01:    // mvi Rx,#D
            begin
                DINout <= 1'b1;
                Rin <= Xreg;
            end
            2'b10:    // add Rx,Ry
            begin
                Gin <= 1'b1;
                Ain <= 1'b1;
                Rout <= Yreg;
                Gout <= 1'b1;
                Rin <= Xreg;
            end
            2'b11:    // sub Rx, Ry
            begin 
                Gin <= 1'b1;
                Ain <= 1'b1;
                Rout <= Yreg;
                AddSub <= 1'b1;         //sub
                Gout <= 1'b1;
                Rin <= Xreg;
            end
            default: ;
        endcase

        // register banks
        R0 <= Rin[0] ? BusWires : R0;
        R1 <= Rin[1] ? BusWires : R1;
        R2 <= Rin[2] ? BusWires : R2;
        R3 <= Rin[3] ? BusWires : R3;
        R4 <= Rin[4] ? BusWires : R4;
        R5 <= Rin[5] ? BusWires : R5;
        R6 <= Rin[6] ? BusWires : R6;
        R7 <= Rin[7] ? BusWires : R7;
        A <= Ain ? BusWires : A;
        // ALU
        if(!AddSub)
            Sum = A + BusWires;
        else
            Sum = A - BusWires;
        G <= Gin ? Sum : G;
    end
    
    // define the bus
    assign Sel = {Rout, Gout, DINout};

    always@(*)
    begin
        if(Sel==10'b1000000000)
            BusWires = R0;
        else if(Sel==10'b0100000000)
            BusWires = R1;
        else if(Sel==10'b0010000000)
            BusWires = R2;
        else if(Sel==10'b0001000000)
            BusWires = R3;
        else if(Sel==10'b0000100000)
            BusWires = R4;
        else if(Sel==10'b0000010000)
            BusWires = R5;
        else if(Sel==10'b0000001000)
            BusWires = R6;
        else if(Sel==10'b0000000100)
            BusWires = R7;
        else if(Sel==10'b0000000010)
            BusWires = G;
        else                        
            BusWires = DIN;
    end

    // Display value of DIN
    HEX_to_seven_segment DIN1(DIN[7:4], HEX5);
    HEX_to_seven_segment DIN0(DIN[3:0], HEX4);
    // Display value of R0
    HEX_to_seven_segment R01(R0[7:4], HEX3);
    HEX_to_seven_segment R00(R0[3:0], HEX2);
    // Display value of R1
    HEX_to_seven_segment R11(R1[7:4], HEX1);
    HEX_to_seven_segment R10(R1[3:0], HEX0);

endmodule

/*
module upcount(clear, P_clock, Tstep_Q);
    input clear, P_clock;
    output reg [1:0] Tstep_Q;

    always@ (posedge P_clock)
        if(clear)
            Tstep_Q <= 2'b0;
        else
            Tstep_Q <= Tstep_Q + 1'b1;
endmodule
*/

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
                3'b001: Y = 8'b01000000;
                3'b010: Y = 8'b00100000;
                3'b011: Y = 8'b00010000;
                3'b100: Y = 8'b00001000;
                3'b101: Y = 8'b00000100;
                3'b110: Y = 8'b00000010;
                3'b111: Y = 8'b00000001;
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
    output reg [n-1:0] Q;

    always@ (posedge P_clock)
        if(Rin)
            Q <= R;
        else
            Q <= Q;
endmodule

module count_add(resetn, M_clock, Q);
    input resetn, M_clock;
    output reg [4:0] Q;

    always@ (posedge M_clock)
        if(resetn==0)
            Q <= 5'd0;
        else
            Q <= Q + 1'b1;
endmodule