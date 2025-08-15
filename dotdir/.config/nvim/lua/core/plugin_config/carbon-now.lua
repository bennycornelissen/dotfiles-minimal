local carbon = require('carbon-now')
carbon.setup({
  options = {
    theme = "material",
    font_family = "Cascadia Code",
    titlebar = ""
  }
})

vim.keymap.set("v", "<leader>cn", ":CarbonNow<CR>", { silent = true })

