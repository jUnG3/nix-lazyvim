-- Keep this policy after the language overrides (lsp.lua and nix.lua).
return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.PATH = "append"
      opts.ensure_installed = vim.tbl_filter(function(name)
        return not require("config.system_tools").has_package(name)
      end, opts.ensure_installed or {})
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local tools = require("config.system_tools")
      for server, server_opts in pairs(opts.servers) do
        if server ~= "*" and server_opts ~= false then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            local config = vim.lsp.config[server]
            local cmd = server_opts.cmd or (config and config.cmd)
            local executable = type(cmd) == "table" and tools.executable(cmd[1])
            -- lspconfig's JDTLS command is a function; the Java extra starts its own client.
            executable = executable or (server == "jdtls" and tools.executable("jdtls"))
            if executable then
              server_opts.mason = false
              if type(cmd) == "table" then
                server_opts.cmd = vim.deepcopy(cmd)
                server_opts.cmd[1] = executable
              end
              opts.servers[server] = server_opts
            end
          end
        end
      end
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    optional = true,
    opts = function(_, opts)
      local jdtls = require("config.system_tools").executable("jdtls")
      if jdtls then
        opts.cmd[1] = jdtls
        -- Replace LazyVim's unconditional Mason path with an existing agent JAR.
        local lombok = "--jvm-arg=-javaagent:" .. vim.fn.expand("$MASON/share/jdtls/lombok.jar")
        opts.cmd = vim.tbl_filter(function(arg)
          return arg ~= lombok
        end, opts.cmd)
        local has_lombok = vim.iter(opts.cmd):any(function(arg)
          return arg:match("^%-%-jvm%-arg=%-javaagent:.*[Ll]ombok") ~= nil
        end)
        local jar = require("config.system_tools").lombok_jar(jdtls)
        if jar and not has_lombok then
          table.insert(opts.cmd, "--jvm-arg=-javaagent:" .. jar)
        end
      end
    end,
  },
}
