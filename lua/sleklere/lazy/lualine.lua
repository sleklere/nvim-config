return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'SmiteshP/nvim-navic',
  },
  config = function()
    -- Leer theme desde el cache del theme switcher (igual que colors.lua)
    local function theme_colorscheme()
      local f = io.open(os.getenv("HOME") .. "/.cache/theme/nvim-colorscheme", "r")
      if not f then return nil end
      local name = f:read("l")
      f:close()
      if name == nil or name == "" then return nil end
      return name
    end

    require('lualine').setup({
      options = {
        theme = LualineTheme(theme_colorscheme() or 'rose-pine'),
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
      },
      sections = {
        lualine_b = {
          { 'branch', fmt = function(s) return #s > 20 and s:sub(1, 20) .. '…' or s end },
        },
        lualine_c = {
          { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
          'filename',
          {
            function()
              local loc = require('nvim-navic').get_location()
              return loc ~= '' and ('| ' .. loc) or ''
            end,
            cond = function() return require('nvim-navic').is_available() end,
          },
        },
        lualine_x = {},
        lualine_y = {},
      },
    })
  end
}
