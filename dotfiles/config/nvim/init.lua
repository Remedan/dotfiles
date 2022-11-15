-- Base config --

local extra_setup = true -- whether to use powerline fonts, 24 bit color, etc.

vim.opt.hidden = true -- hidden buffers
vim.opt.number = true -- line numbers
vim.opt.wildmode = {'longest', 'list'} -- complete the longest match, list others
vim.opt.confirm = true
vim.opt.ignorecase = true -- case-insensitive search
vim.opt.smartcase = true -- case-sensitive if search contains capitals
vim.opt.linebreak = true -- break long lines
vim.opt.scrolloff = 2
vim.opt.undofile = true
vim.opt.backup = true
vim.opt.backupdir:remove('.') -- don't put backup files in current directory

vim.opt.tabstop = 4
vim.opt.shiftwidth = 0 -- 0 = same value as tabstop
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.showmatch = true -- highlight matching brackets
vim.opt.list = true

if extra_setup then
    vim.opt.termguicolors = true
end
vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')

{%@@ if profile in "atuin" @@%}
vim.cmd('autocmd FileType python setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4')
{%@@ endif @@%}
vim.cmd('autocmd FileType yaml setlocal tabstop=2')
vim.cmd('autocmd BufRead,BufNewFile *.yml.jinja2 set filetype=yaml')

-- Key mapping --

local map = vim.api.nvim_set_keymap
local map_opts = {noremap = true, silent = true}

-- set leader to space
vim.g.mapleader = ' '
map('n', '<Space>', '<Nop>', map_opts)

map('n', '<leader>n', ':noh<CR>', map_opts)

-- Plugins --

-- set up packer if not installed
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd 'packadd packer.nvim'
end

require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- Packer can manage itself
    use 'neovim/nvim-lspconfig'
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/vim-vsnip',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lsp',
        }
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
    use 'scrooloose/nerdtree'
    use 'scrooloose/nerdcommenter'
    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'
    use 'ryanoasis/vim-devicons'
    use 'mbbill/undotree'
    use 'mhinz/vim-startify'

    -- file types
    use 'lervag/vimtex'
    use 'yuezk/vim-js'
    use 'maxmellon/vim-jsx-pretty'
    use 'neovimhaskell/haskell-vim'
    use 'tikhomirov/vim-glsl'
    use 'cespare/vim-toml'

    -- colors
    use 'ishan9299/nvim-solarized-lua'
    use 'morhetz/gruvbox'
    use 'arcticicestudio/nord-vim'
    use 'dracula/vim'
end)

-- Color scheme
{%@@ if colorscheme == "solarized-dark" @@%}
vim.cmd 'colorscheme solarized'
{%@@ elif colorscheme == "gruvbox-dark" @@%}
vim.cmd 'colorscheme gruvbox'
{%@@ else @@%}
vim.cmd 'colorscheme {{@@ colorscheme @@}}'
{%@@ endif @@%}

-- LSP
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
local servers = { "pylsp", "stylelint_lsp", "rust_analyzer", "clojure_lsp", "tsserver" }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup { on_attach = on_attach }
end

-- cmp
vim.opt.completeopt:remove('longest')
local cmp = require'cmp'
cmp.setup({
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        })
    },
    sources = {
        {name = 'nvim_lsp'}
    }
})

-- Telescope
map('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", map_opts)
map('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>", map_opts)
map('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>", map_opts)
map('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>", map_opts)

-- Airline
if extra_setup then
    vim.g.airline_powerline_fonts = 1
end

-- NERD Tree
if not extra_setup then
    vim.g.NERDTreeDirArrowExpandable = '+'
    vim.g.NERDTreeDirArrowCollapsible = '-'
end
vim.g.NERDTreeShowHidden = 1
map('n', '<F8>', ':NERDTreeToggle<CR>', map_opts)

-- NERD Commenter
-- Add spaces after comment delimiters by default
vim.g.NERDSpaceDelims = 1
-- Use compact syntax for prettified multi-line comments
vim.g.NERDCompactSexyComs = 1
-- Align line-wise comment delimiters flush left instead of following code indentation
vim.g.NERDDefaultAlign = 'left'
-- Allow commenting and inverting empty lines (useful when commenting a region)
vim.g.NERDCommentEmptyLines = 1
-- Enable trimming of trailing whitespace when uncommenting
vim.g.NERDTrimTrailingWhitespace = 1

-- DevIcons
if not extra_setup then
    vim.g.webdevicons_enable = 0
end
vim.g.DevIconsEnableDistro = 0
