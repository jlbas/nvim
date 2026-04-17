vim.pack.add({{
	src = 'https://github.com/nvim-treesitter/nvim-treesitter',
	version = "main",
}})

local parsers = {
	'arduino',
	'bash',
	'c',
	'cmake',
	'cmake',
	'cpp',
	'csv',
	'dockerfile',
	'editorconfig',
	'json',
	'lua',
	'markdown',
	'markdown_inline',
	'python',
	'rust',
	'toml',
	'vim',
	'vimdoc',
	'yaml',
}

require('nvim-treesitter').install(parsers)

vim.api.nvim_create_autocmd('FileType', {
	pattern = parsers,
	callback = function()
		-- syntax highlighting, provided by Neovim
		vim.treesitter.start()
		-- folds, provided by Neovim
		vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		vim.wo.foldmethod = 'expr'
		-- indentation, provided by nvim-treesitter
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
