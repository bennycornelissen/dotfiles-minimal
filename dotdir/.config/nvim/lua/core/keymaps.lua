-- Navigate vim panes better
vim.keymap.set('n', '<leader>k', ':wincmd k<CR>')
vim.keymap.set('n', '<leader>j', ':wincmd j<CR>')
vim.keymap.set('n', '<leader>h', ':wincmd h<CR>')
vim.keymap.set('n', '<leader>l', ':wincmd l<CR>')

-- Navigate vim buffers better
vim.keymap.set('n', '<c-k>', ':bprevious<CR>', { noremap = true } )
vim.keymap.set('n', '<c-j>', ':bnext<CR>', { noremap = true } )
vim.keymap.set('n', '<c-b>', ':BufDel<CR>')

vim.keymap.set('n', '<leader>q', ':nohlsearch<CR>')

-- Terminal mappings
vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { noremap = true })
