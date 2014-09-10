/*
  Eric Villasenor
  evillase@gmail.com

  Pat Suppatach Sabpisal
  ssabpisa@purdue.edu

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;
  parameter CPUID = 0;

 /*
    ccif <- dREN = cache data read enable
    ccif <- dWEN = cache data write enable
    ccif <- iREN = cache instruction read enable
    ccif <- dstore = cache data store ??
    ccif <- iaddr = cache instruction address
    ccif <- daddr = data instruction address

    ccif <- ramload = ram load
    ccif <- ramstate = ram state
    ...
*/

//Load cache into ram
assign ccif.iload[CPUID] = ccif.ramload;
assign ccif.dload[CPUID] = ccif.ramload;
assign ccif.ramstore[CPUID] = ccif.dstore;

always_comb begin : control_operations
    ccif.iwait = 2'b0;
    ccif.dwait = 2'b0;
    casez (ccif.ramstate)
      FREE: begin
        //the memory is free for both I and D
        ccif.iwait[CPUID] = 1'b0;
        ccif.dwait[CPUID] = 1'b0;
      end
      ACCESS: begin
        // memory is begin accessed
        // data is prioritized
        // if data is begin read or written
        // Instruction Fetch will wait

        ccif.iwait[CPUID] = ccif.dREN | ccif.dWEN;
      end
      BUSY: begin
        //memory is being read
        ccif.iwait[CPUID] = 1'b1;
        ccif.dwait[CPUID] = 1'b1;
      end
      ERROR: begin
        //block all operations
        ccif.iwait[CPUID] = 1'b1;
        ccif.dwait[CPUID] = 1'b1;
      end
      default: begin
        ccif.iwait[CPUID] = 1'b0;
        ccif.dwait[CPUID] = 1'b0;
      end
   endcase
end

always_comb begin : RAM_control_mux
    ccif.ramREN = 1'b0;
    ccif.ramaddr = 32'b0;
    //Prioritizes the data
    if(ccif.dREN) begin
      //if cache wants to read from RAM (data)
      ccif.ramREN = 1'b1;
      ccif.ramaddr = ccif.daddr;
    end else if (ccif.dWEN) begin
     //if cache wants to write to RAM (data)
      ccif.ramWEN = 1'b1;
      ccif.ramaddr = ccif.daddr;
    end else if (ccif.iREN) begin
     //if cache wants to read Instruction from RAM
      ccif.ramREN = 1'b1;
      ccif.ramaddr = ccif.daddr;
    end
end

endmodule
