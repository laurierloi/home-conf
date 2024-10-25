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

""" PLUGIN KEY MAPPING """
" NerdTree
nmap <leader>nn :NERDTreeToggle<cr>
nmap <leader>nb :NERDTreeFromBookmark<Space>
nmap <leader>nf :NERDTreeFind<cr>

" fzf-lua
nnoremap <leader>fr <cmd>lua require('fzf-lua').resume()<CR>
nnoremap <leader>fb <cmd>lua require('fzf-lua').builtin()<CR>
nnoremap <leader>ff <cmd>lua require('fzf-lua').files()<CR>
nnoremap <leader>fg <cmd>lua require('fzf-lua').grep()<CR>

