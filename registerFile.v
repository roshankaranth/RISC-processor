`timescale 1ns/1ps;

module d_ff(q,d,clk,reset);
    input wire d,clk,reset;
    output reg q;

    always @(negedge clk or negedge reset) begin
        if(!reset) q<= 1'b0;
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

module mux32_1(regData,q0,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23,q24,q25,q26,q27,q28,q29,q30,q31,reg_no);
    input wire [31:0] q0,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16,q17,q18,q19,q20,q21,q22,q23,q24,q25,q26,q27,q28,q29,q30,q31;
    input wire [4:0] reg_no;
    output reg [31:0] regData;
    genvar j;

    always @(*) begin
        case (reg_no)
            5'b00000 : regData = q0;
            5'b00001 : regData = q1;
            5'b00010 : regData = q2;
            5'b00011 : regData = q3;
            5'b00100 : regData = q4;
            5'b00101 : regData = q5;
            5'b00110 : regData = q6;
            5'b00111 : regData = q7;
            5'b01000 : regData = q8;
            5'b01001 : regData = q9;
            5'b01010 : regData = q10;
            5'b01011 : regData = q11;
            5'b01100 : regData = q12;
            5'b01101 : regData = q13;
            5'b01110 : regData = q14;
            5'b01111 : regData = q15;
            5'b10000 : regData = q16;
            5'b10001 : regData = q17;
            5'b10010 : regData = q18;
            5'b10011 : regData = q19;
            5'b10100 : regData = q20;
            5'b10101 : regData = q21;
            5'b10110 : regData = q22;
            5'b10111 : regData = q23;
            5'b11000 : regData = q24;
            5'b11001 : regData = q25;
            5'b11010 : regData = q26;
            5'b11011 : regData = q27;
            5'b11100 : regData = q28;
            5'b11101 : regData = q29;
            5'b11110 : regData = q30;
            5'b11111 : regData = q31;
        endcase 
    end
endmodule

module decoder5_32(register,reg_no);
    input wire [4:0] reg_no;
    output reg [31:0]register;

    always @(*) begin
        register = 32'b0;
        register[reg_no] = 1'b1;
    end
endmodule

module RegFile(clk,reset,ReadReg1,ReadReg2,WriteData,WriteReg,RegWrite,ReadData1,ReadData2);
    input wire clk,reset,RegWrite;
    input wire [4:0] ReadReg1, ReadReg2,WriteReg;
    output wire [31:0] ReadData1, ReadData2;
    input wire [31:0] WriteData;
    genvar j;

    wire [31:0] q [31:0];
    wire [31:0] register;

    decoder5_32 d(register,WriteReg);

    generate
        for(j = 0 ; j < 32 ; j=j+1) begin
            reg_32bit r(q[j],WriteData,register[j]&RegWrite&clk,reset);
        end
    endgenerate

    mux32_1 mux1(ReadData1,q[0],q[1],q[2],q[3],q[4],q[5],q[6],q[7],q[8],q[9],q[10],q[11],q[12],q[13],q[14],q[15],q[16],q[17],q[18],q[19],q[20],q[21],q[22],q[23],q[24],q[25],q[26],q[27],q[28],q[29],q[30],q[31],ReadReg1);
    mux32_1 mux2(ReadData2,q[0],q[1],q[2],q[3],q[4],q[5],q[6],q[7],q[8],q[9],q[10],q[11],q[12],q[13],q[14],q[15],q[16],q[17],q[18],q[19],q[20],q[21],q[22],q[23],q[24],q[25],q[26],q[27],q[28],q[29],q[30],q[31],ReadReg2);

endmodule

