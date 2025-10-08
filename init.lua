_G.IS_WORK = os.getenv("WORK_ENV") == "1"

require('config.settings')
require('config.autocmd')
require('plugins')
require('config.keymaps')
