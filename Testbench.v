module testbench();
    reg clk1, clk2;
    integer count;
    processor cpu(clk1, clk2);
    
    initial
        begin
            clk1=0; clk2=0;
        end
    always
    begin
        #6 clk1 = 1; #6 clk1 = 0;
        #6 clk2 = 1; #6 clk2 = 0;
    end
    
    initial
    begin
    for (count=0; count<31; count = count+1) cpu.regb[count] <= count;
    cpu.mem[0] <= 32'h84200005; // r1=r0+5 
    cpu.mem[1] <= 32'h8440000f; // r2=r0+15
    cpu.mem[2] <= 32'h84600014; // 10001000011000000000000000010100
    cpu.mem[3] <= 32'h0ce77800; // 
    cpu.mem[4] <= 32'h0ce77800; // 
    cpu.mem[5] <= 32'h00811000; // 00000000100000010001000000000000
    cpu.mem[6] <= 32'h0ce77800; // 
    cpu.mem[7] <= 32'h0ce77800; // 
    cpu.mem[8] <= 32'h04a30800; // 00000100101000100000100000000000
    cpu.mem[9] <= 32'h0ce77800; // 
    cpu.mem[10] <= 32'h0ce77800; // 
    cpu.mem[11] <= 32'hfc000000;
    cpu.halted <= 0;
    cpu.pc <= 0;
    #500
    $display("r0 - %d",cpu.regb[0]);
    $display("r1 - %d",cpu.regb[1]);
    $display("r2 - %d",cpu.regb[2]);
    $display("r3 - %d",cpu.regb[3]);
    $display("r4 - %d",cpu.regb[4]);
    //$display("r5 - %d",cpu.regb[5]); 
    $finish;
    end
endmodule