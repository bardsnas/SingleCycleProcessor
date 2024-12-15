# SingleCycleProcessor Details:
### DE1_SoC.sv: Top-Level module that instantiates the datapath and control logic driving the functionality of the single cycle processor.
### cntrl_main.sv: Handles the control logic signals that pass into the datapath to manage the unique set of operations capable by the processor.
### datapath.sv: Contains all the necessary components needed to read a RegFile and output its data into an ALU execution and writeback to the RegFile.
### PC_datapth.sv: Updates the Program Counter (PC) based on the BrTaken and UncondBr signals coming from cntrl_main. Can handle Branch operations in ARM Assembly code.
### instructmem.sv: Outputs a new instruction line to the datapth based on the PC value each cycle.
### math.sv: datapath.sv borrows the shift and mult functionality in order to handle LSL/LSR and MUL ARM Assembly operations.
### datamem.sv: Handles the Memory aspect of the processor. Necessary for LDUR/STUR operations in ARM Assembly.
### sign_extend.sv: Extends instruction bits to 64-bit values necesssary for computation by the ALU.
### flag_reg.sv: Stores the flags outputted by the ALU so they are available to be read by the PC_datapth each cycle.
