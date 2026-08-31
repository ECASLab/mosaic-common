# Verification plan

[Return to the module documentation index](README.md).

| Requirement | Evidence |
|---|---|
| Widths 1, 2, 4, 8, 16, 32, and 64 | Parameterized Verilator regression |
| Active-high and active-low control | Paired checker instances and formal proof |
| Zero, one, and mixed clamps | Directed and randomized regression |
| Pass-through and clamp equations | Bound assertions and SymbiYosys proof |
| No data influence while isolated | Directed activity and formal assertion |
| Walking, alternating, boundary, and random data | Self-checking simulation |
| Conservative X/Z data and control semantics | Icarus four-state campaign |
| RTL-to-generic-netlist equivalence | EQY |
| Verification sensitivity | Four functional mutations and inequivalent netlist |
| Timing and portable power intent | Executable Tcl checks over SDC and UPF |

Technology-bound integration must additionally cover shutdown and wakeup
sequences, every legal power state, source corruption while off, protocol safety,
inserted-cell coverage, always-on connectivity, combined level shifting when
required, power-aware simulation, VC LP, DFT, timing, and physical checks.
