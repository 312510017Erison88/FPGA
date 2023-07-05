// full adder implementation
module CSA_3Var_4bit(a, b, c, sum);
    input[3:0] a, b, c;
    output [5:0] sum;
    reg [3:0] s, cs;
    wire [2:0] co;
    wire [5:0] sum;         // 可不用宣告
    always@(a or b or c)
    begin
        {cs[0], s[0]} = a[0] + b[0] + c[0];
        {cs[1], s[1]} = a[1] + b[1] + c[1]; 
        {cs[2], s[2]} = a[2] + b[2] + c[2]; 
        {cs[3], s[3]} = a[3] + b[3] + c[3];
    /*
    begin: csa_blk
        integer i;
        for(i=0; i<4; i=i+1)
            {c[i], s[i]} = a[i] + b[i] + c[i];
    end
    */  
    end
    assign sum[0] = s[0];
    assign {co[0], sum[1]} = cs[0] + s[1];
    assign {co[1], sum[2]} = cs[1] + s[2] + co[0];
    assign {co[2], sum[3]} = cs[2] + s[3] + co[1];
    assign {sum[5], sum[4]} = cs[3] + co[2];
endmodule

// 4-to-1 multiplexer
module mux_4to1(a, b, c, d, s0, s1, out); 
    input a, b, c, d, s0, s1;
    output out;

    reg out;
    always@(a or b or c or d or s0 or s1)   //can use "always@(*);" too!
    begin 
        case({s1, s0})
        2'b00: out = a;
        2'b01: out = b;
        2'b10: out = c;
        2'b11: out = d;
        endcase
    end
endmodule

// 多位元多工器
module mux2_1_muti_bits(a, b, sel, out);
    parameter width  = 4;
    input [width-1:0] a, b;
    input sel;
    output [width-1:0] out;

    assign out = sel ? a : b;

endmodule

// Comparator
module comparator(a, b, gt, lt, eq);
    input [3:0] a, b;
    output gt, lt, eq;

    reg gt, lt, eq;         // 因為是behavior model

    always@(a or b)         // always@(a, b)
    begin 
        gt = (a > b);
        lt = (a < b);
        eq = (a==b);
    end
    /*
    assign gt = (a > b);
    assign lt = (a < b);
    assign eq = (a==b);
    */
endmodule

// Decorder
module decorder_2to4(in0, in1, w, x, y, z);
    input in0, in1;
    output w, x, y, z;

    reg w, x, y, z;

    always@(in0 or in1)
    begin
        case({in0, in1})
            2'b00: {w,x,y,z} = 4'b0001;
            2'b00: {w,x,y,z} = 4'b0010;
            2'b00: {w,x,y,z} = 4'b0100;
            2'b00: {w,x,y,z} = 4'b1000;
        endcase
    end
endmodule

// 致能解碼器
module en_decorder_3to6(en, in, out);
    input en;
    input[2:0] in;
    output[5:0] out;

    reg [5:0] out;

    always @(en or in) begin
        if(!en) out = 6'b0;
        else case(in)
                3'd0: out = 6'b000001;
                3'd1: out = 6'b000010;
                3'd2: out = 6'b000100;
                3'd3: out = 6'b001000;
                3'd4: out = 6'b010000;
                3'd5: out = 6'b010000;
                default: out = 6'b0;
        endcase
    end
endmodule

// Encorder
module encorder_4to2(in0, in1, in2, in3, v, o1, o2);
    input in0, in1, in2, in3;
    output v;
    output o1, o2;

    reg v;

    always@(in0 or in1 or in2 or in3)
    begin
        case({in3, in2, in1, in0})
            4'b0001:{v, o1, o2} = 3'b100;
            4'b0010:{v, o1, o2} = 3'b101;
            4'b0100:{v, o1, o2} = 3'b110;
            4'b1000:{v, o1, o2} = 3'b111;
            default:{v, o1, o2} = 3'b000;
        endcase
    end
endmodule