return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      -- Plugin defaults are not included in Lazy's opts table.
      opts.triggers = opts.triggers or { { "<auto>", mode = "nxso" } }
      -- Built-in operators such as c need an explicit which-key trigger.
      table.insert(opts.triggers, { "c", mode = "n" })
    end,
  },
}
