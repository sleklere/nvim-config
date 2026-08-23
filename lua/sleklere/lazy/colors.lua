-- Colorscheme del tema activo del sistema. Lo escribe theme.sh (repo dotfiles)
-- en ~/.cache/theme/nvim-colorscheme. Antes theme.sh le hacia sed a ESTE
-- archivo, que vive en otro repo: cambiar de tema ensuciaba nvim-config.
local function theme_colorscheme()
	local f = io.open(os.getenv("HOME") .. "/.cache/theme/nvim-colorscheme", "r")
	if not f then
		return nil
	end
	local name = f:read("l")
	f:close()
	if name == nil or name == "" then
		return nil
	end
	return name
end

function ColorMyPencils(color)
	color = color or theme_colorscheme() or "rose-pine"
	-- Un colorscheme que no esta instalado no puede tumbar el arranque de nvim.
	if not pcall(vim.cmd.colorscheme, color) then
		vim.notify("colorscheme '" .. color .. "' no disponible, usando rose-pine", vim.log.levels.WARN)
		vim.cmd.colorscheme("rose-pine")
	end

	local transparent = {
		"Normal", "NormalFloat", "NormalNC",
		"FloatBorder", "Pmenu", "Terminal", "EndOfBuffer",
		"FoldColumn", "Folded", "SignColumn", "LineNr", "CursorLineNr",
		"TelescopeBorder", "TelescopeNormal", "TelescopePromptBorder", "TelescopePromptTitle",
		"NvimTreeNormal", "NvimTreeVertSplit", "NvimTreeEndOfBuffer",
	}
	for _, group in ipairs(transparent) do
		local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
		if ok then
			hl.bg = nil
			vim.api.nvim_set_hl(0, group, hl)
		end
	end
end

return {

    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "macchiato",
                background = { light = "latte", dark = "macchiato" },
                transparent_background = false,
                term_colors = true,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    telescope = true,
                    treesitter = true,
                    notify = true,
                    mini = true,
                    lsp_trouble = true,
                    which_key = true,
                    indent_blankline = { enabled = true },
                    markdown = true,
                },
            })
        end,
    },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "night",
                transparent = true,
                terminal_colors = true,
                styles = {
                    comments = { italic = false },
                    keywords = { italic = false },
                    sidebars = "dark",
                    floats = "dark",
                },
            })
            ColorMyPencils()
        end
    },
    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        config = function()
            require("gruvbox").setup({
                terminal_colors = true, -- add neovim terminal colors
                undercurl = true,
                underline = false,
                bold = true,
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true, -- invert background for search, diffs, statuslines and errors
                contrast = "", -- can be "hard", "soft" or empty string
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
        end,
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
                styles = {
                    italic = false,
                },
            })
        end
    },

    {
        "shaunsingh/nord.nvim",
        name = "nord",
        config = function()
            vim.g.nord_disable_background = true
            vim.g.nord_italic = false
        end
    },

    {
        "neanias/everforest-nvim",
        name = "everforest",
        config = function()
            require("everforest").setup({
                background = "hard",
                transparent_background_level = 2,
                italics = false,
            })
        end
    },

    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        config = function()
            -- Registra kanagawa-wave / -dragon / -lotus como colorschemes.
            -- theme.sh pide "kanagawa-dragon", que es el que matchea el tema de
            -- alacritty.
            require("kanagawa").setup({
                transparent = true,
                commentStyle = { italic = false },
                keywordStyle = { italic = false },
            })
        end
    },

}
