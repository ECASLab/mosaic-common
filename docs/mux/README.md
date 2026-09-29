# Parameterizable Multiplexer

`mux` is a zero-latency, combinational N-to-1 selector for datapath operands,
results, bypass paths, configuration words, predicates, and routing data. Legal
selections forward exactly one input. Invalid or unknown selections return the
configured default and deassert `o_select_valid`.

## Documentation

- [Interface specification](interface.md)
- [Verification plan](verification-plan.md)
- [Project configuration](project-configuration.md)
- [Power characterization](power-characterization.md)
- [Release checklist](release-checklist.md)
- [Reviewed waivers](waivers.md)

## Qualified configurations

The parameter matrix covers one, two, three, four, five, and eight inputs with
data widths from one to 128 bits. It includes power-of-two and non-power-of-two
input counts, nonzero default values, and the `NUM_INPUTS=1` boundary.

## Run locally

```sh
make MODULE=mux PROFILE=inputs_3_width_16 flow-config-check
make MODULE=mux clean all-profiles PROFILE_JOBS=4
make MODULE=mux PROFILE=inputs_3_width_16 FORCE_FLOW=1 open-coverage
```

Generated reports and work products are isolated below `reports/mux/` and
`work/mux/`.
