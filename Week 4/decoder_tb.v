`timescale 1ns / 1ps

module tb_opcode_decoder();

    reg [15:8] inst;

    wire NOOP, INPUTC, INPUTCF, INPUTD, INPUTDF;
    wire MOVE, LOADI_LOADP, ADD, ADDI, SUB, SUBI;
    wire LOAD, LOADF, STORE, STOREF;
    wire SHIFTL, SHIFTR, CMP, JUMP;
    wire BRE_BRZ, BRNE_BRNZ, BRG, BRGE;

    opcode_decoder uut (
        .inst(inst), 
        .NOOP(NOOP), .INPUTC(INPUTC), .INPUTCF(INPUTCF), .INPUTD(INPUTD), .INPUTDF(INPUTDF), 
        .MOVE(MOVE), .LOADI_LOADP(LOADI_LOADP), .ADD(ADD), .ADDI(ADDI), .SUB(SUB), .SUBI(SUBI), 
        .LOAD(LOAD), .LOADF(LOADF), .STORE(STORE), .STOREF(STOREF), 
        .SHIFTL(SHIFTL), .SHIFTR(SHIFTR), .CMP(CMP), .JUMP(JUMP), 
        .BRE_BRZ(BRE_BRZ), .BRNE_BRNZ(BRNE_BRNZ), .BRG(BRG), .BRGE(BRGE)
    );

    integer i;

    initial begin
        $display("Starting Opcode Decoder Testbench...");
        
        $dumpfile("decoder_waves.vcd");
        $dumpvars(0, tb_opcode_decoder);

        inst = 8'b0000_0000; #10; 
        inst = 8'b0100_0000; #10; 
        inst = 8'b0001_0011; #10; 
        inst = 8'b1100_0001; #10; 
        inst = 8'b1111_0010; #10; 

        for (i = 0; i < 256; i = i + 1) begin
            inst = i; 
            #10;      
        end
        
        $display("Simulation Complete. Check waveforms for verification.");
        $finish; 
    end

endmodule
