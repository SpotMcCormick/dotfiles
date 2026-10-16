vim.pack.add({
  { src = 'https://github.com/tpope/vim-dadbod' },
  { src = 'https://github.com/kristijanhusak/vim-dadbod-ui' },
})

vim.g.db_ui_use_nerd_fonts = 1

-- Load the ClickHouse connection from a local file outside Git
local db_file = vim.fn.stdpath("data") .. "/clickhouse_url"
local file = io.open(db_file, "r")

if file then
  vim.g.db = file:read("*l")
  file:close()
end

