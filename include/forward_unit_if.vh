`ifndef FW_IF_VH
`define FW_IF_VH
`include "cpu_types_pkg.vh"

interface forward_unit_if;
  logic [4:0] ex_rs, ex_rt;
  logic [4:0] mem_rd, wb_rd;
  /* forwardA is the control signal choose which operand to feed in
  for alu operand A
   */
  logic [1:0] forwardA;
  /* forwardB is the control signal choose which operand to feed in
  for alu operand B
   */
  logic [1:0] forwardB;

  modport fwu(
    input ex_rs, ex_rt, mem_rd, wb_rd,
    output forwardA, forwardB
  );
endinterface
`endif


