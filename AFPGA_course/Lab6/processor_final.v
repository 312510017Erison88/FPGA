module processor(
    input [2:0] KEY, 
    output [7:0] LEDR, 
    output [6:0]HEX5,
    output [6:0]HEX4, 
    output [6:0]HEX3, 
    output [6:0]HEX2, 
    output [6:0]HEX1,
    output [6:0]HEX0  
    );
    
    wire P_clock, M_clock, reset;
    assign reset = !KEY[0];
    assign M_clock = !KEY[1];
    assign P_clock = !KEY[2];
    
    // address counter
    wire [4:0] address;
    count_addr memory_address(reset, M_clock, address);

    // ROM
    // 5-bit read address
    wire [7:0] memory_q;
    rom myromfunction(.address(address), .clock(M_clock), .q(memory_q));

    // processor parameter
    wire [7:0] DIN, R0, R1;
    reg [7:0] BusWires;
    assign DIN = memory_q;

    // instruction decode
    wire [7:0] IR, Xreg, Yreg, Xreg_DIN, Yreg_DIN;
    wire [1:0] I;
    reg IRin;       // determine DIN loaded into IR or not

    assign I = DIN[7:6];
    reg_nbits IR_register(IRin, P_clock, reset, DIN, IR);   // IR <- DIN if IRin = 1

    dec3to8 XXX (IR[5:3], 1'b1, Xreg);
    dec3to8 YYY (IR[2:0], 1'b1, Yreg);
    dec3to8 XXX_DIN (DIN[5:3], 1'b1, Xreg_DIN);
    dec3to8 YYY_DIN (DIN[2:0], 1'b1, Yreg_DIN);

    // register's parameter
    reg [7:0] reg_in;
    wire [7:0] reg_matrix [7:0];
    reg [7:0] buswires;

    // combinational logic
    reg_nbits reg0 (reg_in[0], P_clock, reset, buswires, reg_matrix[0]);  // reg_matrix[0] <- buswires if reg_in[0] = 1
    reg_nbits reg1 (reg_in[1], P_clock, reset, buswires, reg_matrix[1]);
    reg_nbits reg2 (reg_in[2], P_clock, reset, buswires, reg_matrix[2]);
    reg_nbits reg3 (reg_in[3], P_clock, reset, buswires, reg_matrix[3]);
    reg_nbits reg4 (reg_in[4], P_clock, reset, buswires, reg_matrix[4]);
    reg_nbits reg5 (reg_in[5], P_clock, reset, buswires, reg_matrix[5]);
    reg_nbits reg6 (reg_in[6], P_clock, reset, buswires, reg_matrix[6]);
    reg_nbits reg7 (reg_in[7], P_clock, reset, buswires, reg_matrix[7]);

    assign R0 = reg_matrix[0];
    assign R1 = reg_matrix[1];

    // Mutiplexer for buswires
    reg RY_out, add, sub;

    always @(*) begin
        if(RY_out) begin             // I = 00
            buswires = reg_matrix[DIN[2:0]];
        end
        else if(add) begin              // I = 10
            buswires = reg_matrix[DIN[5:3]] + reg_matrix[DIN[2:0]];
        end
        else if(sub) begin              // I = 11
            buswires = reg_matrix[DIN[5:3]] - reg_matrix[DIN[2:0]];
        end
        else begin                      // I = 01
            buswires = DIN;
        end
    end

    always @(posedge P_clock, posedge reset) begin
        if(reset)
            BusWires <= 8'b00000000;
        else
            BusWires <= DIN;
    end

    // time control 
    wire Tstep;
    upcount myupcount(reset, P_clock, Tstep);
    
    reg stopflag;       // To check if I is 10
    always @(*) begin
        IRin = 1'b1;
        reg_in = 8'b0000_0000;
        RY_out = 1'b0;
        add = (DIN[7:6] == 2'b10);  
        sub = (DIN[7:6] == 2'b11);  
        stopflag = (BusWires[7:6] == 2'b01);
        
        case (Tstep)
            1'b0: begin             // Tstep = 0 
                IRin = 1'b1;
                case(DIN[7:6])
                    2'b00: begin // mv Rx <- Ry;
                        RY_out = (stopflag) ? 1'b0 : 1'b1;
                        reg_in = (stopflag) ? Xreg : Xreg_DIN;
                    end
                    2'b01: begin // mvi Rx <- #D;
                        reg_in = (stopflag) ? Xreg : 8'd0;
                    end
                    2'b10: begin // add Rx, Ry;
                        reg_in = Xreg_DIN;
                    end
                    2'b11: begin // sub Rx, Ry;
                        reg_in = Xreg_DIN;
                    end
                    default: begin 
                        reg_in = 8'd0;
                    end
                endcase
            end
        default: begin          // Tstep = 1
            IRin = 1'b1;
                case(DIN[7:6])
                    2'b00: begin // mv Rx <- Ry;
                        RY_out = (stopflag) ? 1'b0 : 1'b1;
                        reg_in = (stopflag) ? Xreg : Xreg_DIN;
                    end
                    2'b01: begin // mvi Rx <- #D;
                        reg_in = (stopflag) ? Xreg : 8'd0;
                    end
                    2'b10: begin // add Rx, Ry;
                        reg_in = Xreg_DIN;
                    end
                    2'b11: begin // sub Rx, Ry;
                        reg_in = Xreg_DIN;
                    end
                    default: begin 
                        reg_in = 8'd0;
                    end
                endcase  
            end
        endcase
    end

    assign LEDR = BusWires;

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

module count_addr(reset, clk, Q);
    input reset, clk;
    output reg [4:0] Q;
    always @(posedge clk, posedge reset) begin
        if(reset)
            Q <= 5'd0;
        else
            Q <= Q + 1'b1;
    end
endmodule

module reg_nbits (IRin, clk, reset, DIN, Q);
    parameter N = 8;
    input IRin, clk, reset;
    input [N-1:0] DIN;
    output reg [N-1:0] Q;

    always @(posedge clk or posedge reset) begin
        if (reset)
            Q <= 0;
        else if (IRin)
            Q <= DIN;
        else
            Q <= Q;
    end
endmodule

module dec3to8(W, En, Y);
    input [2:0] W;
    input En;
    output reg [7:0] Y;

    always@ (W or En) 
    begin 
        if(En == 1'b1) begin
            case(W)
                3'b000: Y = 8'b00000001;
                3'b001: Y = 8'b00000010;
                3'b010: Y = 8'b00000100;
                3'b011: Y = 8'b00001000;
                3'b100: Y = 8'b00010000;
                3'b101: Y = 8'b00100000;
                3'b110: Y = 8'b01000000;
                default: Y = 8'b00000000;
            endcase
        end
        else
            Y = 8'b00000000;
    end
endmodule 

module upcount(clear, clk, q);
    // 1 clock cycle
    input clear,  clk;
    output reg q;

    always @(posedge clk or posedge clear) begin
        if (clear)
            q <= 1'b0;
        else
            q <= q + 1'b1;
    end
endmodule