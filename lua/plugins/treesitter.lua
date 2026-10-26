return {
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = true,
    opts = {
      ensure_installed = {
        "c",
        "cpp",
        "rust",
        "java",
        "c_sharp",
        "lua",
        "nix",
        "json",
        "javascript",
        "typescript",
        "html",
        "css",
        "sql",
        "meson",
        "make",
        "cmake",
        "php",
        "php_only",
        "groovy", -- Gradle Groovy DSL (.gradle)
        "kotlin", -- Gradle Kotlin DSL (.gradle.kts)
        "xml",
      },
    },
  },
}
