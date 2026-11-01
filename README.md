# Debounced Button-Controlled FSM

**Author: southpaw**

A four-state VHDL coursework design combining button debounce,
rising-edge detection and LED state indication.

## Interface

| Port | Meaning |
|---|---|
| clk | System clock; the testbench uses 100 MHz |
| sol_buton / sag_buton / merkez_buton | Active-high left / right / center button inputs |
| nRst | Active-low asynchronous FSM reset |
| led(2 downto 0) | 100: left, 001: right, 010: stopped/start |

The output encodes logical states. A motor driver is not implemented.

## Design

The top-level entity is main_program, with states basla, sola_don,
saga_don and dur. A fixed 1,000,000-cycle counter threshold filters each
button input, approximately 10 ms at the testbench clock plus pipeline latency.
Transitions use rising edges of the filtered button signals.

## Files

| File | Purpose |
|---|---|
| [debounced_fsm_controller.vhd](debounced_fsm_controller.vhd) | RTL implementation |
| [debounced_fsm_controller_TB.vhd](debounced_fsm_controller_TB.vhd) | Assertion-based testbench |

## Verification status and limits

The testbench contains bounce and state-transition scenarios. Its held-button
scenario needs correction because it releases and presses the button again
before expecting no transition. A newly passing simulation is not claimed.
No tests or simulation were run for this documentation update.

In the current RTL, reset applies to the FSM but not the debounce counters or
edge history. Asynchronous buttons are sampled directly; hardware integration
needs an input-synchronization review. Board constraints and physical FPGA
validation are not supplied.

## Authorship and licensing

Coursework implementation: **southpaw**.
A project license has not yet been selected.
