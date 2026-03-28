return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'SmiteshP/nvim-navic',
  },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'rose-pine',
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
