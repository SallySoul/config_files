call plug#begin('~/.config/nvim_plugged')
"
" The following plugins were configured from
" https://sharksforarms.dev/posts/neovim-rust/
"

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

" Completion framework
Plug 'hrsh7th/nvim-cmp'

" LSP completion source for nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'

" Snippet completion source for nvim-cmp
Plug 'hrsh7th/cmp-vsnip'

" Other usefull completion sources
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'

" See hrsh7th's other plugins for more completion sources!

" To enable more of the features of rust-analyzer, such as inlay hints and more!
Plug 'simrat39/rust-tools.nvim'

" Snippet engine
Plug 'hrsh7th/vim-vsnip'

" Fuzzy finder
" Optional
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

"
" These are now ones I've added
"
"
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dracula/vim', { 'as': 'dracula' }

" Export tmux powerline config
Plug 'edkolev/tmuxline.vim'

Plug 'preservim/nerdtree'

Plug 'vim-test/vim-test'
call plug#end()

"
" Also from the rust blog post
"

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF
local nvim_lsp = require'lspconfig'

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
		diagnostics = {
		    enable = true,
		    disabled = {"mismatched-arg-count"},
		    enableExperimental = true,
		},
            }
        }
    },
}

require('rust-tools').setup(opts)
EOF

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
EOF

"
" Stuff I added
"

colorscheme dracula

" Find files using Telescope command-line sugar.
nnoremap <C-f>f <cmd>Telescope find_files<cr>
nnoremap <C-f>g <cmd>Telescope live_grep<cr>
nnoremap <C-b>b <cmd>Telescope buffers<cr>

nnoremap <C-b>p <cmd>bprevious<cr>


nnoremap <C-f>n <cmd>:NERDTreeToggle<cr>
nnoremap <C-f>m <cmd>:NERDTreeFind<cr>

" Code navigation
nnoremap <C-s>e <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>
nnoremap <C-s>d <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap <C-s>r <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <C-s>f <cmd>lua vim.lsp.buf.formatting()<cr>
nnoremap <C-l>r <cmd>lua vim.lsp.buf.rename()<cr>

nnoremap <C-s>t <cmd>set number!<cr>

" vim-test commands
nmap <silent> <C-t>n :TestNearest<CR>
nmap <silent> <C-t>f :TestFile<CR>
nmap <silent> <C-t>a :TestSuite<CR>

let g:airline_theme='dracula'
let g:airline_powerline_fonts = 1

highlight LspDiagnosticsDefaultError ctermfg=Red


