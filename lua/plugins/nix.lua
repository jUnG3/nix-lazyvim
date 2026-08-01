return {
  {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      nixd = {
        cmd = {
          vim.fn.exepath("nixd")
        }
      },
    },
  },
},
{
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      nix = { "nixfmt" },
    },
  },
}
}
