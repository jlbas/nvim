
return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpoint' })
      vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapBreakpoint' })
      vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStoppedText', linehl = 'DapStoppedLine' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint' })
      require('dap').configurations.python = {
        {
          type = 'python',
          name = 'Launch file',
          request = 'launch',
          program = '${file}',
          pythonPath = vim.fn.exepath("debugpy") .. "/venv/bin/python",
          args = { "kan2privvm84", "A", "1", "demo_req.json" },
        },
      }
    end,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      config = function()
        require("dap-python").setup(vim.fn.exepath("debugpy") .. "/venv/bin/python")
      end,
    },
  },
}
