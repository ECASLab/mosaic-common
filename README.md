# MOSAIC Common RTL Modules

`mosaic-common` contains reusable, technology-independent RTL primitives shared
by MOSAIC and other hardware projects. Each module owns its RTL, verification,
flow configuration, documentation, and release evidence while using the common
repository infrastructure and pinned [`mosaic-flow`](mosaic-flow) methodology.

## Modules

| Module | Description | Documentation |
| --- | --- | --- |
| `dff` | Parameterizable D flip-flop bank with configurable reset and enable behavior | [`docs/dff/`](docs/dff/) |
| `counter` | Parameterizable saturating or wrapping up/down counter | [`docs/counter/`](docs/counter/) |
| `clock_gate` | Glitch-free functional and test clock-gating wrapper | [`docs/clock_gate/`](docs/clock_gate/) |
| `reset_synchronizer` | Asynchronous-assertion, synchronous-release reset synchronizer | [`docs/reset_synchronizer/`](docs/reset_synchronizer/) |

The authoritative module list used by local automation and the GitHub Actions
matrix is [`.github/modules.json`](.github/modules.json).

## Repository structure

- `rtl/` contains synthesizable module implementations.
- `verif/` contains testbenches, assertions, formal harnesses, static checks,
  coverage campaigns, and fault-injection assets.
- `filelists/` defines the sources consumed by each flow.
- `config/modules/` defines each module's tops, paths, and required-flow policy.
- `flows/` contains module-owned constraints and tool adapter inputs.
- `docs/<module>/` contains module-specific interfaces, verification plans,
  waivers, and release checklists.
- `reports/<module>/` and `work/<module>/` contain generated evidence and build
  products and are not source directories.

See [`docs/creating-a-module.md`](docs/creating-a-module.md) for the registration
procedure and [`docs/repository-structure.md`](docs/repository-structure.md) for
the complete layout.

## Run a module

Initialize the pinned methodology, select a registered module, and run its
portable acceptance gate from the repository root:

```sh
git submodule update --init --recursive
make MODULE=dff flow-config-check
make MODULE=dff clean open-source
```

Module-specific targets may extend the portable gate. Consult the selected
module's documentation and list available targets with:

```sh
make help
```

After all required module-specific gates pass, generate the validated evidence
index with:

```sh
make MODULE=dff release-manifest
```

The manifest is written under `reports/<module>/release_manifest/` and is
included in the native and containerized GitHub Actions artifacts.

The open-source infrastructure supports Verible formatting and lint, Slang
elaboration, Verilator lint and simulation, Yosys synthesis, SymbiYosys formal
verification, and EQY equivalence. Each module's reviewed flow policy determines
which checks are required or disabled.

## Run all modules

Run the default target for every registered module concurrently with:

```sh
make all-modules
make all-modules TARGET=open-sim
```

Set `JOBS` to limit concurrency. Reports and work products remain isolated under
their module-specific directories so parallel jobs do not overwrite one another.
GitHub Actions reads the same module manifest and runs native and containerized
checks for each matrix entry.

## Add a module

Add the module's RTL and verification sources to the shared root directories,
then provide dedicated file lists, flow inputs, documentation, and these two
profiles:

```text
config/modules/<name>.mk
config/modules/<name>-flows.mk
```

Append the module name to [`.github/modules.json`](.github/modules.json). The
local `all-modules` target and GitHub Actions matrix will then discover it.

## Commercial qualification

Licensed adapters are available for projects whose reviewed module policy
requires commercial evidence:

```sh
make MODULE=<name> synopsys-check-env
make MODULE=<name> synopsys-all
```

Run them only in an authorized environment with the required tools, libraries,
site variables, and licenses. Disabled adapters record an approved `SKIP` and do
not block a module's portable acceptance gate.
