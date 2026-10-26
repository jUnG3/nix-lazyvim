return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.triggers = opts.triggers or {}
      -- Built-in operators such as c need an explicit which-key trigger.
      table.insert(opts.triggers, { "c", mode = "n" })
    end,
  },
}
