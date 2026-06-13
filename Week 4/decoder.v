module opcode_decoder(
    input [15:8] inst,
    
    output reg NOOP, INPUTC, INPUTCF, INPUTD, INPUTDF, 
    output reg MOVE, LOADI_LOADP, ADD, ADDI, SUB, SUBI, 
    output reg LOAD, LOADF, STORE, STOREF, 
    output reg SHIFTL, SHIFTR, CMP, JUMP, 
    output reg BRE_BRZ, BRNE_BRNZ, BRG, BRGE
);

    wire [3:0] op_primary   = inst[15:12];
    wire [1:0] op_secondary = inst[9:8];

    always @(*) begin
        NOOP = 0; INPUTC = 0; INPUTCF = 0; INPUTD = 0; INPUTDF = 0;
        MOVE = 0; LOADI_LOADP = 0; ADD = 0; ADDI = 0; SUB = 0; SUBI = 0;
        LOAD = 0; LOADF = 0; STORE = 0; STOREF = 0; 
        SHIFTL = 0; SHIFTR = 0; CMP = 0; JUMP = 0; 
        BRE_BRZ = 0; BRNE_BRNZ = 0; BRG = 0; BRGE = 0;

        case(op_primary)
            4'b0000: NOOP = 1;
            
            4'b0001: begin
                case(op_secondary)
                    2'b00: INPUTC  = 1;
                    2'b01: INPUTCF = 1;
                    2'b10: INPUTD  = 1;
                    2'b11: INPUTDF = 1;
                endcase
            end
            
            4'b0010: MOVE        = 1;
            4'b0011: LOADI_LOADP = 1;
            4'b0100: ADD         = 1;
            4'b0101: ADDI        = 1;
            4'b0110: SUB         = 1;
            4'b0111: SUBI        = 1;
            4'b1000: LOAD        = 1;
            4'b1001: LOADF       = 1;
            4'b1010: STORE       = 1;
            4'b1011: STOREF      = 1;
            
            4'b1100: begin
                if (inst[8] == 1'b0) SHIFTL = 1;
                else                 SHIFTR = 1;
            end
            
            4'b1101: CMP  = 1;
            4'b1110: JUMP = 1;
            
            4'b1111: begin
                case(op_secondary)
                    2'b00: BRE_BRZ   = 1;
                    2'b01: BRNE_BRNZ = 1;
                    2'b10: BRG       = 1;
                    2'b11: BRGE      = 1;
                endcase
            end
        endcase
    end
endmodule
