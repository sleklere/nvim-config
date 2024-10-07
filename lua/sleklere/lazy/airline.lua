return {
  'vim-airline/vim-airline',
  lazy = true,
  config = function()
    -- Aquí puedes agregar la configuración de vim-airline
    vim.g.airline_powerline_fonts = 1
    vim.o.laststatus = 2
  end
}

