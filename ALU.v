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
            default : out = 1'bx;
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

module bit32AND(out,in1,in2);
    input wire [31:0] in1,in2;
    output wire [31:0] out;

    assign out = in1 & in2;
endmodule

module bit32OR(out,in1,in2);
    input wire [31:0] in1,in2;
    output wire [31:0] out;

    assign out = in1 | in2;
endmodule

module FA(Cout,Sum,In1,In2,Cin);
    input wire [31:0] In1,In2;
    input wire Cin;
    output wire [31:0] Sum;
    output wire Cout;

    assign {Cout,Sum} = In1 + In2 + Cin;
endmodule

module ALU(in1,in2,Cin,Cout,op,binvert,out);
    input wire [31:0] in1,in2;
    input wire Cin,binvert;
    output wire Cout;
    output wire [31:0] out;
    input wire [1:0] op;

    wire [31:0] in2_val;

    wire [31:0] OR_res;
    wire [31:0] AND_res;
    wire [31:0] FA_res;

    assign in2_val = (binvert == 1'b0) ? in2 : ~in2;
    assign out = (op == 2'b00) ? AND_res : (op == 2'b01) ? OR_res : FA_res;

    FA m1(Cout,FA_res,in1,in2_val,(binvert == 1'b0) ? Cin : 1'b1);
    bit32OR m2(OR_res, in1,in2);
    bit32AND m3(AND_res, in1,in2);

endmodule



