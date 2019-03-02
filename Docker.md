# esp-rs docker

Rust compilation toolchain for ESP chips inside a Linux container.

## Create container

    docker build -t esp-rust .

Takes quite a while to compile.

## Use container to create a new project

Inside an empty folder for your project on your host machine:

    docker run -u builder -v "$PWD:/build" -w "/build" esp-rust /builder/build.sh

This runs the esp-rs build script inside your project folder mounted in the container at `/build`.

## Work interactively within the container on your project

Inside your project folder on your host machine:

    docker run -ti -u builder -v "$PWD:/build" -w "/build" esp-rust bash

## Pass an USB port into the container

    docker run --device /dev/ttyUSB0:/dev/ttyUSB0 ...

### Container inside virtual host

When running containers inside a virtual host, like on MacOS, you have to pass the associated USB device into the virtual host first. How you do it depends on your virtualization solution. On VirtualBox user interface I (korpiq) chose Settings, Ports, USB, enabled USB 2.0, and added my connected device as one.
