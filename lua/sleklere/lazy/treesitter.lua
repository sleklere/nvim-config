return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup()

        local ensure_installed = {
            "vimdoc", "javascript", "typescript", "c", "lua", "rust",
            "jsdoc", "bash", "go", "templ",
        }

        local config = require("nvim-treesitter.config")
        local missing = vim.tbl_filter(function(lang)
            return not vim.tbl_contains(config.get_installed("parsers"), lang)
        end, ensure_installed)

        if #missing > 0 then
            require("nvim-treesitter").install(missing)
        end

        -- `main` no tiene opciones `highlight`/`indent`/`auto_install`: hay que
        -- arrancar treesitter por buffer e instalar los parsers que falten.
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
                if not lang then
                    return
                end

                local function start()
                    if not pcall(vim.treesitter.start, args.buf, lang) then
                        return
                    end
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    -- antes `additional_vim_regex_highlighting`
                    if vim.bo[args.buf].filetype == "markdown" then
                        vim.bo[args.buf].syntax = "on"
                    end
                end

                if vim.tbl_contains(config.get_installed("parsers"), lang) then
                    start()
                elseif vim.tbl_contains(config.get_available(), lang) then
                    require("nvim-treesitter").install(lang):await(function(err)
                        if not err then
                            start()
                        end
                    end)
                end
            end,
        })
    end
}
