# A template for Sky130 digital flow with Padring Generation

This repository contains a template for a complete digital flow using the Sky130 PDK, including padring generation and (in the future) an openroad script to merge the padring with the core.

## Base examples contained

- `yosys padring` - Yosys padring generation flow (has flaws)
- `or_chip_io` - OpenROAD-based padring generation
- `ss_riscv` - Single-cycle RISCV (librelane-clean).
- `ue_riscv` - [Open-Source RISCV Core from UltraEmbedded](https://github.com/ultraembedded/riscv) which is librelane-clean.
- `sim_with_pad` - Sample files for simulation with a padring.
- `register_files` - Simple register file as a test core element.

## Other folders

- `doc` - pdf documentation
- `references` - files taken from other sky130 projects as implementation reference
- `.devcontainer` - files necessary to implement devcontainers

## Usage

### Run as devcontainer

[![Open in Dev Containers](https://img.shields.io/static/v1?label=Dev%20Containers&message=Open&color=blue)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/microsoft/vscode-remote-try-java)

To run as devcontainer, you need to have:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/MacOS) or
  [Docker Engine](https://docs.docker.com/engine/install/) (Linux) installed. 
- [VSCode](https://code.visualstudio.com/) installed with the 
  [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

Then, run 

```bash
git clone https://github.com/Lawrence-lugs/sky130-full-chip-template.git
cd sky130-full-chip-template
```

Then, copy one of the devcontainer templates into devcontainer.json

```bash
cp .devcontainer/devcontainer.windows.json .devcontainer/devcontainer.json # IF windows machine
cp .devcontainer/devcontainer.macos.json .devcontainer/devcontainer.json # IF macos or linux machine
```

Then, you can open this folder in VSCode and it will prompt you to reopen it in a container.

### Run as docker container

To run as docker, follow the steps below to activate [JKU's Open Source Tools Docker](https://github.com/iic-jku/IIC-OSIC-TOOLS).

1. Download [Docker Desktop](https://www.docker.com/products/docker-desktop/) for your OS
    1. A requirement for Docker is WSL2 on windows. Follow the instructions [here](https://learn.microsoft.com/en-us/windows/wsl/install) to setup WSL2.
2. Start Docker Desktop
1. Open a terminal
3. In that terminal, do `git clone --depth=1 https://github.com/iic-jku/iic-osic-tools.git`
    1. For windows users using powershell, if git is not found, run the following in the command prompt: `winget install --id Git.Git -e --source winget`
4. Change directory into the cloned directory: `cd iic-osic-tools`
5. Then, use `./start_x.sh`  (or `./start_x.bat`, if you’re on Windows)
    1. This part will take a while, as the PDKs and tools are downloaded.
6. You should now have a usable terminal with which you can call all the tools and follow the instructions.

Then, run 

```bash
git clone https://github.com/Lawrence-lugs/sky130-full-chip-template.git
cd sky130-full-chip-template
```

and you should have the base environment.

## Running the code

Each sample folder should either have its own README.md or its own Makefile.
Please either run `make` or following the instructions in `README.md`.
If an example has neither, please create an issue.

## Librelane Scripts Directory

If you need to inspect the scripts that Librelane uses internally, please see `/usr/local/lib/python3.12/dist-packages/librelane/scripts`

## TODO

- [x] Librelane-clean RISCV
- [x] OpenROAD Padring Generation
- [ ] Core + Padring
- [ ] Chip LVS
- [ ] Github Workflows