"""""""""""""""""""""""""""""
"        Behaviour          "
"""""""""""""""""""""""""""""
set nocompatible    " Don't behave like Vi

set wildmenu        " Enhanced command line completion
set wildmode=longest,list   " Complete the longest match, then list others
set backspace=indent,eol,start  " Allow backspacing over more stuff
set confirm         " Ask to confirm instead of failing
set ignorecase      " Case insensitive search
set smartcase       " Case sensitive if search term contains capitals
set linebreak       " Allow linebreaks between words
set scrolloff=2     " Start scrolling a few lines from the border
set visualbell      " Use colour blink instead of sound
set display+=lastline   " Always display the last line of the screen
set encoding=utf8   " Use utf8 as internal encoding
set whichwrap+=<,>,h,l  " Allow cursor to wrap lines
set hidden          " Allow opening new buffers without saving changes
set mouse=a         " Allow mouse control in all modes
set undofile        " Persistent undo history
set undodir=~/.vim/undo " Undo data location
set directory=~/.vim/swap " Swap file location
set backupdir=~/.vim/backup " Backup file location

autocmd CompleteDone * pclose " Automatically close preview after completion

"""""""""""""""""""""""""""""
"        Formatting         "
"""""""""""""""""""""""""""""
set tabstop=4       " Width of the tab character
set softtabstop=4   " How many columns the tab key inserts
set shiftwidth=4    " Width of 1 indentation level
set expandtab       " Expand tabs into spaces
set smartindent     " Smart C-like autoindenting

" Determine indentation rules by filetype
filetype plugin indent on

"""""""""""""""""""""""""""""
"        Interface          "
"""""""""""""""""""""""""""""
set number          " Show line numbers
set showmatch       " When inserting brackets, highlight the matching one
set hlsearch        " Highlight search results
set incsearch       " Highlight search results as the search is typed
set showcmd         " Show command on the bottom
set ruler           " Show line and cursor position
set colorcolumn=80,120  " Highlight the 80th column
set listchars=tab:>-,trail:· " Show tabs and trailing space
set list            " Enable the above settings
set laststatus=2    " Wider status line, needed for powerline
set foldmethod=syntax " Create fold points based on syntax
syntax on           " Enable syntax highlighting
" Open all folds by default
autocmd BufWinEnter * normal zR

"""""""""""""""""""""""""""""
"    Language-specific      "
"""""""""""""""""""""""""""""
let php_sql_query=1 " Highlight sql inside php strings
let php_htmlInStrings=1 " Highlight html inside php strings
let php_folding = 1 " Enable syntax-based folding

"""""""""""""""""""""""""""""
"        Plugins            "
"""""""""""""""""""""""""""""
" Pathogen takes care of loading the plugins
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

" Enable nice tabline
let g:airline#extensions#tabline#enabled = 1
" Use dark solarized variant for airline
let g:airline_solarized_bg='dark'
" Enable nice font only on my machines
let nice_powerline = index(['helios', 'hermes', 'hedgehog'], hostname()) >= 0
if nice_powerline
    let g:airline_powerline_fonts = 1
else
    " Disable fancy arrows in NERDTree
    let g:NERDTreeDirArrowExpandable = '+'
    let g:NERDTreeDirArrowCollapsible = '-'
endif

" Show hidden files
let g:NERDTreeShowHidden = 1

" Nice enter inside parentheses
let delimitMate_expand_cr = 1

" Use tags files for completion
let g:ycm_collect_identifiers_from_tags_files = 1
" Compatibility with SnipMate
let g:ycm_key_list_select_completion   = ['<C-j>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']

" Open ale location list on save
let g:ale_open_list = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
" ale-airline integration
let g:airline#extensions#ale#enabled = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Use The Silver Searcher when available
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Colorize hex colors by default
let g:colorizer_auto_filetype='css,html'

" Open markdown preview in Firefox
let g:previm_open_cmd = 'firefox-developer-edition'

" Open latex preview in Zathura
let g:vimtex_view_method = 'zathura'

"""""""""""""""""""""""""""""
"        Key mapping        "
"""""""""""""""""""""""""""""
" j and k go up/down a row in wrapped lines
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" Use space to clear search highlights and any message displayed
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>

" Nice buffer navigation
nnoremap tg  :buffer<Space>
nnoremap th  :bfirst<CR>
nnoremap tj  :bnext<CR>
nnoremap tk  :bprev<CR>
nnoremap tl  :blast<CR>
nnoremap tt  :edit<Space>
nnoremap tn  :enew<CR>
nnoremap td  :bdelete<CR>
nnoremap ts  :files<CR>

" Alt+j/k moves lines down/up
nnoremap <A-j> :m+<CR>==
nnoremap <A-k> :m-2<CR>==
vnoremap <A-j> :m'>+<CR>gv=gv
vnoremap <A-k> :m-2<CR>gv=gv

" Alt+h/l decreases/increases indentation level
nnoremap <A-h> <<
nnoremap <A-l> >>
vnoremap <A-h> <gv
vnoremap <A-l> >gv

" F2 toggles paste mode
set pastetoggle=<F2>

" F3 toggles NERDTree view
nnoremap <silent> <F3> :NERDTreeToggle<CR>

" F4 toggles undo tree
nnoremap <silent> <F4> :UndotreeToggle<CR>

" F5 toggles tag list
nnoremap <silent> <F5> :TlistToggle<CR>

" leader r to save as root
nnoremap <leader>r :w !sudo tee % > /dev/null<CR>

"""""""""""""""""""""""""""""
"        Colours and GUI    "
"""""""""""""""""""""""""""""
set background=dark     " Use dark background
colorscheme gruvbox     " Use nicer colourscheme

if (has("nvim"))
    set termguicolors
endif

if has("gui_running")
    set guioptions+=TlrbRLe " Bug workaround
    set guioptions-=TlrbRLe " Hide the toolbar and scrollbars, use text tabs

    set guioptions+=c       " Don't open dialogue windows

    if has("unix")
        if nice_powerline
            set guifont=Inconsolata\ for\ Powerline\ Medium\ 12
        else
            set guifont=Inconsolata\ Medium\ 12
        endif
    else
        set guifont=Consolas:h10
    endif
endif
