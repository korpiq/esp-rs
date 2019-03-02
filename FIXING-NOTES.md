# Temporary notes on fixing this build system

I'm on MacOS with Docker + docker-machine + VirtualBox.
I'm trying to compile and upload the included BLINK project to Wemos D1 mini Pro.

`build.sh` finishes fine for the default target board `nodemcuv2`.

I've exposed the USB device as described in Docker.md.

I'm trying to upload to my device:

    pio run --target upload
    ...
    error: cannot access /dev/ttyUSB0

I'm in now as my `builder` user, so can't become root (great!).
So from host I allow my user to access it on the running container:

    docker exec -u root 79386c0f0ce9 chgrp build /dev/ttyUSB0

## Miscellaneous side tracks

Trying to create from scratch by overriding the board:

    pio init -b d1_mini_pro
    pio run -t clean

Fails withi missing eagle. If I run

    /builder/build.sh

Then I'm missing some `eagle*.ld` from my `.pioenvs`.

These may have affected something but not the build results:

    pio settings set auto_update_libraries yes
    pio settings set auto_update_platforms yes

I replaced both references to `nodemcuv2` from `build.sh` with `$BOARD`.
Ran on empty directory with `BOARD=d1_mini_pro`.

    Error: Could not find 'eagle.flash.16m.ld' LD script in LDPATH '/dummy/.pioenvs/d1_mini_pro .esp-rs-compiled-lib -llibgenerated /dummy/.pioenvs/d1_mini_pro/ld /build/.platformio/packages/framework-arduinoespressif8266/tools/sdk/lib /build/.platformio/packages/framework-arduinoespressif8266/tools/sdk/ld /build/.platformio/packages/framework-arduinoespressif8266/tools/sdk/libc/xtensa-lx106-elf/lib'

[That script seems to be downloadable.](https://github.com/gbrault/esp8266-Arduino/blob/master/tools/sdk/ld/eagle.flash.16m.ld)

    (
        cd /build/.platformio/packages/framework-arduinoespressif8266/tools/sdk/ld/
        curl -O https://raw.githubusercontent.com/gbrault/esp8266-Arduino/master/tools/sdk/ld/eagle.flash.16m.ld
        curl -O https://raw.githubusercontent.com/gbrault/esp8266-Arduino/master/tools/sdk/ld/eagle.app.v6.common.ld
    )

That fixed that.

    Linking .pioenvs/d1_mini_pro/firmware.elf
    /build/.platformio/packages/toolchain-xtensa/bin/../lib/gcc/xtensa-lx106-elf/4.8.2/../../../../xtensa-lx106-elf/bin/ld:
        .pioenvs/d1_mini_pro/firmware.elf section `.text' will not fit in region `iram1_0_seg'
    .pioenvs/d1_mini_pro/libFrameworkArduino.a(core_esp8266_main.cpp.o):(.text._Z9init_donev+0x8):
        undefined reference to `__eh_frame'
    collect2: error: ld returned 1 exit status
