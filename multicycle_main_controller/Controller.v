`timescale 1ns/1ps;

module main_controller(opcode, PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, RegDst, clk,s);
    input wire [5:0] opcode;
    output reg PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg, RegWrite, RegDst,ALUSrcA;
    output reg [1:0] PCSource, ALUOp, ALUSrcB;
    input wire clk;
    reg [3:0] state;
    reg [3:0] ns;
    output [3:0] s;

    initial begin
        state = 4'b0000;
        PCWrite = 1'b1; PCWriteCond = 1'b0; IorD = 1'b0; MemRead = 1'b1; MemWrite = 1'b0; IRWrite = 1'b1; MemtoReg = 1'b0; RegWrite = 1'b0; RegDst = 1'b0; ALUSrcA = 1'b0;
        PCSource = 2'b00; ALUOp = 2'b00; ALUSrcB = 2'b01;
    end

    assign s = state;

    always @(negedge clk) begin

        ns[3] = ((~state[3]) & (~state[2]) & (~state[1]) & (state[0]) & (~opcode[5]) & (~opcode[4]) & (~opcode[3]) & (~opcode[2]) & (opcode[1]) & (~opcode[0])) |  ((~state[3]) & (~state[2]) & (~state[1]) & (state[0]) & (~opcode[5]) & (~opcode[4]) & (~opcode[3]) & (opcode[2]) & (~opcode[1]) & (~opcode[0]));
        ns[2] = ((~state[3]) & (~state[2]) & (state[1]) & (state[0])) | ((~state[3]) & (state[2]) & (state[1]) & (~state[0])) | ((~state[3]) & (~state[2]) & (~state[1]) & (state[0]) & (~opcode[5]) & (~opcode[4]) & (~opcode[3]) & (~opcode[2]) & (~opcode[1]) & (~opcode[0])) | ((~state[3]) & (~state[2]) & (state[1]) & (~state[0]) & (opcode[5]) & (~opcode[4]) & (opcode[3]) & (~opcode[2]) & (opcode[1]) & (opcode[0]));
        ns[1] = ((~state[3]) & (state[2]) & (state[1]) & (~state[0])) | ((~state[3]) & (~state[2]) & (~state[1]) & (state[0]) & (~opcode[5]) & (~opcode[4]) & (~opcode[3]) & (~opcode[2]) & (~opcode[1]) & (~opcode[0])) | ((~state[3]) & (~state[2]) & (~state[1]) & (state[0]) & (opcode[5]) & (~opcode[4]) & (~opcode[3]) & (~opcode[2]) & (opcode[1]) & (opcode[0])) | ((~state[3]) & (~state[2]) & (~state[1]) & (state[0]) & (opcode[5]) & (~opcode[4]) & (opcode[3]) & (~opcode[2]) & (opcode[1]) & (opcode[0])) | ((~state[3]) & (~state[2]) & (state[1]) & (~state[0]) & (opcode[5]) & (~opcode[4]) & (~opcode[3]) & (~opcode[2]) & (opcode[1]) & (opcode[0]));
        ns[0] = ((~state[3]) & (~state[2]) & (~state[1]) & (~state[0])) | ((~state[3]) & (state[2]) & (state[1]) & (~state[0])) | ((~state[3]) & (~state[2]) & (~state[1]) & (state[0]) & (~opcode[5]) & (~opcode[4]) & (~opcode[3]) & (~opcode[2]) & (opcode[1]) & (~opcode[0])) | ((~state[3]) & (~state[2]) & (state[1]) & (~state[0]) & (opcode[5]) & (~opcode[4]) & (opcode[3]) & (~opcode[2]) & (opcode[1]) & (opcode[0])) | ((~state[3]) & (~state[2]) & (state[1]) & (~state[0]) & (opcode[5]) & (~opcode[4]) & (~opcode[3]) & (~opcode[2]) & (opcode[1]) & (opcode[0]));
        

        PCWrite = ((~ns[3]) & (~ns[2]) & (~ns[1]) & (~ns[0])) | ((ns[3]) & (~ns[2]) & (~ns[1]) & (ns[0]));
        PCWriteCond = ((ns[3]) & (~ns[2]) & (~ns[1]) & (~ns[0]));
        IorD = ((~ns[3]) & (~ns[2]) & (ns[1]) & (ns[0])) | ((~ns[3]) & (ns[2]) & (~ns[1]) & (ns[0]));
        MemRead = ((~ns[3]) & (~ns[2]) & (~ns[1]) & (~ns[0])) | ((~ns[3]) & (~ns[2]) & (ns[1]) & (ns[0]));
        MemWrite = ((~ns[3]) & (ns[2]) & (~ns[1]) & (ns[0]));
        IRWrite = ((~ns[3]) & (~ns[2]) & (~ns[1]) & (~ns[0]));
        MemtoReg = ((~ns[3]) & (ns[2]) & (~ns[1]) & (~ns[0]));
        PCSource[0] = ((ns[3]) & (~ns[2]) & (~ns[1]) & (~ns[0]));
        PCSource[1] = ((ns[3]) & (~ns[2]) & (~ns[1]) & (ns[0]));
        ALUOp[0] = ((ns[3]) & (~ns[2]) & (~ns[1]) & (~ns[0]));
        ALUOp[1] = ((~ns[3]) & (ns[2]) & (ns[1]) & (~ns[0]));
        ALUSrcB[0] = ((~ns[3]) & (~ns[2]) & (~ns[1]) & (~ns[0])) | ((~ns[3]) & (~ns[2]) & (~ns[1]) & (ns[0]));
        ALUSrcB[1] = ((~ns[3]) & (~ns[2]) & (~ns[1]) & (ns[0])) | ((~ns[3]) & (~ns[2]) & (ns[1]) & (~ns[0]));
        ALUSrcA = ((~ns[3]) & (~ns[2]) & (ns[1]) & (~ns[0])) | ((~ns[3]) & (ns[2]) & (ns[1]) & (~ns[0])) | ((ns[3]) & (~ns[2]) & (~ns[1]) & (~ns[0]));
        RegWrite = ((~ns[3]) & (ns[2]) & (~ns[1]) & (~ns[0])) | ((~ns[3]) & (ns[2]) & (ns[1]) & (ns[0]));
        RegDst = ((~ns[3]) & (ns[2]) & (ns[1]) & (ns[0]));

        state = ns;
        
    end
endmodule

module tb_maincu();
reg [5:0] op; 
wire pcwr,pcwrcond,iord,memrd,memwr,irwr,memtoreg,alusrca,regwr,regdst;
wire [1:0] pcsrc,aluop,alusrcb;
reg clk;
wire [3:0] s;

main_controller mc1(op,pcwr,pcwrcond,iord,memrd,memwr,irwr,memtoreg,pcsrc,aluop,alusrcb,alusrca,regwr,regdst,clk,s);

initial 
	$monitor("time : %0t",$time," opcode: %b ",op," PCWrite: %b ", pcwr ,"PCWriteCond : %b ", pcwrcond,"IorD: %b ", iord," MemRead: %b ", memrd," MemWrite: %b ", memwr,
	" IRWrite: %b ", irwr," MemToReg: %b ", memtoreg," PCSource: %b ", pcsrc," ALUOp: %b ", aluop, " ALUSrcB: %b ", alusrcb," ALUSrcA: %b ", alusrca," RegWrite: %b ", regwr,
	" RegDst: %b ", regdst, "state : %b",s);

initial begin
    forever begin
        #5 clk = ~clk;
    end
end

initial begin
    clk = 1;
	#4 op = 6'h00;
    #50 $finish;
end	
endmodule