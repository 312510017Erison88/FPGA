// Description of the simple circuit 
module smpl_circuit(a, b, c, x, y);
    input a, b, c;
    output x, y;
    wire e;
    and g1(e, a, b);
    not g2(y,c);
    or g3(x, e, y);
endmodule

// Descroption of circuit with delay
module circuit_with_delay(a, b, c, x, y);
    input a, b, c;
    output x, y;
    wire e;
    and #(30) g1(e, a, b);
    or #(20) g3(x,e,y);
    not #(10) g2(y, c);
endmodule

// Stimulus for simple circuit
module stimcrct;
initial 
begin
    a = 1'b0; b = 1'b0; c = 1'b0;
    #100
    a = 1'b1; b = 1'b1; c = 1'b1;
    #100 $finish;
end 
endmodule

// 2 to 1 MUX example -> sel and sel_
module MUX2_1(out, a, b, sel);
    input a, b, sel;
    output out;

    not #(0.4, 0.3)(sel_, sel);
    and #(0.7, 0.6)(a1, a,sel_);
    and #(0.7,0.6)(b1, sel);
    or #(0.7, 0.6)(out, al, b1);

endmodule

// Tri-state gate 
module 2_1_mux(mux_out, p0, p1, s);
    input p0, p1, s;
    output mux_out;
    tri mux_out;    // 第三態的節點

    bufif0(mux_out, p0, s);
    bufif1(mux_out, p0, s);

endmodule

// Circuit specified with Boolen equations
// Boolen expression 
module circuit_bin(x, y, a, b, c, d);
    input a, b, c, d;
    output x, y;
    assign x = a | (b & c) | (~b & d);
    assign y = (~b & c) | (b & ~c & ~d);
endmodule

// user defined primitive 
//UDP
primitive crctp(x, a, b, c);
    output x;
    input a, b, c;
    table
        0 0 0 : 1;
        0 0 1 : 0;
        0 1 0 : 1;
        0 1 1 : 0;
        1 0 0 : 1;
        1 0 1 : 0;
        1 1 0 : 1;
        1 1 1 : 1;
    endtable
endprimitive
// instantiate primitive (use above table)
module declare_crctp;
    reg x, y, z;
    wire w;
    crctp(w, x, y, z);
endmodule

// Dataflow description of 4-bit adder
module adder(a, b, Cin, sum, Cout);
    input [3:0] a,b;
    input Cin;
    output [3:0] sum;
    output Cout;
    assign {Cout, sum} = a + b + Cin;
endmodule

// Dataflow description of 4-bit comparator
module magcomp(a, b, ASTB, AGTB, AETB);
    input [3:0] a,b;
    output ASTB, AGTB, AETB;
    assign ASTB = (a<b), AGTB = (a>b), AETB = (a==b);
endmodule

// conditional operator
// conditon ? True statement : False statement
module mux2_1_df(a, b, select, out);
    input a, b select;
    output out;
    assign out = select ? a : b;        // select = 1, out = a ; select = 0, out = b
endmodule

// behavior description of the 4-1 line multiplexer
module mux4_1bh(i0, i1, i2, i3, select, y);
    input i0, i1, i2, i3;
    input [1:0] select;                 // input 只能接線不能宣告成暫存器
    output y;                           // output 可以宣告成接線或暫存器
    reg y;
    always @ (i0 or i1 or i2 or i3 or select)
    case (select)
        2'b00: y = i0;
        2'b01: y = i1;
        2'b10: y = i2;
        2'b11: y = i3;
    endcase
endmodule

// writing the somple test bench
// stimulus for mux2_1
module testmux;
    reg ta, tb, ts;
    wire y;
    mux2x1_df mx(ta, tb, ts, y);
        initial                         // 區塊內的輸出資料(等號左邊)，用reg來宣告 ; 通常用於測試波型和電路驗證
        begin                           // 多行敘述就需要使用 begin end
            ts = 1; ta = 0; tb = 1;
            #10 ta = 1; tb = 0;
            #10 ts = 0
            #10 ta = 0; tb = 1;
        end
        initial
        $monitor("select = %b A = %b B = %b out = %b time = %0d", ts, ta, tb, y, $time); 
endmodule

module mux2x1_df(a, b, select, out);

    input a, b, select;
    output out;
    assign out = select ? a : b

endmodule

// Behavioral description of a 4-bit universal shift register (behavior)
module Shift_Register_4_beh(
    output reg [3:0] A_par,                         // register output
    input [3:0] I_par,                              // Parallel input
    input s1, s0,                                   // Select inputs
        MSB_in, LSB_in,                             // Serial inputs
        CLK, Clear                                  // Clock and Clear
);
    always @(posedge CLK, negedge Clear)
        if (~Clear) A_par <= 4'b0000;
        else
            case({s1, s0})
                2'b00:A_par <= A_par;                   // no change  "<=" 為同時寫進去
                2'b01:A_par <= {MSB_in, A_par[3:1]};    // Shift right
                2'b10:A_par <= {A_par[2:0], LSB_in};    // Shift left
                2'b11:A_par <= I_par;                   // Parallel load of input
            endcase
endmodule

// Behavioral description of a 4-bit binary counter with parallel load
module BinaryCounter_4_Par_Load(
    output reg [3:0] A_count,                       // Data output
    output C_out,                                   // output carry
    input [3:0] Data_in,                            // Data input
    input count, load                               // active high to count, and active high to load
        CLK, Clear                                  // Clock and Clear
);
    assign C_out = count & (~load) & (A_count == 4'b1111);      // A_count=15 -> 有進位
    always @(posedge CLK, negedge Clear)
        if (~Clear)     A_count <= 4'b0000;
        else if (load)  A_count <= Data_in;
        else if (count) A_count <= A_count + 1;
        else            A_count <= A_count;         // no change
endmodule