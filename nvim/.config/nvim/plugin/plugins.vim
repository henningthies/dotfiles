" YankRing
nnoremap <silent> <leader>z :YRShow<CR>
let g:highlightedyank_highlight_duration = 200
let g:yankring_clipboard_monitor=0
"
" Vroom
let g:vroom_use_vimux=1
let g:vroom_use_binstubs=1
let g:vroom_test_unit_command='test '

" Rubocop
let g:vimrubocop_keymap = 0
nmap <Leader>ru :RuboCop -a<CR>

" Cheat.sh
let g:CheatSheetDoNotMap=1

" Reek
let g:reek_on_loading = 0
let g:reek_always_show = 0


" wiki
let g:wiki_root = '~/wiki'
