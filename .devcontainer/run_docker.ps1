docker build -t sky130-full-chip-image .devcontainer

$folderName = Split-Path -Path ${PWD} -Leaf

docker run -it `
  --device=/dev/dxg `
  --user 1000:1000 `
  -e DISPLAY=:0 `
  -e WAYLAND_DISPLAY=wayland-0 `
  -e XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir `
  -e PULSE_SERVER=/mnt/wslg/PulseServer `
  -e SHELL=/bin/bash `
  -v /run/desktop/mnt/host/wslg/.X11-unix:/tmp/.X11-unix `
  -v /run/desktop/mnt/host/wslg:/mnt/wslg `
  -v /usr/lib/wsl:/usr/lib/wsl `
  -v "${PWD}:/workspaces/$folderName" `
  sky130-full-chip-image