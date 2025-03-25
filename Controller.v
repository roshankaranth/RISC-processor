`timescale 1ns/1ps;

module main_controller(RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUop1, Op);
    input wire [5:0] Op;
    output wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUop1;
    wire Rformat,lw,sw,beq;

    assign Rformat = (~Op[0]) & (~Op[1]) & (~Op[2]) & (~Op[3]) & (~Op[4]) & (~Op[5]);
    assign lw = (Op[0]) & (Op[1]) & (~Op[2]) & (~Op[3]) & (~Op[4]) & (Op[5]);
    assign sw = (Op[0]) & (Op[1]) & (~Op[2]) & (Op[3]) & (~Op[4]) & (Op[5]);
    assign beq = (~Op[0]) & (~Op[1]) & (Op[2]) & (~Op[3]) & (~Op[4]) & (~Op[5]);

    assign RegDst = Rformat;
    assign ALUSrc = lw | sw;
    assign MemtoReg = lw;
    assign RegWrite = Rformat | lw;
    assign MemRead =  lw;
    assign MemWrite = sw;
    assign Branch = beq;
    assign ALUOp0 = Rformat;
    assign ALUop1 = beq;

endmodule

module ALU_controller(ALUOp0, ALUOp1, funct, operation);
    input wire ALUOp0, ALUOp1;
    input wire [5:0] funct;
    output wire [2:0]operation;

    assign operation[0] = (ALUOp0 & (funct[0] | funct[3]));
    assign operation[1] = (~(ALUOp1) | ~(funct[2]));
    assign operation[2] = (ALUOp0 | (ALUOp1 & funct[1]));

endmodule