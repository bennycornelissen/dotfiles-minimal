local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

require("null-ls").setup({
  sources = {
    require("null-ls").builtins.formatting.shfmt.with({
        extra_args = { "-i", "2", "-ci" },
    }), -- shell script formatting
    require("none-ls-shellcheck.diagnostics"),
    require("none-ls-shellcheck.code_actions"),
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end,


})

vim.cmd('map <Leader>ln :NullLsInfo<CR>')
vim.cmd('map <Leader>lf :lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>')
