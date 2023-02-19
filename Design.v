module processor(clk1, clk2);
    input clk1, clk2;  //Dual clock initialization
    
    // Instruction registers initiation
    reg[31:0] if_id_ir, pc; 
    reg[31:0] id_ex_ir, id_ex_a, id_ex_b, id_ex_imm;
    reg[31:0] ex_mem_aluout, ex_mem_ir;
    reg[31:0] mem_rb_ir, mem_rb_aluout;
    
   
    reg[1:0] id_ex_type, ex_mem_type, mem_rb_type; // Instruction type initialization
    reg[31:0] regb[0:31];  
    reg[31:0] mem[0:31];
    reg[5:0] id_ex_opcd, ex_mem_opcd;
    reg halted;
    
    parameter add = 6'b000000, sub = 6'b000001, mul = 6'b000010, div = 6'b000011, lsft = 6'b000100, addi = 6'b100001, subi = 6'b100010, muli = 6'b100011, divi = 6'b100100, halt = 6'b111111;
    parameter rr_type = 2'b00, rm_type = 2'b01;
    
    //--------------------------------------INSTRUCTION FETCH------------------------------------------------------------------//
    
    always @(posedge clk1)
        if(halted == 0)
            begin
            if_id_ir = mem[pc];
            pc = pc + 1;
            end
    
    //--------------------------------------INSTRUCTION DECODE------------------------------------------------------------------//
    
    always @(posedge clk2)
        begin
        if(halted == 0)
            begin
            if(if_id_ir[31:26] == 6'b111111)
            halted <= 1;
            if(if_id_ir[31] == 0)
            id_ex_type <= rr_type;
            if(if_id_ir[31] == 1)
            id_ex_type <= rm_type;
            end
        id_ex_ir <= if_id_ir;
        id_ex_a <= regb[if_id_ir[20:16]];
        id_ex_b <= regb[if_id_ir[15:11]];
        id_ex_imm <= if_id_ir[15:0];
        id_ex_opcd <= if_id_ir[31:26];
        end
        
    //----------------------------------------INSTRUCTION EXECUTE--------------------------------------------------------------//
    
    always @(posedge clk1)
        begin
        if(halted == 0)
            begin
            case(id_ex_type)
            rr_type : begin
                      case(id_ex_opcd)
                          add : ex_mem_aluout <= id_ex_a + id_ex_b;
                          sub : ex_mem_aluout <= id_ex_a - id_ex_b;
                          mul : ex_mem_aluout <= id_ex_a * id_ex_b;
                          sub : ex_mem_aluout <= id_ex_a / id_ex_b;
                          lsft : ex_mem_aluout <= id_ex_a << id_ex_b;
                          default : ex_mem_aluout <= 8'h00000000;
                      endcase
                      end
            
            rm_type : begin
                      case(id_ex_opcd)
                          addi : ex_mem_aluout <= id_ex_a + id_ex_imm;
                          subi : ex_mem_aluout <= id_ex_a - id_ex_imm;
                          muli : ex_mem_aluout <= id_ex_a * id_ex_imm;
                          divi : ex_mem_aluout <= id_ex_a / id_ex_imm;
                          default : ex_mem_aluout <= 8'h00000000;
                      endcase
                      end
            default : ex_mem_aluout <= 8'h00000000;
            endcase
            end
        ex_mem_ir <= id_ex_ir;
        ex_mem_type <= id_ex_type;
        end
        
    //----------------------------------------------MEMORY STAGE-----------------------------------------------------------------------------------------//
    
    always @(posedge clk2)
        begin
        if(halted == 0)
            begin
            mem_rb_ir <= ex_mem_ir;
            mem_rb_type <= ex_mem_type;
            mem_rb_aluout <= ex_mem_aluout;
            end
        end
        
    //--------------------------------------------------WRITE BACK----------------------------------------------------------------------------------------//
    
    always @(posedge clk1)
        begin
        if(halted == 0)
            regb[mem_rb_ir[25:21]] <= mem_rb_aluout;
        end
endmodule