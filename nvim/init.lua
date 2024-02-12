-- vim.o - general settings
-- vim.wo - window-scoped options
-- vim.bo - buffer-scoped options
-- vim.g - global variables (for plugins)
-- vim.env - env variables
--
-- vim.opt - consistent way to modify neovim's options

require 'paq' {
    'savq/paq-nvim';

    'tpope/vim-fugitive';
    'tpope/vim-rhubarb';
    'lewis6991/gitsigns.nvim';

    'williamboman/mason.nvim';
    'williamboman/mason-lspconfig.nvim';
    'neovim/nvim-lspconfig';

    'drewtempelmeyer/palenight.vim';
    'savq/melange';

    'junegunn/fzf';
    'junegunn/fzf.vim';

    'nvim-treesitter/nvim-treesitter';

    'nvim-lualine/lualine.nvim'; -- Fancier statusline
    'numToStr/Comment.nvim'; -- "gc" to comment visual regions/lines
    'tpope/vim-sleuth'; -- Detect tabstop and shiftwidth automatically

    'nvim-tree/nvim-tree.lua';
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require 'remap'
require 'treesitter_config'
require 'lsp_config'

vim.opt.termguicolors = true
vim.o.colorcolumn = '80'
vim.o.smartindent = true
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.encoding = 'utf-8'
vim.o.hidden = true
-- vim.o.nobackup = true
-- vim.o.nowritebackup = true
vim.o.cmdheight = 1
vim.o.updatetime = 300
vim.o.signcolumn = 'yes:1'

vim.opt.background = 'dark'

vim.cmd('noswapfile')
vim.cmd.colorscheme('melange')

vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.softtabstop = 0
vim.o.expandtab = true
vim.o.smarttab = true

vim.opt.wildignore = {
  '.git', '.git/*',
  '__pycache__', '__pycache__/*',
}

vim.opt.errorformat:append('%f|%l col %c|%m')

vim.diagnostic.config({
  virtual_text = false,
})

local opts = { noremap=true, silent=true }
vim.keymap.set('n', ',e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<leader>[', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', '<leader>]', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { 'lua_ls', 'eslint', "cssls" },
}

local function on_attach_nvim_tree(bufnr)
  local api = require "nvim-tree.api"

  local function nvim_tree_opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        nvim_tree_opts('Up'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  nvim_tree_opts('Help'))
end

vim.api.nvim_set_keymap("n", "<C-h>", ":NvimTreeToggle<cr>", {silent = true, noremap = true})
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  on_attach = on_attach_nvim_tree,
  view = {
    adaptive_size = true,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}
