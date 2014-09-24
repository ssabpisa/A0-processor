`include "cpu_types_pkg.vh"
`include "pipereg_if.vh"

import cpu_types_pkg::*;

module pl_id_ex(
   input logic CLK, nRST,
   pipereg_id_ex.idex idex
);
   //WB control regs
   logic WB_MemToReg, WB_RegWrite;

   //MEM control regs (TODO: jump?)
   logic M_Branch, M_MemRead, M_MemWrite;

   //EX control signals
   logic [1:0] EX_RegDst, EX_ALUSrc, EX_ALUSrc2;
   aluop_t EX_ALUOp;

   word_t next_address;
   word_t rdat1;
   word_t rdat2;
   word_t sign_ext32;
   word_t rt;
   word_t rd;

   assign idex.WB_MemToReg_out = WB_MemToReg;
   assign idex.WB_RegWrite_out = WB_RegWrite;
   assign idex.M_Branch_out = M_Branch;
   assign idex.M_MemRead_out = M_MemRead;
   assign idex.M_MemWrite_out = M_MemWrite;
   assign idex.EX_RegDst_out = EX_RegDst;
   assign idex.EX_ALUOp_out = EX_ALUOp;
   assign idex.EX_ALUSrc_out = EX_ALUSrc;
   assign idex.next_address_out = next_address;
   assign idex.rdat1_out = rdat1;
   assign idex.rdat2_out = rdat2;
   assign idex.sign_ext32_out = sign_ext32;
   assign idex.rt_out = rt;
   assign idex.rd_out = rd;
   assign idex.EX_ALUSrc2_out = EX_ALUSrc2;

   //nothing to flush
   always_ff @(posedge CLK, negedge nRST) begin
      if(!nRST) begin
         WB_MemToReg <= '0;
         WB_RegWrite <= '0;
         M_Branch <= '0;
         M_MemRead <= '0;
         M_MemWrite <= '0;
         EX_RegDst <= '0;
         EX_ALUOp <= '0;
         EX_ALUSrc <= '0;
         EX_ALUSrc2 <= '0;
         next_address <= '0;
         rdat1 <= '0;
         rdat2 <= '0;
         sign_ext32 <= '0;
         rt <= '0;
         rd <= '0;
      end else if(idex.WEN == 1 && !idex.flush) begin
         WB_MemToReg <= idex.WB_MemToReg_in;
         WB_RegWrite <= idex.WB_RegWrite_in;
         M_Branch <= idex.M_Branch_in;
         M_MemRead <= idex.M_MemRead_in;
         M_MemWrite <= idex.M_MemWrite_in;
         EX_RegDst <= idex.EX_RegDst_in;
         EX_ALUOp <= idex.EX_ALUOp_in;
         EX_ALUSrc <= idex.EX_ALUSrc_in;
         EX_ALUSrc2 <= idex.EX_ALUSrc2_in;
         next_address <= idex.next_address_in;
         rdat1 <= idex.rdat1_in;
         rdat2 <= idex.rdat2_in;
         sign_ext32 <= idex.sign_ext32_in;
         rt <= idex.rt_in;
         rd <= idex.rd_in;
      end
  end

endmodule
