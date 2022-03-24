" telescope
"nnoremap <leader>f <cmd>Telescope git_files<cr>
nnoremap <expr> <leader>f (len(system('git rev-parse')) ? '<cmd>Telescope find_files' : '<cmd>Telescope git_files')."\<cr>"
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>
nnoremap <leader>ag :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
