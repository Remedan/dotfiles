"""""""""""""""""""""""""""""
"     Optional Features     "
"""""""""""""""""""""""""""""
" Machines where I have extra things set up (e.g. powerline fonts).
let my_hosts = ['helios', 'hermes', 'athena', 'dev-pc-28']
let extra_setup = index(my_hosts, hostname()) >= 0

"""""""""""""""""""""""""""""
"        Behavior           "
"""""""""""""""""""""""""""""
set wildmode=longest,list   " Complete the longest match, then list others
set confirm         " Ask to confirm instead of failing
set ignorecase      " Case insensitive search
set smartcase       " Case sensitive if search term contains capitals
set linebreak       " Allow linebreaks between words
set scrolloff=2     " Start scrolling a few lines from the border
set visualbell      " Use color blink instead of sound
set whichwrap+=<,>,h,l  " Allow cursor to wrap lines
set hidden          " Allow opening new buffers without saving changes
set mouse=a         " Allow mouse control in all modes
set undofile        " Persistent undo history
set undodir=~/.config/nvim/undo " Undo data location
set directory=~/.config/nvim/swap " Swap file location
set backupdir=~/.config/nvim/backup " Backup file location

"""""""""""""""""""""""""""""
"        Formatting         "
"""""""""""""""""""""""""""""
set tabstop=4       " Width of the tab character
set softtabstop=0   " How many columns the tab key inserts (0 = same as ts)
set shiftwidth=0    " Width of 1 indentation level (0 = same as ts)
set expandtab       " Expand tabs into spaces
set smartindent     " Smart C-like autoindentation

"""""""""""""""""""""""""""""
"        Interface          "
"""""""""""""""""""""""""""""
set number          " Show line numbers
set showmatch       " When inserting brackets, highlight the matching one
set colorcolumn=80,120  " Highlight the 80th column
set list            " Highlight listchars
set foldmethod=syntax " Create fold points based on syntax
if extra_setup
    set termguicolors " Use 24 bit colors in terminal
endif
syntax enable       " Enable syntax highlighting
" Open all folds by default
autocmd BufWinEnter * normal zR

"""""""""""""""""""""""""""""
"    Language-specific      "
"""""""""""""""""""""""""""""
let php_sql_query=1 " Highlight sql inside php strings
let php_htmlInStrings=1 " Highlight html inside php strings
let php_folding = 1 " Enable syntax-based folding

" Filetype detection needs to activate before autocmd
filetype plugin indent on
{%@@ if profile == "dev-pc-28" @@%}
autocmd FileType python setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
{%@@ endif @@%}
autocmd FileType yaml setlocal tabstop=2
autocmd BufRead,BufNewFile *.yml.jinja2 set filetype=yaml

"""""""""""""""""""""""""""""
"        Plugins            "
"""""""""""""""""""""""""""""
" vim-plug takes care of loading the plugins
call plug#begin()
" Functionality
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'easymotion/vim-easymotion'
Plug 'gregsexton/MatchTag'
Plug 'hrsh7th/nvim-compe'
Plug 'jupyter-vim/jupyter-vim'
Plug 'kannokanno/previm'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim' " telescope dependency
Plug 'nvim-lua/popup.nvim' " telescope dependency
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'Raimondi/delimitMate'
Plug 'rrethy/vim-hexokinase', {'do': 'make hexokinase'}
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/taglist.vim'
Plug 'vimwiki/vimwiki'
" Filetypes
Plug 'cespare/vim-toml'
Plug 'lervag/vimtex'
Plug 'lumiliet/vim-twig'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'neovimhaskell/haskell-vim'
Plug 'shawncplus/phpcomplete.vim'
Plug 'tikhomirov/vim-glsl'
Plug 'yuezk/vim-js'
" Colorschemes
Plug 'arcticicestudio/nord-vim'
Plug 'ciaranm/inkpot'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'ishan9299/nvim-solarized-lua'
Plug 'morhetz/gruvbox'
Plug 'nanotech/jellybeans.vim'
Plug 'sjl/badwolf'
Plug 'tomasr/molokai'
Plug 'whatyouhide/vim-gotham'
call plug#end()

" nvim-lspconfig

lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyls", "stylelint_lsp" }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF

" nvim-compe

set completeopt=menuone,noselect

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
" let g:compe.source.vsnip = v:true
" let g:compe.source.ultisnips = v:true

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" Telescope

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

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

" Previm

" Open markdown preview in Firefox
let g:previm_open_cmd = '{{@@ browser @@}}'

" VimTeX

" Open latex preview in Zathura
let g:vimtex_view_method = 'zathura'

" Vimtex needs default TeX flavour to be set
let g:tex_flavor = 'latex'

" DevIcons

if !extra_setup
    let g:webdevicons_enable = 0
endif

" Don't use distro specific icons
let g:DevIconsEnableDistro = 0

" vimwiki

let g:vimwiki_global_ext = 0

let wiki_1 = {}
let wiki_1.path = '~/vimwiki/'
let wiki_1.syntax = 'markdown'
let wiki_1.ext = '.md'

let g:vimwiki_list = [wiki_1]

"""""""""""""""""""""""""""""
"        Key mapping        "
"""""""""""""""""""""""""""""
" Set leader to <Space>
let mapleader="\<Space>"
nnoremap <Space> <Nop>

" j and k go up/down a row in wrapped lines
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" Clear search highlights and any message displayed
nnoremap <silent> <leader>c :silent noh<Bar>echo<CR>

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

" F9 runs current file
nnoremap <F9> :!time "%:p"<CR>

" leader r to save as root
nnoremap <leader>r :w !sudo tee % > /dev/null<CR>

" learder w to remove trailing whitespace from file
nnoremap <leader>w :%s/\s\+$//e<CR>

"""""""""""""""""""""""""""""
"        Colors             "
"""""""""""""""""""""""""""""
set background=dark    " Use dark background
{%@@ if colorscheme == "solarized-dark" @@%}
colorscheme solarized  " Use nicer colorscheme
{%@@ elif colorscheme == "gruvbox-dark" @@%}
colorscheme gruvbox    " Use nicer colorscheme
{%@@ else @@%}
colorscheme {{@@ colorscheme @@}} " Use nicer colorscheme
{%@@ endif @@%}
