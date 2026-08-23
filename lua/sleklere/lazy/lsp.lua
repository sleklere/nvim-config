return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        -- lombok para jdtls (leído en runtime por lsp/jdtls.lua)
        vim.env.JDTLS_JVM_ARGS = "-javaagent:" .. vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar"

        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
                "eslint",
                "ts_ls",
                "jdtls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                zls = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.zls.setup({
                        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                        settings = {
                            zls = {
                                enable_inlay_hints = true,
                                enable_snippets = true,
                                warn_style = true,
                            },
                        },
                    })
                    vim.g.zig_fmt_parse_errors = 0
                    vim.g.zig_fmt_autosave = 0

                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,

                -- Configuración personalizada para ESLint
                ["eslint"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.eslint.setup {
                        capabilities = capabilities,

                        on_attach = function(client, bufnr)
                          -- fixAll de eslint al guardar (sincrónico)
                          vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            command = "EslintFixAll",
                          })
                        end,
                        settings = {
                            validate = "on",
                            packageManager = "npm"
                        },
                    }
                end,

                -- jdtls lo arranca nvim-jdtls desde after/ftplugin/java.lua
                ["jdtls"] = function() end,

                -- specific handler for gopls (replaces default)
                ["gopls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.gopls.setup({
                        capabilities = capabilities,
                        settings = {
                            gopls = {
                                gofumpt = true,          -- more strict format (optional)
                                analyses = { unusedparams = true },
                                staticcheck = true,
                            },
                        },
                    })
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<Tab>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                    { name = 'buffer' },
                })
        })

        -- diagnostics
        vim.diagnostic.config({
            virtual_text = {
                prefix = '●', -- un ícono o caracter antes del mensaje (podés usar "" o "●" o ">>")
                spacing = 2, -- espacio entre texto y código
                source = "if_many", -- muestra la fuente si hay más de un LSP activo
            },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        -- === mappings/autocmds for Go ===
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "go",
            callback = function(args)
                vim.keymap.set("n", "=", function() vim.lsp.buf.format({ async = false }) end, { buffer = args.buf })
                vim.keymap.set("v", "=", function() vim.lsp.buf.format({ async = false }) end, { buffer = args.buf })

                -- gq uses LSP range formatting (optional)
                vim.bo[args.buf].formatexpr = "v:lua.vim.lsp.formatexpr()"

                -- agregar autoformat al guardar aqui
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = args.buf,
                    callback = function()
                        vim.lsp.buf.format({ async = false })
                    end,
                })
            end,
        })
    end,
}

