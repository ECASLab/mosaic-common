# Parameterizable D Flip-Flop

`mosaic_dff` is a parameterizable bank of rising-edge D flip-flops with an
active-low reset, optional enable behavior, configurable synchronous or
asynchronous reset, and a configurable reset value.

The authoritative interface is documented in
[`docs/dff/interface.md`](docs/dff/interface.md).
The verification matrix and evidence requirements are documented in
[`docs/dff/verification-plan.md`](docs/dff/verification-plan.md).

## Run the open-source flow

Initialize the pinned methodology and run the quality gate from the repository
root:

```sh
git submodule update --init --recursive
make flow-config-check
make clean open-source
```

`MODULE=dff` is the default. Every registered module has a lightweight profile
under `config/modules/` while RTL, verification, file lists, and flow inputs stay
in the template's root directories. Run all registered modules concurrently with:

```sh
make all-modules
make all-modules TARGET=open-sim
```

Set `JOBS` to limit concurrency. The default uses all available parallel slots.
Generated evidence and work products are isolated under `reports/<module>/` and
`work/<module>/`.

To register another module, add its RTL and verification sources to the existing
root directories, give it dedicated file lists and flow inputs, add
`config/modules/<name>.mk` and `config/modules/<name>-flows.mk`, then append its
name to `.github/modules.json`. The local `all-modules` target and GitHub Actions
matrix will include it automatically.

The open-source gate runs Verible lint and formatting, Slang elaboration,
Verilator lint and simulation, Yosys synthesis, SymbiYosys formal verification,
and EQY equivalence. Run `make open-physical` separately when an approved
OpenROAD Flow Scripts checkout and platform are available.

## Commercial qualification

Run commercial checks only in an authorized environment with the required site
variables and licenses:

```sh
make synopsys-check-env
make synopsys-all
```

VC Lint, VC CDC or SpyGlass CDC, SpyGlass DFT, VC LP, Design Compiler,
PrimeTime, and PrimePower evidence remains required by the release checklist.
