module processor(DIN, Restn, Run, Done, BusWires);
    input [7:0] DIN;
    input Restn, CLOCK_50, Run;
    output Done;
    output [7:0] BusWires;

    // ... declare variables
    wire clear = 
    upcount Tstep(Clear, CLOCK_50, Tstep_Q)
    assign I = IR[1:2];
    dec3to8 decX(IR[3:5], 1'b1, Xreg);
    dec3to8 decX(IR[6:8], 1'b1, Yreg);

    always@(Tstep_Q, I, Xreg, Yreg)
    begin
    // specify initail value
        case(Tstep_Q)
            2'b00:
            begin 
                IRin = 1'b1;
            end
            2'b01:
            case 

            endcase
            2'b10:
            case 

            endcase
            2'b11:
            case 

            endcase
        endcase
    end

    regn reg_0(BusWires, Rin[0], Clock, R0);
    // ... instantiate other registers and the adder/substactor unit
    // ... define the bus

endmodule

module upcount(clear, CLOCK_50, Q);
    input clear, CLOCK_50;
    output reg [1:0] Q;
    always@ (posedge CLOCK_50)
        if(clear)
            Q <= 2'b00;
        else
            Q <= Q + 2'b01;
endmodule

module dec3to8(W, En, Y);
    input [2:0] W;
    input En;
    output reg [0:7] Y;

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
            Y = Y = 8'b00000000;
    end
endmodule
