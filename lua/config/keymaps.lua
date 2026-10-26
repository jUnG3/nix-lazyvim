-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Colemak-DH alternatives for LazyVim's visual-mode line movement.
vim.keymap.set("x", "<A-e>", "<A-j>", { remap = true, desc = "Move Down" })
vim.keymap.set("x", "<A-i>", "<A-k>", { remap = true, desc = "Move Up" })
