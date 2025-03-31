`timescale 1ns/1ps

module program_counter(in,out,clk);
    input wire [4:0] in;
    output wire [4:0] out;
    reg [4:0] mem;
    input wire clk;

    initial
        mem = 5'b00000;

    assign out = mem;

    always @(negedge clk)begin
        mem = in;
    end
endmodule

module instruction_memory(instruction,address);
    output wire [31:0] instruction;
    reg [31:0] mem [31:0];
    input wire [4:0] address;

    initial begin
        mem[0] = 32'h8C01000E; //lw $1,14($0);
        mem[1] = 32'hAC01000D; //sw $1, 13($0);
        mem[2] = 32'h10010002; //beq $0, $1, 2
        mem[3] = 32'h00000010;
        mem[4] = 32'h00000100;
        mem[5] = 32'h00001000;
        mem[6] = 32'h00010000;
        mem[7] = 32'h00100000;
        mem[8] = 32'h00000000;
        mem[9] = 32'h00000000;
        mem[10] = 32'h00000000;
        mem[11] = 32'h00000000;
        mem[12] = 32'h00000000;
        mem[13] = 32'h00000000;
        mem[14] = 32'h00000000;
        mem[15] = 32'h00000000;
        mem[16] = 32'h00000000;
        mem[17] = 32'h00000000;
        mem[18] = 32'h00000000;
        mem[19] = 32'h00000000;
        mem[20] = 32'h00000000;
        mem[21] = 32'h00000000;
        mem[22] = 32'h00000000;
        mem[23] = 32'h00000000;
        mem[24] = 32'h00000000;
        mem[25] = 32'h00000000;
        mem[26] = 32'h00000000;
        mem[27] = 32'h00000000;
        mem[28] = 32'h00000000;
        mem[29] = 32'h00000000;
        mem[30] = 32'h00000000;
        mem[31] = 32'h00000000;
    end

    assign instruction = mem[address];
endmodule

module data_memory(memread,memwrite,address,clk,wr_data,rd_data);
    input wire memread,memwrite,clk;
    output wire [4:0] address;
    input wire [31:0] wr_data;
    output wire [31:0] rd_data;

    reg[31:0]mem [31:0];
    integer j;

    initial begin
        mem[0] = 32'h00000000; 
        mem[1] = 32'h00000000;
        mem[2] = 32'h00000000;
        mem[3] = 32'h00000000;
        mem[4] = 32'h00000000;
        mem[5] = 32'h00000000;
        mem[6] = 32'h00000000;
        mem[7] = 32'h00000000;
        mem[8] = 32'h00000000;
        mem[9] = 32'h00000000;
        mem[10] = 32'h00000000;
        mem[11] = 32'h00000000;
        mem[12] = 32'h00000000;
        mem[13] = 32'h00000000;
        mem[14] = 32'h10101010;
        mem[15] = 32'h00000000;
        mem[16] = 32'h00000000;
        mem[17] = 32'h00000000;
        mem[18] = 32'h00000000;
        mem[19] = 32'h00000000;
        mem[20] = 32'h00000000;
        mem[21] = 32'h00000000;
        mem[22] = 32'h00000000;
        mem[23] = 32'h00000000;
        mem[24] = 32'h00000000;
        mem[25] = 32'h00000000;
        mem[26] = 32'h00000000;
        mem[27] = 32'h00000000;
        mem[28] = 32'h00000000;
        mem[29] = 32'h00000000;
        mem[30] = 32'h00000000;
        mem[31] = 32'h00000000;
    end

    assign rd_data = (memread) ? mem[address] : 32'bx;

    always @(negedge clk) begin
        //if(memread) rd_data = mem[address];
        if(memwrite) mem[address] = wr_data;
    end
endmodule

module bit32_2to1mux(in1, in2, sel,out);
    input wire [31:0] in1,in2;
    input wire sel;
    output wire [31:0] out;

    assign out = (sel) ? in2 : in1;
endmodule

module bit5_2to1mux(in1, in2, sel,out);
    input wire [4:0] in1,in2;
    input wire sel;
    output wire [4:0] out;

    assign out = (sel) ? in2 : in1;
endmodule

module signExt(in,out);
    input wire [15:0] in;
    output wire [31:0] out;

    assign out = {(in[15]?16'b1:16'b0),in};
endmodule

module shifter(in,out);
    input wire [25:0] in;
    output wire [31:0] out;

    assign out = {4'b0000,in,2'b00};
endmodule

module adder(a,b,out);
    input wire [5:0] a,b;
    output wire [5:0] out;

    assign out = a+b;
endmodule

module SCDatapath(clk,address,out,reset,mux4_out);
    input wire clk;
    input wire [4:0] address;
    input wire reset;
    output wire [31:0] out;
    
    wire [4:0] pc_out;
    wire [31:0] instruction;
    wire RegDst, ALUSrc, MemRead, MemWrite, Branch, ALUOp0, ALUOp1;
    wire MemtoReg;
    wire RegWrite;
    wire [2:0]operation;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire Cout;
    wire [31:0] seout;
    wire [31:0] alu_mux_out;
    wire [31:0] alu_out;
    wire [31:0] rd_data;
    wire [4:0] mux1_out;
    wire [31:0] mux2_out;
    wire [31:0] mux3_out;
    output wire [31:0] mux4_out;
    wire [31:0] shft_address;
    wire [5:0] next_address;
    wire [31:0] a2_out;
    wire zero;

    program_counter pc(address,pc_out,clk);
    instruction_memory im(instruction,pc_out);
    main_controller mc(RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1, instruction[31:26]);
    ALU_controller ac(ALUOp0, ALUOp1, instruction[5:0], operation);
    signExt se(instruction[15:0],seout);
    bit5_2to1mux mux1(instruction[20:16],instruction[15:11],RegDst,mux1_out);
    bit32_2to1mux mux2(ReadData2,seout,ALUSrc,mux2_out);
    bit32_2to1mux mux3(alu_out,rd_data,MemtoReg,mux3_out);
    bit32_2to1mux mux4(next_address,a2_out,zero&Branch,mux4_out);
    adder a1(address,5'b00100,next_address);
    adder a2(next_address,shft_address,a2_out);
    shifter shft(seout,shft_address);
    data_memory d(MemRead,MemWrite,alu_out,clk,ReadData2,rd_data);
    RegFile rf(clk,reset,instruction[25:21],instruction[20:16],mux3_out,mux1_out,RegWrite,ReadData1,ReadData2);
    ALU alu(ReadData1,mux2_out,1'b0,Cout,operation,operation[2],alu_out,zero);

endmodule

module testbench();
    reg clk;
    reg [4:0] address;
    reg reset;
    wire [31:0] out;
    
    wire [31:0] temp;
    SCDatapath uut(clk,address,out,reset,temp);

    initial
        $monitor("time : %0t, address : %b, out : %b, temp = %b",$time,address,out,temp);

    initial begin
        forever
            #5 clk = ~clk;
    end

    initial begin
        clk = 1; address = 5'b00010; reset = 0;
        #6 reset = 1;
        #100 $finish;
    end
endmodule

