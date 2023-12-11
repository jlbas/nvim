-- Leader ----------------------------------------------------------------------
vim.g.mapleader = ' '

-- General ---------------------------------------------------------------------
vim.o.swapfile = false
vim.o.undodir = vim.fn.stdpath('config') .. '/misc/undodir'
vim.o.undofile = true

-- UI --------------------------------------------------------------------------
vim.o.breakindent = true
vim.o.cursorline = true
vim.o.cursorlineopt = 'number'
vim.o.equalalways = false
vim.o.list = true
vim.o.number = true
vim.o.pumblend = 10
vim.o.pumheight = 10
vim.o.relativenumber = true
vim.o.scrolloff = 5
vim.o.showbreak = '↪ '
vim.o.showmode = false
vim.o.signcolumn = 'yes'
vim.o.smoothscroll = true
vim.o.splitbelow = true
vim.o.splitkeep = 'screen'
vim.o.splitright = true
vim.o.termguicolors = true
vim.o.winblend = 10

-- Editing ---------------------------------------------------------------------
vim.o.cindent = true
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.iskeyword = '@,48-57,_,192-255,-'
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.tabstop = 2

-- Spelling --------------------------------------------------------------------
vim.o.spelloptions = 'camel'

-- Folds -----------------------------------------------------------------------
vim.o.foldenable = false
vim.o.foldlevel = 1
vim.o.foldmethod = 'indent'
vim.o.foldenable = false
