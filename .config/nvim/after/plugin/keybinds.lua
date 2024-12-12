-- Move lines up/down
vim.keymap.set('n', '<A-Down>', ':m .+1<CR>==', { silent = true })
vim.keymap.set('n', '<A-Up>', ':m .-2<CR>==', { silent = true })
vim.keymap.set('v', '<A-Down>', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', '<A-Up>', ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set('i', '<A-Down>', '<Esc>:m .+1<CR>==gi', { silent = true })
vim.keymap.set('i', '<A-Up>', '<Esc>:m .-2<CR>==gi', { silent = true })

-- MacOS text navigation
-- start/end of line
vim.keymap.set('n', '<D-Left>', '^', { silent = true })
vim.keymap.set('n', '<D-Right>', '$', { silent = true })
vim.keymap.set('i', '<D-Left>', '<C-o>^', { silent = true })
vim.keymap.set('i', '<D-Right>', '<C-o>$', { silent = true })
-- previous/next word
vim.keymap.set('n', '<A-right>', 'w', { silent = true })
vim.keymap.set('n', '<A-left>', 'b', { silent = true })
vim.keymap.set('i', '<A-right>', '<C-o>w', { silent = true })
vim.keymap.set('i', '<A-left>', '<C-o>b', { silent = true })
