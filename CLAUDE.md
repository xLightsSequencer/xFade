# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

xFade is a DMX crossfader for lighting control. It receives E1.31 (sACN) and Art-Net streams from two sources and crossfades between them, outputting the blended result. It supports MIDI control for hands-free operation during live performances.

Built on wxWidgets 3.3 (custom fork).

**Supported platforms:** Linux (Debian 12 / Ubuntu 24.04), Windows 10+.

## Build Commands

### Linux
```bash
make                          # Full build (wxWidgets + xFade)
make debug                    # Debug build
make clean                    # Clean all
# Output binary goes to bin/
```

Build uses Code::Blocks .cbp project files converted to makefiles via cbp2make. Object files go to `.objs_debug/` or `.objs_release/`.

### Windows
Open `xFade/xFade.sln` in Visual Studio 2022 and build Release x64. wxWidgets must be cloned as a sibling directory (`../../wxWidgets/`).

Or use the build script:
```cmd
cd build_scripts\msw
call build_xFade_x64.cmd
```

### wxSmith Generated Code
Some dialogs use wxSmith (wxWidgets RAD tool). Generated code is delimited by `//(* ... //*)` guards in `.cpp`/`.h` files. **Any changes within these guards MUST also be reflected in the corresponding `.wxs` file** in `xFade/wxsmith/` or `shared/wxsmith/`. Otherwise the changes will be overwritten the next time the `.wxs` file is opened in wxSmith.

wxSmith files in this repo:
- `xFade/wxsmith/xFadeframe.wxs`
- `xFade/wxsmith/FadeExcludeDialog.wxs`
- `xFade/wxsmith/MIDIAssociateDialog.wxs`
- `xFade/wxsmith/SettingsDialog.wxs`
- `xFade/wxsmith/UniverseEntryDialog.wxs`
- `shared/wxsmith/IPEntryDialog.wxs`

### Adding New Source Files
When adding new `.cpp`/`.h` files, the following project files must be updated manually:
- **`xFade/xFade.cbp`** — add `<Unit filename="...">` entries (used by Linux build via cbp2make)
- **`xFade/xFade.vcxproj`** — add `<ClCompile>` for `.cpp` and `<ClInclude>` for `.h`
- **`xFade/xFade.vcxproj.filters`** — add corresponding filter entries

## Repository Structure

- **`xFade/`** — application source files, build project files, wxSmith UI definitions
- **`shared/`** — shared utility code (originally from xLights, trimmed to what xFade needs)
  - `shared/xFadeVersion.h/.cpp` — version constants (`xfade_version_string`, etc.)
  - `shared/utils/` — `UtilFunctions`, `ip_utils`, `string_utils`, `ExternalHooks.h`
  - `shared/ui/` — `wxUtilities`, `IPEntryDialog`, `xFadeTimer`
- **`common/`** — base application framework (`xFadeBaseApp`, crash handling)
- **`json/wxJSON/`** — JSON parsing library
- **`midi/wxMIDI/`** — wxWidgets MIDI wrapper (PortMIDI interface)
- **`include/`** — shared headers (globals.h, log.h), icon assets (.xpm), nlohmann/json
- **`dependencies/`** — pugixml (submodule), spdlog (submodule), stb image headers

## Threading

xFade uses wxThread for concurrent operation:
- `ArtNETReceiverThread` — receives Art-Net packets (joinable thread)
- `E131ReceiverThread` — receives E1.31/sACN packets (joinable thread)
- `EmitterThread` — outputs blended DMX data (joinable thread)
- `ListenerThread` — MIDI input listener

Synchronization uses `std::mutex`. Do not call wxWidgets UI functions from background threads.

## Code Style

- C++20 with GNU extensions (`-std=gnu++20`)
- 4-space indentation, no tabs
- No column limit (ColumnLimit: 0)
- Opening braces on same line (K&R style)

- **Strings**: Use `std::string` instead of `wxString`. Convert at wx API boundaries with `.ToStdString()` / `wxString(str)`.
- **Collections**: Use `std::vector`, `std::map`, etc. instead of `wxArrayString`, `wxList`, etc.
- **Exceptions**: Do NOT use `std::stoi`, `std::stol`, `std::stod` — they throw on invalid input. Use `std::strtol`, `std::strtod` instead.
- **File existence checks**: Use `FileExists()` from `ExternalHooks.h` instead of `std::filesystem::exists()`.

## Key Dependencies

wxWidgets 3.3 (custom fork `xLightsSequencer/wxWidgets`, branch `xlights_2026.04`), spdlog, pugixml, nlohmann/json, PortMIDI.
