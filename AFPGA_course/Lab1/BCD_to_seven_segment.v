module BCD_to_seven_segment_1(in, seg1, seg0);
input [5:0] in;
output reg [6:0] seg1, seg0;
always@(in)
    case(in)
      6'b000000: begin seg1 = 7'b1000000; seg0 = 7'b1111111; end // 0
      6'b000001: begin seg1 = 7'b1111001; seg0 = 7'b1111111; end // 1
      6'b000010: begin seg1 = 7'b0100100; seg0 = 7'b1111111; end // 2
      6'b000011: begin seg1 = 7'b0110000; seg0 = 7'b1111111; end // 3
      6'b000100: begin seg1 = 7'b0011001; seg0 = 7'b1111111; end // 4
      6'b000101: begin seg1 = 7'b0010010; seg0 = 7'b1111111; end // 5
      6'b000110: begin seg1 = 7'b0000010; seg0 = 7'b1111111; end // 6
      6'b000111: begin seg1 = 7'b1111000; seg0 = 7'b1111111; end // 7
      6'b001000: begin seg1 = 7'b0000000; seg0 = 7'b1111111; end // 8
      6'b001001: begin seg1 = 7'b0010000; seg0 = 7'b1111111; end // 9
      6'b001010: begin seg1 = 7'b1000000; seg0 = 7'b1111001; end // 10
      6'b001011: begin seg1 = 7'b1111001; seg0 = 7'b1111001; end // 11
      6'b001100: begin seg1 = 7'b0100100; seg0 = 7'b1111001; end // 12
      6'b001101: begin seg1 = 7'b0110000; seg0 = 7'b1111001; end // 13
      6'b001110: begin seg1 = 7'b0011001; seg0 = 7'b1111001; end // 14
      6'b001111: begin seg1 = 7'b0010010; seg0 = 7'b1111001; end // 15
      6'b010000: begin seg1 = 7'b0000010; seg0 = 7'b1111001; end // 16
      6'b010001: begin seg1 = 7'b1111000; seg0 = 7'b1111001; end // 17
      6'b010010: begin seg1 = 7'b0000000; seg0 = 7'b1111001; end // 18
      6'b010011: begin seg1 = 7'b0010000; seg0 = 7'b1111001; end // 19
      6'b010100: begin seg1 = 7'b1000000; seg0 = 7'b0100100; end // 20
      6'b010101: begin seg1 = 7'b1111001; seg0 = 7'b0100100; end // 21
      6'b010110: begin seg1 = 7'b0100100; seg0 = 7'b0100100; end // 22
      6'b010111: begin seg1 = 7'b0110000; seg0 = 7'b0100100; end // 23
      6'b011000: begin seg1 = 7'b0011001; seg0 = 7'b0100100; end // 24
      6'b011001: begin seg1 = 7'b0010010; seg0 = 7'b0100100; end // 25
      6'b011010: begin seg1 = 7'b0000010; seg0 = 7'b0100100; end // 26
      6'b011011: begin seg1 = 7'b1111000; seg0 = 7'b0100100; end // 27
      6'b011100: begin seg1 = 7'b0000000; seg0 = 7'b0100100; end // 28
      6'b011101: begin seg1 = 7'b0010000; seg0 = 7'b0100100; end // 29
      6'b011110: begin seg1 = 7'b1000000; seg0 = 7'b0110000; end // 30
      6'b011111: begin seg1 = 7'b1111001; seg0 = 7'b0110000; end // 31
      6'b100000: begin seg1 = 7'b0100100; seg0 = 7'b0110000; end // 32
      6'b100001: begin seg1 = 7'b0110000; seg0 = 7'b0110000; end // 33
      6'b100010: begin seg1 = 7'b0011001; seg0 = 7'b0110000; end // 34
      6'b100011: begin seg1 = 7'b0010010; seg0 = 7'b0110000; end // 35
      6'b100100: begin seg1 = 7'b0011001; seg0 = 7'b0110000; end // 36
      6'b100101: begin seg1 = 7'b0010010; seg0 = 7'b0110000; end // 37
      6'b100110: begin seg1 = 7'b0000010; seg0 = 7'b0110000; end // 38
      6'b100111: begin seg1 = 7'b1111000; seg0 = 7'b0110000; end // 39
      6'b101000: begin seg1 = 7'b0000000; seg0 = 7'b0110000; end // 40
      6'b101001: begin seg1 = 7'b0010000; seg0 = 7'b0110000; end // 41
      6'b101010: begin seg1 = 7'b1000000; seg0 = 7'b0011001; end // 42
      6'b101011: begin seg1 = 7'b1111001; seg0 = 7'b0011001; end // 43
      6'b101100: begin seg1 = 7'b0100100; seg0 = 7'b0011001; end // 44
      6'b101101: begin seg1 = 7'b0110000; seg0 = 7'b0011001; end // 45
      6'b101110: begin seg1 = 7'b0011001; seg0 = 7'b0011001; end // 46
      6'b101111: begin seg1 = 7'b0010010; seg0 = 7'b0011001; end // 47
      6'b110000: begin seg1 = 7'b0000010; seg0 = 7'b0011001; end // 48
      6'b110001: begin seg1 = 7'b1111000; seg0 = 7'b0011001; end // 49
      6'b110010: begin seg1 = 7'b0000000; seg0 = 7'b0011001; end // 50
      6'b110011: begin seg1 = 7'b0010000; seg0 = 7'b0011001; end // 51
      6'b110100: begin seg1 = 7'b1000000; seg0 = 7'b0010010; end // 52
      6'b110101: begin seg1 = 7'b1111001; seg0 = 7'b0010010; end // 53
      6'b110110: begin seg1 = 7'b0100100; seg0 = 7'b0010010; end // 54
      6'b110111: begin seg1 = 7'b0110000; seg0 = 7'b0010010; end // 55
      6'b111000: begin seg1 = 7'b0011001; seg0 = 7'b0010010; end // 56
      6'b111001: begin seg1 = 7'b0010010; seg0 = 7'b0010010; end // 57
      6'b111010: begin seg1 = 7'b0000010; seg0 = 7'b0010010; end // 58
      6'b111011: begin seg1 = 7'b1111000; seg0 = 7'b0010010; end // 59
      default:   begin seg1 = 7'b1111111; seg0 = 7'b1111111; end // blank
    endcase
endmodule