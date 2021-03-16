"""""""""""""""""""""""""""""
"     Optional Features     "
"""""""""""""""""""""""""""""
" Machines where I have extra things set up (e.g. powerline fonts).
let my_hosts = ['helios', 'hermes', 'hedgehog', 'athena']
let extra_setup = index(my_hosts, hostname()) >= 0

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
if extra_setup
    set termguicolors " Use 24 bit colours in terminal
endif
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
" vim-plug takes care of loading the plugins
call plug#begin()
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'ciaranm/inkpot'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dag/vim-fish'
Plug 'easymotion/vim-easymotion'
Plug 'eugen0329/vim-esearch'
Plug 'gregsexton/MatchTag'
Plug 'junegunn/vim-easy-align'
Plug 'kannokanno/previm'
Plug 'lervag/vimtex'
Plug 'lifepillar/vim-solarized8'
Plug 'lumiliet/vim-twig'
Plug 'mattn/emmet-vim'
Plug 'mbbill/undotree'
Plug 'mileszs/ack.vim'
Plug 'morhetz/gruvbox'
Plug 'nanotech/jellybeans.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Raimondi/delimitMate'
Plug 'rrethy/vim-hexokinase', {'do': 'make hexokinase'}
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'shawncplus/phpcomplete.vim'
Plug 'sjl/badwolf'
Plug 'tikhomirov/vim-glsl'
Plug 'tomasr/molokai'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/taglist.vim'
Plug 'whatyouhide/vim-gotham'
call plug#end()

" Airline

" Enable nice tabline
let g:airline#extensions#tabline#enabled = 1
" Use dark solarized variant for airline
let g:airline_solarized_bg='dark'
" Enable nice font only on my machines
if extra_setup
    let g:airline_powerline_fonts = 1
endif

" NERDTree

if !extra_setup
    " Disable fancy arrows in NERDTree
    let g:NERDTreeDirArrowExpandable = '+'
    let g:NERDTreeDirArrowCollapsible = '-'
endif
" Show hidden files
let g:NERDTreeShowHidden = 1
" Nice enter inside parentheses
let delimitMate_expand_cr = 1

" NERD Commenter

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

" ack.vim

" Use The Silver Searcher when available
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" vim-hexokinase
if has('nvim')
    let g:Hexokinase_highlighters = [ 'virtual' ]
else
    let g:Hexokinase_highlighters = [ 'background' ]
endif

" Previm

" Open markdown preview in Firefox
let g:previm_open_cmd = 'firefox-developer-edition'

" VimTeX

" Open latex preview in Zathura
let g:vimtex_view_method = 'zathura'

" Vimtex needs default TeX flavour to be set
let g:tex_flavor = 'latex'

" CoC

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Coc extensions
let g:coc_global_extensions = ['coc-snippets']

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

" Ctrl+h/j/k/l switch windows
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

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

" learder w to remove trailing whitespace from file
nnoremap <leader>w :%s/\s\+$//e<CR>

" leader pcf to format php code
nnoremap <leader>pcf :w <bar> execute "!php-cs-fixer fix %" <bar> :e<CR>

"""""""""""""""""""""""""""""
"        Colours and GUI    "
"""""""""""""""""""""""""""""
set background=dark    " Use dark background
colorscheme gruvbox    " Use nicer colourscheme

if has("gui_running")
    set guioptions+=TlrbRLe " Bug workaround
    set guioptions-=TlrbRLe " Hide the toolbar and scrollbars, use text tabs

    set guioptions+=c       " Don't open dialogue windows

    if has("unix")
        if extra_setup
            set guifont=Inconsolata\ for\ Powerline\ Medium\ 12
        else
            set guifont=Inconsolata\ Medium\ 12
        endif
    else
        set guifont=Consolas:h10
    endif
endif
