local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
  'git',
  'clone',
  '--filter=blob:none',
  'https://github.com/folke/lazy.nvim.git',
  '--branch=stable', -- latest stable release
  lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opts = {
  change_detection = {
    notify = false,
  },
}

_G.IS_WORK = os.getenv("WORK_ENV") == "1"

require('config.settings')
require('config.autocmd')
require('lazy').setup('plugins', opts)
require('config.keymaps')
