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
    wire [4:0] M_address;
    count_addr memory_address(reset, M_clock, M_address);

    // ROM (5-bit read address)
    wire [7:0] memory_q;
    rom myromfunction(.address(M_address), .clock(M_clock), .q(memory_q));

    // processor
    wire [7:0] DIN, R0, R1, BusWires;
    assign DIN = memory_q;

    simple_processor simple_processor_uut(reset, P_clock, DIN, BusWires, R0, R1);

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