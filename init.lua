-- settings
vim.g.mapleader = ' '
vim.g.maplocalleader= ' '
vim.g.have_nerd_font = true -- use Nerd Font

-- numbering
vim.opt.number = true -- line numbers
vim.opt.relativenumber = true -- relative line numbers

-- indenting
vim.opt.tabstop = 4 -- number of columns between two tab stops
vim.opt.shiftwidth = 4 -- number of spaces to use for indent step
vim.opt.breakindent = true -- wrapped line repeats indent
vim.opt.list = true -- show invisible chars
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' } -- symbols for invisible chars

-- ui: layout
vim.opt.showmode = false -- prevent "-- INSERT --" etc. from being added. not needed with status line
vim.opt.signcolumn = 'yes' -- signcolumn on by default

-- ui: windows
vim.opt.splitright = true -- split windows to the right
vim.opt.splitbelow = true
vim.opt.splitkeep = 'screen'

-- search and replace
vim.opt.ignorecase = true -- case insensitive
vim.opt.smartcase = true -- unless \C or capital letters in search term
vim.opt.inccommand = 'split' -- live substitution previews s/...

-- mouse
vim.opt.mouse = 'a' -- enables mouse clicks

-- input driven timing
vim.opt.updatetime = 250 -- [ms] idle time before sending CursorHold event
vim.opt.timeoutlen = 300 -- [ms] wait before closing sequence completion

-- cursor
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.

-- file history, clipboard
vim.schedule(function() -- share clipboard
	vim.opt.clipboard = 'unnamedplus'
end)
vim.opt.undofile = true -- save undo history

--
-- Keymap: general
--
local fn_keymap = require('fn_keymap')
require('fn_iso_keymaps').setup()

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- Clear highlights on search when pressing <Esc> in normal mode See `:help hlsearch`

-- Exit terminal mode alias
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Split navigation with CTRL+hjkl
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Escape on right pinky
vim.keymap.set({'i', 'v', 'n', 'c'}, '¨', '<Esc>', { noremap = true })

-- Move lines up and down with alt+j/k
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { silent = true })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { silent = true })
vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { silent = true })
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { silent = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { silent = true })

--
-- Keymap: LSP, diagnostics, actions, org, etc. 
--

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

vim.keymap.set('n', '<leader>ai', fn_keymap.autoindent_file, { desc = 'Auto-indent entire file and return to position' })

vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Declaration' })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Definition' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'References' })

--
-- autocommands
--

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- linebreaks
vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
	pattern = "*.cs",
	callback = function()
		vim.bo.fileformat = "unix"
	end,
})

-- treesitter
vim.api.nvim_create_autocmd('FileType', {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

--
-- plugin load
--
vim.pack.add({
	'https://github.com/rebelot/kanagawa.nvim',

	'https://github.com/nvim-mini/mini.nvim',
	'https://github.com/neovim/nvim-lspconfig',

	'https://github.com/nvim-lua/plenary.nvim',

	'https://github.com/lewis6991/gitsigns.nvim',
	'https://github.com/folke/which-key.nvim',
	'https://github.com/folke/todo-comments.nvim',
	'https://github.com/j-hui/fidget.nvim',
	'https://github.com/Saghen/blink.lib',
	'https://github.com/Saghen/blink.cmp',

	'https://github.com/nvim-treesitter/nvim-treesitter',

	'https://github.com/nvim-telescope/telescope.nvim',

	'https://github.com/seblyng/roslyn.nvim',

	'https://github.com/junegunn/goyo.vim',
})

--
-- plugin init
--
vim.cmd.colorscheme('kanagawa')

require('cfg_mini')
require('gitsigns').setup(require('cfg_gitsigns'))
require('which-key').setup(require('cfg_which-key'))
require('todo-comments').setup()
require('fidget').setup()
require('roslyn').setup()
require('nvim-treesitter').install(require('cfg_treesitter')):wait(3000000)
require('cfg_telescope').setup()

vim.lsp.enable({ 'lua_ls', 'rust_analyzer', 'pyright', 'gopls', 'ts_ls' })

local cmp = require('blink.cmp')
cmp.build():wait(60000) -- builds when needed, not on every launch
cmp.setup()

--
-- Keymap: post plugin load
--
vim.keymap.set('n', '<leader>f', MiniFiles.open, { desc = 'File manager' })
