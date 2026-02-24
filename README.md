
# Nios II Bare-Metal Hardware-Software Interface

## Overview
This repository demonstrates a low-level, bare-metal implementation of a recursive spatial distance algorithm, written in both **C** and **Nios II Assembly**. The project was deployed and tested on a real **Altera DE2 FPGA**, showcasing direct Hardware-Software interaction without an underlying operating system.

The algorithm calculates the squared distance between two coordinates $(x_1,y_1)$ and $(x_2,y_2)$, and recursively determines how many segments of length $L=1$ fit within that distance.

## Hardware-Software Interface (MMIO)
A core focus of this project is driving external hardware peripherals-specifically, a 7-Segment display-using **Memory-Mapped I/O (MMIO)**. 

Since the 7-segment display is an I/O peripheral and not standard memory, it is mapped to a specific hardware address (`0x10000020`). Writing to this address directly alters the hardware state. However, standard memory operations can be cached by the CPU, which would prevent real-time hardware updates. 

To solve this and ensure immediate hardware response, **Cache Bypassing** techniques were implemented:
* **In Nios II Assembly:** Utilized the `stwio` (Store Word I/O) instruction instead of the standard `stw`. This forces the processor to bypass the data cache and write the data directly to the peripheral's register.
* **In C:** Defined the peripheral address using a `volatile` pointer (`#define SEVEN_SEG ((volatile unsigned int *)0x10000020)`). The `volatile` keyword instructs the compiler to prevent optimizations and ensures every write operation hits the physical hardware immediately.

## Data Encoding
The 7-segment display does not accept standard decimal integers. Therefore, a custom hex-encoding array was implemented in both C and Assembly to translate integer values into the correct bit-patterns required to illuminate the corresponding LEDs on the display (e.g., `0x6D` to display the digit '5').

## Project Files
* `distance_calc.c` - High-level implementation featuring recursive logic and `volatile` pointers for MMIO.
* `distance_calc.s` - Low-level Nios II Assembly implementation featuring manual stack management (`sp`, `ra`) for recursion and `stwio` for direct hardware control.

## Execution on Real Hardware (FPGA)
Below are captures from the FPGA execution, demonstrating the CPU registers, memory state, and the physical 7-segment display successfully outputting the calculated result:

<img width="560" height="113" alt="image" src="https://github.com/user-attachments/assets/5ef2c7d2-3ce5-4121-a9cf-65b71db30b87" />



