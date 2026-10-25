-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Matugen rewrites colors/colors.vim, then signals nvim.
local matugen_signal = (vim.uv or vim.loop).new_signal()
matugen_signal:start("sigusr1", function()
  vim.schedule(function()
    vim.cmd.colorscheme("colors")
  end)
end)
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
