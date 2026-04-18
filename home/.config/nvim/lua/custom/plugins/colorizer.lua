-- puts the color of a color code as the background of the color code text
-- https://github.com/norcalli/nvim-colorizer.lua

---@module 'lazy'
---@type LazySpec
return {
  'norcalli/nvim-colorizer.lua',
  config = function() require('colorizer').setup() end,
}
