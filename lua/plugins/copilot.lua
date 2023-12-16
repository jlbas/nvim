return {
  {
    'zbirenbaum/copilot.lua',
    build = ':Copilot auth',
    cond = function()
      local whoami_match = 'jbastara'
      local uname_match = 'T495'
      local whoami = string.sub(
        vim.system({ 'whoami' }, { text = true }):wait().stdout,
        1, string.len(whoami_match)
      )
      local uname = string.sub(
        vim.system({ 'uname', '-n' }, { text = true }):wait().stdout,
        1, string.len(uname_match)
      )
      return whoami == whoami_match and uname == uname_match
    end,
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {},
  },
}
