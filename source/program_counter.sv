/*

  Pat Suppatach Sabpisal
  ssabpisa@purdue.edu

  this block is the program counter
  and its next pc logic

*/
`include "pc_if.vh"
`include "cpu_types_pkg.vh"

module program_counter (
   input CLK, nRST,
   pc_if.pc pcif
);

   //TODO: make interface for pc
   import cpu_types_pkg::*;
   word_t PC_next, PC_next_filtered;
   word_t PC;
   word_t pc_4;

   assign pc_4 = PC + 4;

   parameter PC_INIT = 0;

   assign pcif.imemaddr = PC;
   assign pcif.pc_plus_4 = pc_4;
   //Resolved: ----------- Increase on ihit: otherwise
   //Resolved: ----------- Increase on dhit: ctr_dWEN | ctr_dREN

   //TODO: move all these outside

   always_ff @ (posedge CLK, negedge nRST) begin
      if(!nRST) begin
        PC_next_filtered <= 0;
      end else begin
        PC_next_filtered <= PC_next;
      end
   end

   always_comb begin : PC_ns_logic
        PC_next = PC + 4;
        casez (pcif.PCSrc)
              0: begin
                 //JR
                 PC_next = pcif.rdat1; // (JR) Let $rs go to rsel1
              end
              1: begin
                 //J or JAL
                 //Resolved: put in $31 for JAL
                 PC_next = { pc_4[31:28] , pcif.immediate26, 2'b0 };
              end
              2: begin
                 //BEQ/BNE
                 if(pcif.immediate[15] == 0) begin
                    PC_next = (PC + 0) + {14'b0, pcif.immediate, 2'b0}; //TODO : ask pranav
                  end else begin
                    PC_next = (PC + 0) + {14'h3fff, pcif.immediate, 2'b0}; //TODO : ask pranav
                    //PC_next = PC + $signed({pcif.immediate, 2'b0});
                  end
              end
              default: PC_next = PC + 4;
          endcase
   end

   always_ff @ (posedge CLK, negedge nRST) begin : PC_update_logic
    if(!nRST) begin
      PC <= PC_INIT;
    end else if (pcif.pc_en) begin
      PC <= (pcif.bubble == 1 ? PC_next_filtered : PC_next);
    end else begin
      PC <= PC;
    end
  end
endmodule
