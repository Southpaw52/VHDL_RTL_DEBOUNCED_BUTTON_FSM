# Debounced Button-Controlled FSM (VHDL RTL)

This project implements a debounced button-controlled Finite State Machine (FSM) in VHDL at RTL level.

## 🔧 Features
- 4-State Sequential FSM (basla, sola_don, saga_don, dur)
- Rising-Edge Detection for mechanical push-buttons
- Digital Debounce Filtering
- Active-Low Reset (nRst)
- RTL-Level Hardware Description

## 📥 Inputs
- clk (100 MHz)
- sol_buton
- sag_buton
- merkez_buton
- nRst

## 📤 Outputs
- led(2): Motor rotates left
- led(1): Motor stop
- led(0): Motor rotates right

## 🛠️ Design Considerations
- State transitions occur only on button rising edge
- Button bounce is filtered using digital debounce logic
- Prevents multiple unintended state transitions

## 🧪 Verification
RTL design verified using VHDL testbench simulation.

---

Developed for FPGA-Based Digital Design coursework.
