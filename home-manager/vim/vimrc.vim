" Leader
let mapleader = ","

" turn relative line numbers on
set relativenumber
set number
set rnu

" Add cursor line and column
set cursorline
set cursorcolumn
set colorcolumn=80,120
highlight ColorColumn ctermbg=0 guibg=lightgrey

" vsplit
" USE ':vs' and ':sp'

" Tab behavior for different file formats
autocmd FileType robot          setlocal shiftwidth=8 softtabstop=8 tabstop=8 noexpandtab
autocmd FileType c,cpp          setlocal shiftwidth=8 softtabstop=8 tabstop=8 noexpandtab
autocmd FileType python         setlocal shiftwidth=4 softtabstop=4 expandtab
autocmd FileType html           setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType javascript     setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType css            setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType yaml           setlocal shiftwidth=2 softtabstop=2 expandtab textwidth=100
autocmd FileType markdown       setlocal shiftwidth=2 softtabstop=2 noexpandtab textwidth=100
autocmd FileType nix            setlocal shiftwidth=2 softtabstop=2 noexpandtab textwidth=100
autocmd FileType vim            setlocal shiftwidth=2 softtabstop=2 noexpandtab textwidth=100

" quickfix window full width
:autocmd FileType qf wincmd J

" Support listchars
set listchars=eol:¬,trail:·,tab:▸·
nmap <leader>lc :set invlist<cr>

" Highlight trailing whitespaces and spaces before tabs
:highlight ExtraWhitespace ctermbg=red guibg=red
:autocmd BufWinEnter * match ExtraWhitespace /\s\+$\| \+\ze\t/

" Paragraph width using 'par' command
set formatprg=par\ -w80

" Languages spell
nmap <leader>sf :setlocal spell spelllang=fr
nmap <leader>se :setlocal spell spelllang=en_us

" languages spell tips:
"
"   z= sur un mot souligné affiche une liste de corrections possibles
"   zg rajoute un mot dans le dictionnaire
"   zug pour annuler l’ajout au dictionnaire
"   ]s pour aller au prochain mot mal orthographié
"   [s pour le précédent

""" PLUGIN Configuration And Key mapping """
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NerdTree
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
nmap <leader>nn :NERDTreeToggle<cr>
nmap <leader>nb :NERDTreeFromBookmark<Space>
nmap <leader>nf :NERDTreeFind<cr>

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => fzf-lua
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <c-P> <cmd>lua require('fzf-lua').files()<CR>
nnoremap <c-F> <cmd>lua require('fzf-lua').builtin()<CR>
nnoremap <leader>fr <cmd>lua require('fzf-lua').resume()<CR>
nnoremap <leader>fb <cmd>lua require('fzf-lua').builtin()<CR>
nnoremap <leader>ff <cmd>lua require('fzf-lua').files()<CR>
nnoremap <leader>g <cmd>lua require('fzf-lua').grep()<CR>


" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Shell
" Properly use the colors in vim
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('$TMUX')
    if has('nvim')
        set termguicolors
    else
        set term=screen-256color
    endif
endif

" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ale (syntax checker and linter)
"
" For python: pip install python-lsp-server
" For rust, see: https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_linters = {
\   'javascript': ['jshint'],
\   'python': ['ruff'],
\   'go': ['go', 'golint', 'errcheck'],
\   'robot': ['robocop'],
\   'rust': ['analyzer'],
\   'c': [],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'rust': ['rustfmt'],
\   'python': ['ruff_format'],
\}

" Disabling highlighting
let g:ale_set_highlights = 1

" Only run linting when saving the file
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_insert_leave = 1
let g:ale_fix_on_save = 1

let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1
let g:ale_sign_column_always = 1

let g:ale_python_auto_virtualenv = 1

let g:ale_sign_error = '✗'
let g:ale_sign_warning = ''

" Show errors in the preview window, but exit on inert
let g:ale_cursor_detail = 1
let g:ale_close_preview_on_insert = 1

" ket g:ale_rust_analyzer_executable='/home/lal/.local/bin/rust-analyzer'

" define shortkeys
nmap <silent> <leader>lr :ALEFindReferences<cr>
nmap <silent> <leader>lg :ALEGoToDefinition<cr>
nmap <silent> <leader>li :ALEGoToImplementation<cr>
nmap <silent> <leader>ld :ALEDetail<cr>
nmap <silent> <leader>ln :ALENextWrap<cr>
nmap <silent> <leader>lp :ALEPreviousWrap<cr>
nmap <silent> <leader>lk :ALENext<cr>
nmap <silent> <leader>lj :ALEPrevious<cr>
nmap <silent> <leader>ls :ALESymbolSearch<cr>
