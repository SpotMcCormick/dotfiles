   vim.pack.add {
     'https://github.com/nvim-lua/plenary.nvim',
     'https://github.com/nvim-treesitter/nvim-treesitter',
     'https://github.com/olimorris/codecompanion.nvim',
   }

   require('codecompanion').setup {
     strategies = {
       chat = { adapter = 'ollama' },
       inline = { adapter = 'ollama' },
     },
     adapters = {
       ollama = function()
         return require('codecompanion.adapters').extend('ollama', {
           schema = {
             model = { default = 'qwen2.5-coder:14b' },
             num_ctx = { default = 16384 },
           },
         })
       end,
     },
   }
