`timescale 1ns/1ps;

module d_ff(q,d,clk,reset);
    input wire d,clk,reset;
    output reg q;

    always @(negedge clk or negedge reset) begin
        if(!reset) q<=1'b0;
        else q <= d;
    end

endmodule

module reg_32bit(q,d,clk,reset);
    input wire [31:0] d;
    output wire [31:0] q;
    input wire clk,reset;
    genvar j;

    generate
        for(j = 0 ; j < 32 ; j=j+1) begin : ff
            d_ff f(q[j],d[j],clk,reset);
        end
    endgenerate

endmodule

module mux4_1(regData,q1,q2,q3,q4,reg_no);
    input wire [31:0] q1,q2,q3,q4;
    input wire [1:0] reg_no;
    output reg [31:0] regData;

    always @(*) begin
        case (reg_no)
            2'b00 : regData = q1;
            2'b01 : regData = q2;
            2'b10 : regData = q3;
            2'b11 : regData = q4;
            default : regData = 32'bx;
        endcase
    end
endmodule

module decoder2_4(register,reg_no);
    input wire [1:0] reg_no;
    output reg [3:0]register;

    always @(*) begin
        case (reg_no)
            2'b00 : register = 4'b0001;
            2'b01 : register = 4'b0010;
            2'b10 : register = 4'b0100;
            2'b11 : register = 4'b1000;
            default : register = 4'bx;
        endcase
    end
endmodule

module RegFile(clk,reset,ReadReg1,ReadReg2,WriteData,WriteReg,RegWrite,ReadData1,ReadData2);
    input wire clk,reset,RegWrite;
    input wire [1:0] ReadReg1, ReadReg2,WriteReg;
    output wire [31:0] ReadData1, ReadData2;
    input wire [31:0] WriteData;
    genvar j;

    wire [31:0] q [3:0];
    wire [3:0] register;

    decoder2_4 d(register,WriteReg);

    generate
        for(j = 0 ; j < 4 ; j=j+1) begin
            reg_32bit r(q[j],WriteData,register[j]&RegWrite&clk,reset);
        end
    endgenerate

    mux4_1 mux1(ReadData1,q[0],q[1],q[2],q[3],ReadReg1);
    mux4_1 mux2(ReadData2,q[0],q[1],q[2],q[3],ReadReg2);

endmodule

