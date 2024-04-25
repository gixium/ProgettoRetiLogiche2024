# Logic Networks Final Project

This repository contains the **final project** for the a.a.2023/2024 **Logic Networks** course at **Polytechnic of Milan**. Achieving a **score of 28/30**, the project revolves around the seamless integration of my **VHDL hardware module with a RAM**.

> A shortcut to my implementation of the module is provided with the `solution.vhd` file, along with its report `report.pdf`.

## Problem Description

![module](/docs/report/img/module.png)

The module is responsible for completing a sequence starting from an $ADD$ memory address given. The sequence consists of `K` pairs of `8-bit` elements each: the first element identifies the "word" $W$ in input, while the second will be encoded in its "credibility value" $C$.

Words have a value ranging from `0` to `255`. The value `0` encodes "unspecified value" information; the module replaces all words with a value of `0` with the last read word of a different value from `0` (or with `0` if there have never been any).

Credibility values $C$ have a value ranging from `0` to `31` and are calculated by the module as follows:
- If the word has a specified value (i.e., is different from `0`), its credibility value will be the maximum, `31`.
- If the word does not have a specified value (i.e., if it is `0`), its credibility value will be equal to the credibility value of the previous word decremented by 1, unless this value is `0`, in which case it is not further decremented. If there is no previous word, the credibility value is set to `0`.

To derive a general operating rule, knowing the $ADD$ address of the first word (provided at the beginning of computation), the $i$-th word $W_i$ of the sequence will be found at memory address $ADD + 2(𝑖 − 1)$, and its credibility value $C_i$ will follow at address $ADD + 2(𝑖 − 1) + 1$.

The module must be able to recognize an asynchronous reset signal `i_rst`, which can be received at any time. Each new computation starts with the arrival of a high `i_start` signal, which can be received only at the end of a previous processing and can (but not necessarily) be preceded by `i_rst` (it certainly is at the first computation). This `i_start` signal remains high while the module is active. At the end of processing, the module raises the `o_done` signal; then, as soon as it recognizes the lowering of `i_start`, it sets `o_done` low.

## Proposed Solution

For the synthesis of the module, the Xilinx Vivado software was used with an Artix-7 xc7a200tfbg484-1 FPGA target. We adopted the behavioral design paradigm. The component was implemented using a finite state machine (FSM) with 10 states, composed of 3 main processes to make the module structure more atomic and facilitate overall management.

### FSM Structure

![fsm](/docs/report/img/fsm.png)

The finite state machine is composed of 10 states, which are:
- reset: state in which the module is located, following the asynchronous reset signal, where all signals are set to zero. This state can be reached from any other state at any point during computation;
- start: state in which, after reading the sequence length and its initial address, the counters are initialized. The FSM enters this state following a high `i_start` signal;
- check: state in which the module verifies if there are still words to process. We have decided to insert it immediately after start to handle the case where the sequence is empty (length `i_k` equal to zero);
- read_w: state in which the module requests the word to be read from the RAM;
- wait_w: state in which the module waits for the requested word to be available;
- write_w: state in which the module sets the credibility value and overwrites, if necessary, the value of an unspecified word. The address of the word in question is also provided;
- write_c: state in which the module writes the credibility value. The address of the credibility value in question is also provided;
- next_add: state in which the module updates the saved memory address and decrements the remaining word counter;
- done: state in which the module signals the end of computation by raising `o_done`. The FSM enters this state only when there are no other words to process;
- idle: state in which the module lowers `o_done` and waits for a new high `i_start` signal to start a new computation (at which point the FSM goes to the start state). This state is entered only when `i_start` is lowered.

### Processes Structure

The module is made of 3 processes, which are:
- `state_transition`: This process determines, based on the current state and control signals, the next state of the FSM.
- `output`: This process handles the module's outputs to the RAM. It manages communication phases with the memory (via `o_mem_en` and `o_mem_we`), provides processed word and credibility values complete with addresses (`o_mem_data` and `o_mem_addr`), and signals the end of a computation by raising `o_done`.
- `registers`: This process implements the internal registers of the module, updating values according to the current state (computation phase) and specific cases (not always saved values need updating).

So, summarizing, the component utilizes these 3 processes to: manage the FSM state, handle outputs with the RAM, save/update values in registers.

### Components used and Timing

![report_components](/docs/report/img/report_components.png)
![report_timing](/docs/report/img/report_timing.png)