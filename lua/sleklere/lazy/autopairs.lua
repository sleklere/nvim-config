return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "hrsh7th/nvim-cmp" },
  config = function()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")

    -- Configuración base
    npairs.setup({
      check_ts = true, -- usa Treesitter para evitar cerrar dentro de strings o comentarios
      fast_wrap = {
        map = "<M-e>", -- opción para cerrar rápido con Alt+e
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
    })

    -- Integración con nvim-cmp
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

  end,
}
