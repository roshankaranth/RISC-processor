`timescale 1ns/1ps

module program_counter(inp,clk,outp);
    input wire [4:0] inp;
    output reg [4:0] outp;
    input wire clk;

    always @(negedge clk) begin
        outp <= inp;
    end
endmodule;

module instruction_memory(pc,instr,clk,reset);
    reg [31:0] mem [31:0];
    input clk,reset;
    input [4:0] pc;
    output reg [31:0] instr;

    initial begin
        mem[0] = 32'h00622020;
        mem[1] = 32'h8C450BB8;
        mem[2] = 32'h1009000A;
        mem[3] = 32'h01A00008;
        mem[4] = 32'h12345678;
        mem[5] = 32'h98765432;
        mem[6] = 32'hABCDABCD; 
    end

    always @(negedge clk, pc) begin
        if(reset) instr = 32'b0;
        else instr = mem[pc];
    end
endmodule

module data_memeory(addr, wr_data, rd_data, clk, reset, memwrite, memread);
    input clk,reset,memread,memwrite;
    input [31:0] wr_data;
    input [4:0] addr;
    output reg [31:0] rd_data;
    reg [31:0] mem [31:0];
    integer j;

    initial begin
        for(j = 0; j < 32 ; j = j + 1) begin
            mem[j] = 32'b0;
        end
    end

    always @(negedge clk) begin
        if(reset) rd_data = 32'b0;
        else begin
            if(memread) rd_data = mem[addr];
            else if(memwrite) mem[addr] = wr_data;
        end
    end
endmodule

module bit32_2to1mux(out,in1,in2,sel);
    input wire [31:0] in1,in2;
    input wire sel;
    output wire [31:0] out;

    assign out = (sel) ? in2 : in1;
endmodule

module signExt(inp, out);
    input wire [15:0] inp;
    input wire [31:0] out;

    assign out = {(inp[15])?16'b1:16'b0,inp};
    
endmodule

module shifter(inp,out);
    input wire [31:0] inp;
    output wire [31:0] out;

    assign out = {inp[29:0],2'b00};
endmodule

module SCDatapath(input reset);
    reg clk;
    reg [4:0] pcOut;

    program_counter pc(5'b0,clk,reset);
    instruction_memory im(pc,reset,instr);
endmodule

module TestBench;
    wire [31:0] ALU_output;
    reg [31:0] PC;
    reg reset,clk;

    SCDataPath SCDP(ALU_output,PC,reset,clk);
    initial begin
    
    $monitor("at time %0d IPC = %d, Reset = %d , CLK = %d , ALU Output = %d",$time,start_pc,rst,clk, ALU_output);
    
    #0 clk = 0; PC = 5;
    #120 rst = 1;
    #400 $stop;
    
    end
    
    always begin
    #20 clk = ~clk;
    end
endmodule