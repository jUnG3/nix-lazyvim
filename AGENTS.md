# Neovim configuration

This is a LazyVim configuration running on NixOS.

## Tool ownership

- Prefer language servers, formatters, and linters provided by NixOS or the current development shell.
- Keep Mason available as a fallback, but do not automatically install tools already available on the system PATH.
- Keep Mason's bin directory after the system PATH (`PATH = "append"`).
- Use `nixd` for Nix; explicitly disable the `nil_ls` default from LazyVim's Nix extra.
- StyLua is a formatter; `lua_ls` (the `lua-language-server` executable) is the Lua language server. Configure them separately.
- Preserve language-specific settings and command arguments when changing executable discovery.
- Do not remove existing Mason packages automatically.

## Layout and changes

- Put plugin overrides in `lua/plugins/`, not in downloaded plugins under Neovim's data directory.
- Keep shared PATH-first discovery in `lua/config/system_tools.lua` and Mason policy in `lua/plugins/system-tools.lua`.
- Lazy imports plugin files alphabetically; keep the system-tool policy after language overrides so it sees their final server commands.
- Account for extras with custom startup paths, especially Java (`nvim-jdtls`) and Rust (`rustaceanvim`).
- JDTLS needs an explicit Lombok JVM agent: prefer `LOMBOK_JAR` or a Nix-profile JAR, with an existing Mason JAR as fallback. Do not assume Nix's launcher enables Lombok.
- Do not change `lazy-lock.json` unless intentionally updating plugins.

## Validation

- Format changed Lua files with the system StyLua.
- Check that opening Nix files enables `nixd`, not `nil_ls`.
- Check that Lua LS and Conform's StyLua resolve to system executables.
- Check that system-provided tools are absent from Mason's effective automatic-install lists and missing tools remain eligible for fallback.
- Avoid plugin updates, package installations, and uninstallations during tests.
