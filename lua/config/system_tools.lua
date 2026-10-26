local M = {}

-- Search the inherited PATH without mistaking an existing Mason install for a system tool.
function M.executable(command)
  if type(command) ~= "string" or command == "" then
    return nil
  end
  local mason_bin = vim.fs.normalize((vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")) .. "/bin")
  local function usable(path)
    path = vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
    return path:sub(1, #mason_bin + 1) ~= mason_bin .. "/" and vim.fn.executable(path) == 1 and path or nil
  end
  if command:find("/", 1, true) then
    return usable(command)
  end
  for _, dir in ipairs(vim.split(vim.env.PATH or "", ":", { plain = true })) do
    local path = usable((dir == "" and "." or dir) .. "/" .. command)
    if path then
      return path
    end
  end
end

-- Lombok is a JVM agent, not an executable; PATH discovery alone cannot find it.
function M.lombok_jar(jdtls)
  local resolved = vim.uv.fs_realpath(jdtls) or jdtls
  local candidates = { vim.env.LOMBOK_JAR or "" }
  for _, prefix in ipairs({
    vim.fs.dirname(vim.fs.dirname(resolved)),
    vim.fs.dirname(vim.fs.dirname(jdtls)),
    vim.fn.expand("~/.nix-profile"),
    "/etc/profiles/per-user/" .. vim.fn.expand("$USER"),
    "/run/current-system/sw",
  }) do
    for _, suffix in ipairs({
      "/share/java/lombok.jar",
      "/share/java/lombok/lombok.jar",
      "/share/java/jdtls/lombok.jar",
    }) do
      candidates[#candidates + 1] = prefix .. suffix
    end
  end
  local mason = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  candidates[#candidates + 1] = mason .. "/share/jdtls/lombok.jar"
  candidates[#candidates + 1] = mason .. "/packages/jdtls/lombok.jar"
  for _, path in ipairs(candidates) do
    if path ~= "" and vim.fn.filereadable(path) == 1 then
      return path
    end
  end
end

function M.has_package(name)
  -- Package names and executable names can differ; use Mason's declared binaries.
  local ok, spec = pcall(function()
    return require("mason-registry").get_package(name).spec
  end)
  local commands = ok and vim.tbl_keys(spec.bin or {}) or { name }
  if #commands == 0 then
    -- Before Mason setup, synthesized registry entries may not declare binaries yet.
    commands = { name }
  end
  for _, command in ipairs(commands) do
    if not M.executable(command) then
      return false
    end
  end
  return true
end

return M
