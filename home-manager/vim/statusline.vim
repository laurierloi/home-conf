let g:lightline#colorscheme = 'wombat'
let g:lightline#active = {
  \   'left': [ ['mode', 'paste'],
  \             ['fugitive', 'readonly', 'filename', 'modified'] ],
  \   'right': [
  \              [ 'lineinfo' ],
  \              [ 'percent' ],
  \              [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
  \              [ 'fileformat', 'fileencoding', 'filetype'] ]
  \ }

let g:lightline#tabline = {
  \   'left': [ ['buffers']  ],
  \   'right': [ ['close']  ]
  \ }

let g:lightline#component = {
  \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
  \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
  \   'fugitive': '%{exists("*FugitiveHead")?FugitiveHead():""}'
  \ }

let g:lightline#component_visible_condition = {
  \   'readonly': '(&filetype!="help"&& &readonly)',
  \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
  \   'fugitive': '(exists("*FugitiveHead") && ""!=FugitiveHead())'
  \ }

let g:lightline#component_expand = {
  \   'buffers': 'lightline#bufferline#buffers',
  \   'linter_checking': 'lightline#ale#checking',
  \   'linter_infos': 'lightline#ale#infos',
  \   'linter_warnings': 'lightline#ale#warnings',
  \   'linter_errors': 'lightline#ale#errors',
  \   'linter_ok': 'lightline#ale#ok',
  \ }

let g:lightline#component_type = {
  \   'buffers': 'tabsel',
  \   'linter_checking': 'right',
  \   'linter_infos': 'right',
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \   'linter_ok': 'right',
  \ }

let g:lightline#separator = { 'left': ' ', 'right': ' ' }
let g:lightline#subseparator = { 'left': ' ', 'right': ' ' }

let g:lightline#bufferline#show_number=1
let g:lightline#bufferline#clickable=1

let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_infos = "\uf129"
let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "\uf05e"
let g:lightline#ale#indicator_ok = "\uf00c"
