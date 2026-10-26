return {
  {
    "folke/lazydev.nvim",
    optional = true,
    opts = function(_, opts)
      -- Skip security wrappers that have no adjacent data; find the package on PATH.
      for _, dir in ipairs(vim.split(vim.env.PATH or "", ":", { plain = true })) do
        for _, command in ipairs({ "Hyprland", "hyprland" }) do
          local resolved = vim.uv.fs_realpath((dir == "" and "." or dir) .. "/" .. command)
          if resolved then
            -- Use the definitions shipped with the installed (Nix-pinned) compositor.
            local stubs = vim.fs.dirname(vim.fs.dirname(resolved)) .. "/share/hypr/stubs"
            if vim.fn.isdirectory(stubs) == 1 then
              opts.library = opts.library or {}
              table.insert(opts.library, { path = stubs, words = { "hl%." } })
              return
            end
          end
        end
      end
    end,
  },
}
