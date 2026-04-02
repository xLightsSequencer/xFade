# xFade

xFade is a DMX crossfader for lighting control. It receives E1.31 (sACN) and Art-Net streams from two sources and crossfades between them, outputting the blended result. It supports MIDI control for hands-free operation during live performances.

xFade is part of the [xLights](https://github.com/xLightsSequencer/xLights) family of tools for holiday and entertainment lighting.

## Features

- Receive and crossfade between two E1.31 (sACN) or Art-Net DMX sources
- Output blended DMX via E1.31 or Art-Net
- MIDI controller support for crossfader and button mapping
- Per-universe fade exclusion (keep specific universes on one source)
- Configurable universe mapping
- Visual LED indicators for signal activity

## Building

### Linux

```bash
# Install dependencies (Ubuntu/Debian)
sudo apt-get install g++ build-essential libgtk-3-dev libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev freeglut3-dev libcurl4-openssl-dev \
    libexpat1-dev libwebp-dev libportmidi-dev cbp2make

# Build (downloads wxWidgets automatically if not installed)
make -j$(nproc)

# Install
sudo make install
```

### Windows

1. Clone [wxWidgets](https://github.com/xLightsSequencer/wxWidgets) (branch `xlights_2026.04`) as a sibling directory
2. Build wxWidgets with Visual Studio 2022
3. Open `xFade/xFade.sln` in Visual Studio 2022
4. Build Release x64

Or use the build script:
```cmd
cd build_scripts\msw
call build_xFade_x64.cmd
```

## License

xFade is licensed under the [GNU General Public License v3.0](LICENSE).
