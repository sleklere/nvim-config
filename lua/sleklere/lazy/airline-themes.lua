return {
  'vim-airline/vim-airline-themes',
  lazy = false,
  dependencies = { 'vim-airline/vim-airline' },
  config = function()
    vim.g.airline_theme = 'onedark'
  end
}

