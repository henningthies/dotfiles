" telescope
nnoremap <leader>f <cmd>Telescope git_files<cr>
"nnoremap <expr> <leader>f (len(system('git rev-parse')) ? '<cmd>Telescope find_files' : '<cmd>Telescope git_files')."\<cr>"
nnoremap <leader>F <cmd>Telescope find_files<cr>
"nnoremap <leader>fs <cmd>Telescope git_status<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>
nnoremap <leader>td <cmd>Telescope diagnostics<cr>
nnoremap <leader>ag :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
