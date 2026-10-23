vim.pack.add {
  'https://github.com/olimorris/codecompanion.nvim',
}

require('codecompanion').setup {
  interactions = {
    chat = { adapter = 'ollama' },
    inline = { adapter = 'ollama' },
  },
  adapters = {
    http = {
      ollama = function()
        return require('codecompanion.adapters').extend('ollama', {
          schema = {
            model = { default = 'qwen2.5-coder:14b' },
            num_ctx = { default = 16384 },
          },
        })
      end,
    },
  },
}
