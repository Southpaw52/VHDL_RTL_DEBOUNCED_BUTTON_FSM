# Debounced Button-Controlled FSM (VHDL RTL)

This project implements a debounced button-controlled Finite State Machine (FSM) in VHDL at RTL level for reliable state transitions under mechanical push-button inputs.

## 🔧 Features
- 4-State Sequential FSM (basla, sola_don, saga_don, dur)
- Rising-edge detection for push-button inputs
- Digital debounce filtering
- Active-low reset (nRst)
- RTL-level hardware description

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

## 🧪 Verification
A dedicated VHDL testbench was developed to functionally verify FSM behavior.

The verification process includes:
- Simulation of mechanical button bounce effects
- Debounce duration validation
- Rising-edge triggered state transition checks
- LED output validation for each FSM state

Assertions are used within the testbench to detect unexpected transitions during simulation.

## 📂 Project Files

| File Name                      | Description                          |
|--------------------------------|--------------------------------------|
| debounced_fsm_controller.vhd   | RTL FSM implementation               |
| main_program_tb.vhd            | Testbench for functional verification|

---

Developed as part of FPGA-Based Digital Design coursework.
