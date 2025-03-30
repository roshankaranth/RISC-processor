`timescale 1ns/1ps

module program_counter(in,out,clk);
    input wire [4:0] in;
    output wire [4:0] out;
    reg [4:0] mem;
    input wire clk;

    // initial
    //     mem = 5'b00000;

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
        mem[0] = 32'h00622020; //add $a0, $a2, $a0
        mem[1] = 32'h8C450BB8; //lw $t2, 3000($v0)
        mem[2] = 32'h1009000A; //beq $zero, $t1, 10
        mem[3] = 32'h01A00008; //jr $t5
        mem[4] = 32'h12345678; //beq $s1, $v1, 0x5678
        mem[5] = 32'h98765432;
        mem[6] = 32'hABCDABCD;
    end

    assign instruction = mem[address];
endmodule

// module data_memory(memread,memwrite,address,clk,wr_data,rd_data);
//     input wire memread,memwrite,clk;
//     output wire [4:0] address;
//     input wire [31:0] wr_data;
//     output reg [31:0] rd_data;

//     reg[31:0]data_memory [31:0];
//     integer j;

//     initial begin
//         for(j=0;j<32;j=j+1) begin
//             data_memory[j] = 32'b0;
//         end
//     end

//     always @(negedge clk) begin
//         if(memread) rd_data = data_memory[address];
//         if(memwrite) data_memory[address] = wr_data;
//     end
// endmodule

// module bit32_2to1mux(in1, in1, sel,out);
//     input wire [31:0] in1,in2;
//     input wire sel;
//     output wire [31:0] out;

//     assign out = (sel) ? in2 : in1;
// endmodule

// module signExt(in,out);
//     input wire [15:0] in;
//     output wire [31:0] out;

//     assign out = {(in[15]?16'b1:16'b0),in};
// endmodule

// module shifter(in,out);
//     input wire [25:0] in;
//     output wire [27:0] out;

//     assign out = {in,2'b00};
// endmodule

module SCDatapath(clk,address,out,reset);
    input wire clk;
    input wire [4:0] address;
    input wire reset;
    wire [4:0] pc;
    wire [31:0] instruction;
    wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1;
    wire [2:0]operation;
    wire [31:0] ReadData1, ReadData2;
    wire Cout;
    output wire [31:0] out;

    
    program_counter p1(address,pc,clk);
    instruction_memory im(instruction,pc);
    main_controller mc(RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1, instruction[31:26]);
    ALU_controller ac(ALUOp0, ALUOp1, instruction[5:0], operation);
    RegFile rf(clk,reset,instruction[25:21],instruction[20:16],out,instruction[15:11],RegWrite,ReadData1,ReadData2);
    ALU alu(ReadData1,ReadData2,1'b0,Cout,operation,1'b0,out);

endmodule

module testbench();
    reg clk;
    reg [4:0] address;
    reg reset;
    wire [31:0] out;
    

    SCDatapath uut(clk,address,out,reset);

    initial
        $monitor("time : %0t, address : %b, out : %b",$time,address,out);

    initial begin
        forever
            #5 clk = ~clk;
    end

    initial begin
        clk = 1; address = 5'b00000; reset = 0;
        #6 address = 5'b00001; reset = 1;
        #20 address = 5'b00011;
        #40 $finish;
    end
endmodule

