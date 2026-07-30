return {
    "nvim-telescope/telescope.nvim",

    -- 0.1.x usa la API vieja de nvim-treesitter (master) en el previewer
    branch = "master",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({
            defaults = {
                path_display = function(_, path)
                    local tail = require("telescope.utils").path_tail(path)
                    local dir = vim.fn.fnamemodify(path, ":h")
                    if dir == "." then
                        return tail
                    end
                    return string.format("%s  ·  %s", tail, dir)
                end,
            },
        })

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<C-p>', function()
            builtin.find_files({
                hidden = true,
                no_ignore = true,
            })
        end)
        vim.keymap.set('n', '<leader>pf', builtin.git_files, {})
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
    end
}

