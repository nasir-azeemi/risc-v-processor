
# Single-Threaded 5-Stage RISC-V Processor Implementation in Verilog

## Project Overview

This project represents the culmination of a semester-long journey in the Computer Architecture course, where a single-threaded 5-stage RISC-V processor was implemented in Verilog. The processor was constructed by meticulously building individual sub-components, progressing through the stages of instruction fetch, instruction decode, execute, memory access, and write-back.

## Project Structure

The project is organized into modular sub-components, each representing a stage in the pipeline. The main components include:

1.  **IF (Instruction Fetch):** Responsible for fetching instructions from memory.
2.  **ID (Instruction Decode):** Decodes the fetched instruction, extracting relevant information.
3.  **EX (Execute):** Performs arithmetic and logical operations based on the decoded instruction.
4.  **MEM (Memory Access):** Manages data memory access for load and store operations.
5.  **WB (Write-Back):** Writes the results back to registers.

Additionally, there are supporting modules such as register files, ALU (Arithmetic Logic Unit), and control unit, which contribute to the overall functionality of the processor.

## Development Progression

The development process followed a step-by-step approach, with each sub-component being implemented and tested individually before integrating into the complete processor. The progression through the stages allowed for a clear understanding of each module's functionality and facilitated debugging at each step.

## Testing and Verification

Extensive testing and verification procedures were employed to ensure the correctness and reliability of the processor. Testbenches were created for each module, and functional simulations were conducted to validate the behavior of the components.

## Dependencies

The project relies on Verilog for hardware description and simulation.
