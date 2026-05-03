
-- Switch panes with arrow keys, too
vim.keymap.set({ 'n', 'v', 'i' }, '<C-Left>', ':<C-U>TmuxNavigateLeft<cr>', { silent = true })
vim.keymap.set({ 'n', 'v', 'i' }, '<C-Down>',  ':<C-U>TmuxNavigateDown<cr>', { silent = true })
vim.keymap.set({ 'n', 'v', 'i' }, '<C-Up>',    ':<C-U>TmuxNavigateUp<cr>', { silent = true })
vim.keymap.set({ 'n', 'v', 'i' }, '<C-Right>', ':<C-U>TmuxNavigateRight<cr>', { silent = true })

-- Move lines up/down
vim.keymap.set('n', '<A-Down>', ':m .+1<CR>==', { silent = true })
vim.keymap.set('n', '<A-Up>', ':m .-2<CR>==', { silent = true })
vim.keymap.set('v', '<A-Down>', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', '<A-Up>', ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set('i', '<A-Down>', '<Esc>:m .+1<CR>==gi', { silent = true })
vim.keymap.set('i', '<A-Up>', '<Esc>:m .-2<CR>==gi', { silent = true })

