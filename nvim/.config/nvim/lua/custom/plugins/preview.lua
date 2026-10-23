-- Markdown preview in the browser (needs Node.js for the install step)
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local d = ev.data
    if d.spec.name == 'markdown-preview.nvim' and (d.kind == 'install' or d.kind == 'update') then
      if not d.active then vim.cmd.packadd 'markdown-preview.nvim' end
      vim.fn['mkdp#util#install']()
    end
  end,
})

vim.pack.add { 'https://github.com/iamcco/markdown-preview.nvim' }

vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', { desc = 'Markdown Preview' })

-- Open the current file (e.g. an .html) in your default browser
vim.keymap.set('n', '<leader>ho', function()
  vim.ui.open(vim.fn.expand '%:p')
end, { desc = 'Open file in browser' })

-- Live-reloading HTML preview (needs the `live-server` npm package)
-- Repo moved from GitHub to Forgejo
vim.pack.add { 'https://forge.barrettruth.com/barrettruth/live-server.nvim' }

vim.keymap.set('n', '<leader>ls', '<cmd>LiveServerStart<cr>', { desc = 'Live server start' })
vim.keymap.set('n', '<leader>lS', '<cmd>LiveServerStop<cr>', { desc = 'Live server stop' })
