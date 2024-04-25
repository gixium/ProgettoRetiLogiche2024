# Logic Networks Final Project

This repository contains the **final project** for the a.a.2023/2024 **Logic Networks** course at **Polytechnic of Milan**. Achieving a **score of 28/30**, the project revolves around the seamless integration of my **VHDL hardware module with a RAM**.

> A shortcut to my implementation of the module is provided with the `solution.vhd` file, along with its report `report.pdf`.

## Problem Description

The module is responsible for completing a sequence starting from an `ADD` memory address given. The sequence consists of `K` pairs of `8-bit` elements each: the first element identifies the "word" `W` in input, while the second will be encoded in its "credibility value" `C`.

Words have a value ranging from `0` to `255`. The value `0` encodes "unspecified value" information; the module replaces all words with a value of `0` with the last read word of a different value from `0` (or with `0` if there have never been any).

Credibility values 𝐶 have a value ranging from `0` to `31` and are calculated by the module as follows:
- If the word has a specified value (i.e., is different from `0`), its credibility value will be the maximum, `31`.
- If the word does not have a specified value (i.e., if it is `0`), its credibility value will be equal to the credibility value of the previous word decremented by 1, unless this value is `0`, in which case it is not further decremented. If there is no previous word, the credibility value is set to `0`.

To derive a general operating rule, knowing the `ADD` address of the first word (provided at the beginning of computation), the $i$-th word $W_i$ of the sequence will be found at memory address $ADD + 2(𝑖 − 1)$, and its credibility value $C_i$ will follow at address $ADD + 2(𝑖 − 1) + 1$.

The module must be able to recognize an asynchronous reset signal `i_rst`, which can be received at any time. Each new computation starts with the arrival of a high `i_start` signal, which can be received only at the end of a previous processing and can (but not necessarily) be preceded by `i_rst` (it certainly is at the first computation). This `i_start` signal remains high while the module is active. At the end of processing, the module raises the `o_done` signal; then, as soon as it recognizes the lowering of `i_start`, it sets `o_done` low.

## Proposed Solution

For the synthesis of the module, the Xilinx Vivado software was used with an Artix-7 xc7a200tfbg484-1 FPGA target. We adopted the behavioral design paradigm. The component was implemented using a finite state machine (FSM) with 10 states, composed of 3 main processes to make the module structure more atomic and facilitate overall management: 
- `state_transition`: This process determines, based on the current state and control signals, the next state of the FSM.
- `output`: This process handles the module's outputs to the RAM. It manages communication phases with the memory (via `o_mem_en` and `o_mem_we`), provides processed word and credibility values complete with addresses (`o_mem_data` and `o_mem_addr`), and signals the end of a computation by raising `o_done`.
- `registers`: This process implements the internal registers of the module, updating values according to the current state (computation phase) and specific cases (not always saved values need updating).

So, summarizing, the component utilizes these three processes to: manage the FSM state, handle outputs with the RAM, and save/update values in registers.