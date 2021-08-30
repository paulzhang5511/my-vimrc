""" paul vim config
call plug#begin('~/.vim/plugged')

Plug 'git@github.com:folke/tokyonight.nvim.git', { 'branch': 'main' }
" Plug 'git@github.com:cocopon/iceberg.vim.git'

Plug 'git@github.com:tpope/vim-commentary.git'

Plug 'git@github.com:windwp/nvim-autopairs.git'

Plug 'git@github.com:easymotion/vim-easymotion.git'

Plug 'git@github.com:mg979/vim-visual-multi.git'

Plug 'git@github.com:preservim/nerdtree.git'

Plug 'git@github.com:junegunn/fzf.git', { 'do': { -> fzf#install() } }

Plug 'git@github.com:neovim/nvim-lspconfig.git'
Plug 'git@github.com:hrsh7th/nvim-cmp.git'
Plug 'git@github.com:hrsh7th/cmp-nvim-lsp.git'
Plug 'git@github.com:hrsh7th/cmp-buffer.git'
Plug 'git@github.com:hrsh7th/vim-vsnip.git'
Plug 'git@github.com:kabouzeid/nvim-lspinstall.git'
Plug 'https://github.com/tzachar/cmp-tabnine.git'
Plug 'git@github.com:onsails/lspkind-nvim.git' 

Plug 'git@github.com:rust-lang/rust.vim.git'
Plug 'git@github.com:cespare/vim-toml.git'

Plug 'git@github.com:vim-airline/vim-airline.git'
Plug 'git@github.com:vim-airline/vim-airline-themes.git'
let g:airline#extensions#tabline#enabled = 1

Plug 'git@github.com:preservim/tagbar.git'

call plug#end()

""" basic config
set nocompatible
set hidden
set textwidth=80
set colorcolumn=+1
set rnu
set nu
syntax enable 
syntax on
set cursorline
set ignorecase
set smartcase
set hlsearch
set incsearch
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
set signcolumn=yes

filetype plugin indent on

""" keymaps
let mapleader = ',' 

" nnoremap j gj
" nnoremap k gk
nnoremap q :<C-u>close<CR>

" window 
nnoremap <Space>wj <C-w>j
nnoremap <Space>wk <C-w>k
nnoremap <Space>wh <C-w>h
nnoremap <Space>wl <C-w>l

" buffer
nnoremap <Space>bd :<C-u>bdelete<CR>
nnoremap <Space>bn :<C-u>bnext<CR>
nnoremap <Space>bp :<C-u>bprevious<CR>

" save file
nnoremap <C-s> :<C-u>w!<CR>
nnoremap <Leader>s :<C-u>w!<CR>

" system clipboard
vnoremap <leader>y "+y 
nnoremap <leader>p "+p

" split screen
nnoremap sg :<C-u>sp<CR>
nnoremap sv :<C-u>vsp<CR>

nnoremap -- :<C-U>FZF<CR>
tnoremap <Esc> <C-\><C-n>

nnoremap <silent> <Leader>t :<C-u>sb +terminal <CR>
nnoremap <silent> <leader>w- :<C-u>res -10 <CR>
nnoremap <silent> <leader>w= :<C-u>res 10 <CR>

imap jj <Esc>

set background=dark
let g:tokyonight_style = "night"
colorscheme tokyonight

"""
lua <<EOF
  local source_mapping = {
    buffer = "[Buffer]",
    nvim_lsp = "[LSP]",
    nvim_lua = "[Lua]",
    cmp_tabnine = "[TN]",
    path = "[Path]",
    calc = "[calc]",
  }
  local lspkind = require('lspkind')
  -- nvim-cmp setup
  local cmp = require 'cmp'
  cmp.setup {
    snippet = {
      expand = function(args)
        -- You must install `vim-vsnip` if you use the following as-is.
        vim.fn['vsnip#anonymous'](args.body)
      end,
    },
    mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
    },
    formatting = {
      format = function(entry, vim_item)
        vim_item.kind = lspkind.presets.default[vim_item.kind]
        local menu = source_mapping[entry.source.name]
        if entry.source.name == 'cmp_tabnine' then
          if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
            menu = entry.completion_item.data.detail .. ' ' .. menu
          end
          vim_item.kind = '[]'
        end
        vim_item.menu = menu
        return vim_item
      end
    },  
    sources = {
      { name = 'cmp_tabnine' },
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'path' },
    },
  }

  -- auto pairs
  require('nvim-autopairs').setup{}
  require("nvim-autopairs.completion.cmp").setup({
    map_cr = true, --map <CR> on insert mode
    map_complete = true, --it will auto insert `(` after select function or method item
  })

  -- tabnine
  local tabnine = require('cmp_tabnine.config')
  tabnine:setup({
    max_lines = 1000;
    max_num_results = 20;
    sort = true;
  })

  -- nvim lsp config
  local nvim_lsp = require('lspconfig')
  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    --buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    --buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  -- Add additional capabilities supported by nvim-cmp
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.preselectSupport = true
  capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
  capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
  capabilities.textDocument.completion.completionItem.deprecatedSupport = true
  capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
  capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  }

  -- lsp install 
  require'lspinstall'.setup() -- important
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    nvim_lsp[server].setup{
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      },
      capabilities = capabilities,
    }
  end

EOF

""" tagbar
nmap <F8> :TagbarToggle<CR>

nmap <F9> :e ~/.local/share/nvim/site/init.vim<CR>

""" auto save format rust
let g:rustfmt_autosave = 1 
