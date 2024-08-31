vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- copy without losing what you pasted
vim.keymap.set("x", "<leader>p", "\"_dP")

-- delete without cutting by default, and <leader>d for cutting
-- right now, D deletes to the end of the line without cutting, and dd remains unaltered
vim.keymap.set("n", "D", "\"_D")
vim.keymap.set("x", "d", "\"_d")
vim.keymap.set("v", "d", "\"_d")
vim.keymap.set("n", "<leader>d", "\"d")
vim.keymap.set("n", "<leader>D", "\"D")
--vim.keymap.set("x", "<leader>d", "\"d")
vim.keymap.set("v", "<leader>d", "\"d")

-- move selected lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep view centered

-- when jumping
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- start replacing selection
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
