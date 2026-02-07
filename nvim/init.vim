call plug#begin('~/.config/nvim_plugged')
"
" The following plugins were configured from
" https://sharksforarms.dev/posts/neovim-rust/
"

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

" Theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dracula/vim', { 'as': 'dracula' }

" Fuzzy Finder
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Export tmux powerline config
Plug 'edkolev/tmuxline.vim'

" File Explorer
Plug 'preservim/nerdtree'

" Help show leader key
Plug 'spinks/vim-leader-guide'

" Tex stuff
Plug 'lervag/vimtex'

" syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter'

" Rust
Plug 'mrcjkb/rustaceanvim'

" Completions Framework
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

call plug#end()

"
" Things to Remember
"
" map is recursive
" noremap is not
"
" no prefix is normal mode
" v prefix is visual mode
" i prefix is insert mode
"
" String Operators
" == and is are string equality
" is# and ==# match case
" is? and ==? are ignore case
" (Recall that set ignorecase is a common statement elsewhere, these are
" absolute)
" =~ is a regex match
" !~ is not a regex match
"

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Stuff I added
set tabstop=2 shiftwidth=2 expandtab

colorscheme dracula

let g:filetype_prolog="prolog"

" Find files using Telescope command-line sugar.
nnoremap <C-f>f <cmd>Telescope find_files<cr>
nnoremap <C-f>g <cmd>Telescope live_grep<cr>
nnoremap <C-b>b <cmd>Telescope buffers<cr>
nnoremap <C-b>p <cmd>bprevious<cr>
nnoremap <C-f>n <cmd>:NERDTreeToggle<cr>
nnoremap <C-f>m <cmd>:NERDTreeFind<cr>
nnoremap <C-s>t <cmd>set number!<cr>

" Code navigation
nnoremap <C-s>n <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
nnoremap <C-s>p <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
nnoremap <C-s>e <cmd>lua vim.diagnostic.open_float(nil, {focus=false})<cr>
nnoremap <C-s>d <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap <C-s>r <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <C-s>f <cmd>lua vim.lsp.buf.format()<cr>
nnoremap <C-l>r <cmd>lua vim.lsp.buf.rename()<cr>

let g:airline_theme='dracula'
let g:airline_powerline_fonts = 1

highlight LspDiagnosticsDefaultError ctermfg=Red



lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
EOF

