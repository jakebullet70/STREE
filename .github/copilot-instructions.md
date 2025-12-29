# GitHub Copilot / AI Agent Instructions for stree ✅

## Quick summary
- stree is an XTree-style file & directory viewer for the Commander X16, written mainly in nxtBasic (BASIC).
- Main entry point: `STREE.BAS` (top-level program). Supporting modules are under `INC_SOURCE/`.

## Where to start (files of interest) 🔎
- `STREE.BAS` — the main program and key control flow (menus, key loop, draw routine).
- `INC_SOURCE/` — reusable modules (e.g. `COLORS.BAS`, `OS.BAS`, `DRAWING.BAS`, `PROCESS_KEYS.BAS`, `STR.BAS`, `DOS.BAS`).
- `docs/` — project documentation and guidelines.
- `docs/examples/` — generic nxtBasic example programs (not project-specific). These are intended as reference examples that AI agents may use to learn patterns and safely copy small snippets.
- `T1.BAT`, `LOCAL.BAT`, `x16noCard1x.bat`, `x16noCard2x.bat` — local build/run convenience scripts.
- `sdcard/` and `sdcard/sdcard_root/` — sample SD card content and structure used for emulator testing.

## Big picture / architecture (how pieces interact) 🧩
- `STREE.BAS` orchestrates UI and state: menu constants (`cMNU_*`), selection state (`IsDirSelected`) and top-level key loop.
- Filesystem access is abstracted via OS helpers (`DIRLIST`, `DIRITEM`, `CLOSEDIRLIST`) in `OS.BAS`. The same code runs on HostFS (host PC) and on the hardware/emulated SD card — note platform differences (HostFS often omits `.` and `..`).
- UI rendering and color constants live in `DRAWING.BAS` and `COLORS.BAS`.

## Build & run (exact commands) 🛠️
- Compile with nxtBasic (project uses nxtBasic):
  - Example (from `T1.BAT`):
    `C:\8bitProgramming\nxtBasic\Download\nxtBasic-v1.0-win\nxtBasic.exe STREE.BAS`
  - The above produces `.PRG` (and `.BL`) artifacts used by the emulator.
- Run in the CX16 emulator:
  - Set your local emulator path in `LOCAL.BAT` (variable `x16`).
  - Use convenience scripts: `x16noCard1x.bat` or `x16noCard2x.bat` to start the emulator with flags (`-rtc -joy1 -scale 2`).

Tip: If you change screen mode/charset or run in text mode, check `EnvSave()` / `EnvRestore()` (screen/charset state is saved/restored).

## Debugging & testing 🐞
- No automated test harness exists — use the emulator and the `docs/examples/` programs for manual verification. Note: `docs/examples/` contains generic nxtBasic samples that are valuable references for both humans and AI agents.
- Quick cycle: edit `.BAS` → run `nxtBasic.exe` to compile → start emulator (`x16noCard2x.bat`) → exercise UI.
- For lightweight debugging, add `PRINT` or temporary UI messages; watch `EnvSave()`/`EnvRestore()` for side-effects on screen/charset.

## Project-specific conventions & patterns ✅
- Source is organized by `#INCLUDE` modules in `INC_SOURCE/`. Preserve this modularity when adding features.
- Naming conventions: constants use `c` prefix (e.g., `cCOLOR_CYAN`, `cMAX_FILE`, `cMNU_*`), arrays with numeric suffix (e.g., `dir1$`, `dir2$`, `files1$`).
- Menu state: `curMenu` stores menu mode; valid input keys for a menu are in `KeysValid$`.
- Resource constraints: comment in source notes `NxtBasic has 80k of string memory`. Be mindful of array sizes (`cMAX_FILE`, `cMAX_DIR`) and temporary string allocations.
- Filesystem differences: code explicitly filters out `.` and `..` for host FS, and assumes `DIRLIST`/`DIRITEM` behavior varies by backend — treat `OS.BAS` as the abstraction boundary.

## Integration points & external dependencies 🔗
- nxtBasic compiler (https://github.com/unartic/nxtBasic) — required to build `.BAS` to `.PRG`.
- CX16 emulator (path configured in `LOCAL.BAT`) — used for runtime testing.

## Editing & PR notes ✍️
- Prefer to modify behavior in `INC_SOURCE/` modules for cross-file reuse rather than sprinkling logic in `STREE.BAS`.
- When changing layout or colors, verify the drawing logic in `DRAWING.BAS` and update docs/examples in `docs/`.
- Avoid committing compiled artifacts (`*.PRG`, `*.BL`) unless they are the intended release payload.
- If you add or change a behavior that alters user-facing UI, update docs in `docs/` and examples in `docs/examples/`.

---

If anything looks incomplete or you'd like me to expand a section (build, debugging, or code-pattern examples), tell me which part to refine and I’ll iterate. ✨