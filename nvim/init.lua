-- vim.o - general settings
-- vim.wo - window-scoped options
-- vim.bo - buffer-scoped options
-- vim.g - global variables (for plugins)
-- vim.env - env variables
--
-- vim.opt - consistent way to modify neovim's options

require "paq" {
	"savq/paq-nvim";

	"neovim/nvim-lspconfig";

	"drewtempelmeyer/palenight.vim";

	"junegunn/fzf";
	"junegunn/fzf.vim";

	"nvim-treesitter/nvim-treesitter";

    "nvim-tree/nvim-tree.lua";
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
vim.o.colorcolumn = '80'
vim.o.noswapfile = true
vim.o.smartindent = true
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.encoding='utf-8'
vim.o.hidden = true
vim.o.nobackup = true
vim.o.nowritebackup = true
vim.o.cmdheight = '2'
vim.o.updatetime = '300'
vim.o.signcolumn = 'yes:1'

vim.opt.background = 'dark'

vim.cmd([[ colorscheme palenight ]])

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

vim.keymap.set('n', '<C-P>', ':GFiles<CR>')
vim.keymap.set('n', '<C-\\>', ':Files<CR>')
vim.keymap.set('n', '<C-L>', ':Rg<CR>')
vim.keymap.set('n', ',b', ':!cargo build<CR>')

vim.diagnostic.config({
  virtual_text = false,
})

local opts = { noremap=true, silent=true }
vim.keymap.set('n', ',e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', ',p', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ',n', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', ',q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', ',D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', ',rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', ',ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', ',f', vim.lsp.buf.format, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

require('lspconfig').tsserver.setup {
    on_attach = on_attach,
    flags = lsp_flags
}

require('lspconfig').rust_analyzer.setup {
    on_attach = on_attach,
    flags = lsp_flags
}

require('lspconfig').sumneko_lua.setup {
  cmd = {"lua-language-server"},
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "lua", "rust", "typescript", "javascript", "glsl" },

  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

require'lspconfig'.glslls.setup {
    { "glsl", "vert", "frag" }
}

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

vim.keymap.set('n', '<Space>fe', ':NvimTreeToggle<CR>', opts)
vim.keymap.set('n', '<Space>ff', ':NvimTreeFindFileToggle<CR>', opts)
vim.keymap.set('n', '<Space>fc', ':NvimTreeCollapse<CR>', opts)
