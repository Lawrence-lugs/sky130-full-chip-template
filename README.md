# A template for Sky130 digital flow with Padring Generation

This repository contains a template for a complete digital flow using the Sky130 PDK, including padring generation and (in the future) an openroad script to merge the padring with the core.

## Base examples contained

- A simple padring generation example in the `padring` directory.
- A simple single-cycle RISCV core synthesis to GDS flow in the `ss_riscv` directory.

## Usage

### Run as devcontainer

To run as devcontainer, you need to have:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/MacOS) or
  [Docker Engine](https://docs.docker.com/engine/install/) (Linux) installed. 
- [VSCode](https://code.visualstudio.com/) installed with the 
  [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

Then, run 

```bash
git clone https://github.com/Lawrence-lugs/sky130-full-chip-template.git
```

Then, you can open this folder in VSCode and it will prompt you to reopen it in a container.

### Run as docker container

To run as docker, follow the steps below to activate [JKU's Open Source Tools Docker](https://github.com/iic-jku/IIC-OSIC-TOOLS).

1. Download [Docker Desktop](https://www.docker.com/products/docker-desktop/) for your OS
    1. A requirement for Docker is WSL2 on windows. Follow the instructions [here](https://learn.microsoft.com/en-us/windows/wsl/install) to setup WSL2.
2. Start Docker Desktop
1. Open the terminal inside docker
3. In that `git clone --depth=1 https://github.com/iic-jku/iic-osic-tools.git`
    1. For windows users, if git is not found, run the following in the command prompt: `winget install --id Git.Git -e --source winget`
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

To run the existing codes, cd into the respective directories and run the make commands. For example, to run the padring generation code, do:

```bash
cd padring
make
```

This will generate the padring layout in `padring.gds`.

To run the single-cycle RISCV RTL-to-GDS flow with librelane, do:

```bash
cd ss_riscv
make
```

## TODO

- [ ] Top level make
- [ ] RISCV + Padring
- [ ] Librelane-clean RISCV
- [ ] Devcontainer workflow
- [ ] Make workflow