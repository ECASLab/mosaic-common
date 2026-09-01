# Verification plan

[Return to the module documentation index](README.md).

| Requirement | Current evidence |
|---|---|
| Widths 1, 8, 16, 32, 64, and 128 | Parameterized Verilator regression |
| Synchronous and asynchronous reset | Paired structural configurations |
| Enable present and absent | Parameterized regression |
| Save pre-edge visible state | Reference-model checks |
| Data changes cannot overwrite saved image | Save, update, restore sequences |
| Restore most recent saved value | Repeated randomized power-cycle model |
| Control priority | Directed reset, restore, save, update, and hold cases |
| Assertion antecedents | Named reset, save, restore, update, and hold coverpoints |
| RTL line and toggle coverage | Verilator coverage, excluding only the structurally unreachable `HAS_ENABLE` alternatives on RTL lines 36 and 49 |
| Illegal simultaneous save and restore | Icarus negative test with protocol assertion |
| Unknown reset and control inputs | Four-state Icarus campaign for reset, enable, save, and restore |
| SDC and UPF consistency | Executable Tcl review of clocks, interface delays, asynchronous reset, supplies, states, and retention controls |
| RTL-to-generic-netlist equivalence | EQY |
| Bounded formal model agreement | SymbiYosys BMC for 12 cycles |

Pending qualification includes inductive transition proofs, invalid-parameter
elaboration tests, power-aware supply-loss simulation, and
technology-bound retention insertion evidence.
