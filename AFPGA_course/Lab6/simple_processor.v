module simple_processor (reset, P_clock, DIN, BusWires, R0, R1);
    input reset;
    input P_clock;
    input [7:0] DIN;
    output reg [7:0] BusWires;
    output [7:0] R0, R1;

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
endmodule