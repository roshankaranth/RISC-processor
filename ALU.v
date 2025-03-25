`timescale 1ns/1ps;

module mux3to1(out,sel,in1,in2,in3);
    input wire in1,in2,in3;
    input wire [1:0] sel;
    output reg out;

    always @(*) begin
        case (sel)
            2'b00 : out = in1;
            2'b01 : out = in2;
            2'b10 : out = in3;
        endcase
    end
endmodule;

module bit8_3to1mux(out,sel,in1,in2,in3);
    input wire [7:0] in1,in2,in3;
    output wire [7:0] out;
    input wire [1:0] sel;
    genvar j;

    generate
        for (j=0 ; j<8 ; j=j+1) begin: mux_loop
            mux3to1 m(out[j],sel,in1[j],in2[j],in3[j]);
        end
    endgenerate
endmodule

module bit32_3to1mux(out,sel,in1,in2,in3);
    input wire [31:0] in1,in2,in3;
    output wire [31:0] out;
    input wire [1:0] sel;
    genvar j;

    generate
        for(j = 0 ; j < 4 ; j=j+1) begin: mux_loop
            bit8_3to1mux m(out[(j+1)*8 - 1:j*8],sel,in1[(j+1)*8 - 1:j*8],in2[(j+1)*8 - 1:j*8],in3[(j+1)*8 - 1:j*8]);
        end 
    endgenerate
endmodule

module testbench();
    reg [31:0] in1,in2,in3;
    reg [1:0] sel;
    wire [31:0] out;

    bit32_3to1mux uut(out,sel,in1,in2,in3);

    initial
        $monitor("time : %0t, in1 : %b, in2 = %b, in3 = %b, sel = %b, out = %b", $time,in1,in2,in3,sel,out);

    initial begin
        in1 = 32'b00000000_00000000_00000000_00000001;
        in2 = 32'b00000000_00000000_00000000_00000011;
        in3 = 32'b00000000_00000000_00000000_00000111;
        #2
        sel = 2'b00; #2;
        sel = 2'b01; #2;
        sel = 2'b10; #2;
    end
endmodule