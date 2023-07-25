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
    wire [1:0] Tstep_Q;         // 2 different time input
    wire [1:0] I;               // 2-bit instruction decode
    wire [7:0] Xreg, Yreg;
    wire [7:0] R0, R1, R2, R3, R4, R5, R6, R7, A, G;
    wire [7:0] IR;              // IIXXXYYY
    wire [7:0] Sel;            // choose which Buswires

    assign resetn = !KEY[0];
    assign M_clock = !KEY[1];
    assign P_clock = !KEY[2];
    assign LEDR[7:0] = BusWires[7:0];
    assign I = IR[7:6];

    upcount Tstep(resetn, P_clock, Tstep_Q);        // T0-T3 four period
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
    assign IR[7:0] = DIN[7:0];
   
    
    always@(Tstep_Q or I or Xreg or Yreg)
    begin
        // specify initial values
        Ain = 1'b0;
        Gin = 1'b0;
        Gout = 1'b0;
        AddSub = 1'b0;
        IRin = 1'b0;
        DINout = 1'b0;
        Rin = 8'b0;
        Rout = 8'b0;

        case(Tstep_Q)
            2'b00:    //store DIN in IR in time step 0
            begin
                IRin = 1'b1;
            end
            2'b01:    // define signals in time step 1
                case(I)
                    2'b00:    // mv Rx,Ry
                    begin
                        Rout = Yreg;
                        Rin = Xreg;
                    end
                    2'b01:    // mvi Rx,#D
                    begin
                        DINout = 1'b1;
                        Rin = Xreg;
                    end
                    2'b10,2'b11:    // add,sub
                    begin
                        Rout = Xreg;
                        Ain = 1'b1;
                    end
                    default: ;        
                endcase
            2'b10:    // define signals in time step 2
                case(I)
                    2'b10:    // add
                    begin
                        Rout = Yreg;
                        Gin = 1'b1;
                    end
                    2'b11:    // sub
                    begin
                        Rout = Yreg;
                        AddSub = 1'b1;
                        Gin = 1'b1;
                    end
                    default: ;    
                endcase
            2'b11:    // define signals in time step 3
                case(I)
                    2'b10,2'b11:    //add,sub
                    begin
                        Gout = 1'b1;
                        Rin = Xreg;
                    end
                    default: ;    
                endcase
        endcase
    end

    regn reg_0(BusWires, Rin[0], P_clock, R0); 
    regn reg_1(BusWires, Rin[1], P_clock, R1);
    regn reg_2(BusWires, Rin[2], P_clock, R2);
    regn reg_3(BusWires, Rin[3], P_clock, R3);
    regn reg_4(BusWires, Rin[4], P_clock, R4);
    regn reg_5(BusWires, Rin[5], P_clock, R5);
    regn reg_6(BusWires, Rin[6], P_clock, R6);
    regn reg_7(BusWires, Rin[7], P_clock, R7);
    regn reg_A(BusWires, Ain, P_clock , A);

    // alu
    always @(AddSub or A or BusWires)
    begin 
        if(!AddSub)
            Sum = A + BusWires;
        else
            Sum = A - BusWires;
    end
    
    regn reg_G(Sum, Gin, P_clock, G);

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


module upcount(clear, P_clock, Tstep_Q);
    input clear, P_clock;
    output reg [1:0] Tstep_Q;

    always@ (posedge P_clock)
        if(clear)
            Tstep_Q <= 2'b0;
        else
            Tstep_Q <= Tstep_Q + 1'b1;
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



