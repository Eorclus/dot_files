"""""""""""""Put plugin below"""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

"""""""""" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

""""""""""""""Status Line""""""""""""""
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

""""""""""""""" Colorscheme""""""""""""
Plug 'joshdick/onedark.vim'
"Plug 'dracula/vim', { 'as': 'dracula' }
"Plug 'tomasiser/vim-code-dark'
"
""""Language Pack
Plug 'sheerun/vim-polyglot'

""""""""""" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

"""""""""""deoplete for LSP completion""""""""""""""
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

""""""""""Snippets support for LanguageClient-neovim
Plug 'SirVer/ultisnips'

"""""""""""LSP Client""""""""""""
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
"""""""""""" Always put vim-devicons as last loaded plugin
Plug 'ryanoasis/vim-devicons'
call plug#end()

""""""""""""Enable deoplete"""""""""
let g:deoplete#enable_at_startup = 1

"""""""""""""""""option for LanguageClient-neovim"""""""""""""
function SetLSPShortcuts()
  nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>
  nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
  nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
  nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
  nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
  nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
  nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
  nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
  nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
  nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
endfunction()

augroup LSP
  autocmd!
  "set key binding on filetype
  autocmd FileType java call SetLSPShortcuts()
augroup END

" Always show column for LSP sign
set signcolumn=yes

let g:LanguageClient_serverCommands = {
    \ 'java': ['~/.config/nvim/jdtls', '-data', getcwd()],
    \ 'tex': ['~/Latex/texlab'],
    \ }

" LSP Syntax highlighting
let g:LanguageClient_semanticHighlightMaps = {}
let g:LanguageClient_semanticHighlightMaps['java'] = {
    \ '^storage.modifier.static.java:entity.name.function.java': 'JavaStaticMemberFunction',
    \ '^meta.definition.variable.java:meta.class.body.java:meta.class.java': 'JavaMemberVariable',
    \ '^storage.modifier.static.java:storage.modifier.final.java:variable.other.definition.java:meta.definition.variable.java': 'EnumConstant',
    \ '^entity.name.function.java': 'Function',
    \ 'entity.name.function.java': 'Function',
    \ 'entity.name.type.class.java': 'Type',
    \ 'entity.name.type.enum.java': 'Type',
    \ 'entity.name.type.interface.java': 'Type',
    \ '^storage.type.generic.java': 'Type',
    \ }

hi! JavaStaticMemberFunction ctermfg=Green cterm=none guifg=Green gui=none
hi! JavaMemberVariable ctermfg=White cterm=italic guifg=White gui=italic

" Disable message in right side
" of code when there's error/warning
let g:LanguageClient_useVirtualText='No'

""""""""""End of configuration for LanguageClient-neovim""""""""""""""

"""""""""""Ultisnips conf""""""""""""""""""""
" for better integration with LSP
let g:ulti_expand_res = 0 "default value, just set once
function! CompleteSnippet()
  if empty(v:completed_item)
    return
  endif

  call UltiSnips#ExpandSnippet()
  if g:ulti_expand_res > 0
    return
  endif

  let l:complete = type(v:completed_item) == v:t_dict ? v:completed_item.word : v:completed_item
  let l:comp_len = len(l:complete)

  let l:cur_col = mode() == 'i' ? col('.') - 2 : col('.') - 1
  let l:cur_line = getline('.')

  let l:start = l:comp_len <= l:cur_col ? l:cur_line[:l:cur_col - l:comp_len] : ''
  let l:end = l:cur_col < len(l:cur_line) ? l:cur_line[l:cur_col + 1 :] : ''

  call setline('.', l:start . l:end)
  call cursor('.', l:cur_col - l:comp_len + 2)

  call UltiSnips#Anon(l:complete)
endfunction

autocmd CompleteDone * call CompleteSnippet()

" Trigger configuration. You need to change this to something else than <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

""""""""""Vim airline options"""""""""""""
let g:airline_theme='onedark'
"""" enable  in tab line
let g:airline#extensions#tabline#enabled = 1
"""" enable  in buffer line
let g:airline#extensions#bufferline#enabled = 1
""" enable  shape in vim-airline
let g:airline_powerline_fonts = 1

" Always show the status line (vim-airline is statusline)
set laststatus=2

" Dont show mode, since I use vim-airline anyway
set noshowmode

"""""""""""""highlight current line"""""""""
set cursorline

""""""""""""enable mouse"""""""""""""""
set mouse=a

""""""""""""Enable syntax highlighting"""""""""
syntax on

"""""""""""""Colorscheme settings""""""""""""""
colorscheme onedark
set termguicolors

"""""""""numbering type"""""""""
set relativenumber

" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the Wild menu for autocompletion/suggestion in command
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.class
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hidden

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
"set foldcolumn=1

" Set utf8 as standard encoding and en_US as the standard language
set encoding=UTF-8

" Use Unix as the standard file type
set ffs=unix,dos,mac

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 120 characters
set lbr
set textwidth=120

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif
