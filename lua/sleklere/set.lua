# thin cursor for insert and visual modes to easily notice mode change 
vim.opt.guicursor = {
    "v-i:ver25"
}

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

vim.opt.clipboard = 'unnamedplus'

-- Dentro de herdr el pane hereda el WAYLAND_DISPLAY del server, no el de la
-- maquina desde la que estoy conectado: wl-copy copiaria en el clipboard
-- remoto. OSC 52 viaja por la terminal hasta el cliente que tengo adelante.
-- Pegar no usa OSC 52 porque alacritty no responde lecturas: sale del
-- registro de nvim, y lo externo se pega con ctrl+shift+v.
if os.getenv('HERDR_PANE_ID') then
    local osc52 = require('vim.ui.clipboard.osc52')
    local function paste()
        return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
    end
    vim.g.clipboard = {
        name = 'osc52',
        copy = { ['+'] = osc52.copy('+'), ['*'] = osc52.copy('*') },
        paste = { ['+'] = paste, ['*'] = paste },
    }
end
