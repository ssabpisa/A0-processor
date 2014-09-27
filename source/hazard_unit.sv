/*
   Hazard Unit
*/
`include "hazard_unit_if.vh"

module hazard_unit(
   hazard_unit_if.hzu hzif
);

  always_comb begin
     hzif.stall_ifid = 0;
     hzif.stall_idex = 0;
     hzif.stall_xmem = 0;
     hzif.stall_wb = 0;

     hzif.flush_ifid = hzif.dhit;
     hzif.flush_idex = 0;
     hzif.flush_xmem = 0;
     hzif.flush_wb = 0;

     hzif.pc_en = 1;

    if(hzif.jump || (hzif.branch && hzif.is_equal) || (hzif.branch_neq && !hzif.is_equal)) begin
       hzif.flush_ifid = 1;
     end
  end
  //TODO: handle case where SW occur
endmodule
