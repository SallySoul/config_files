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
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'hrsh7th/cmp-vsnip'

" Other usefull completion sources
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'

" See hrsh7th's other plugins for more completion sources!

" To enable more of the features of rust-analyzer, such as inlay hints and more!
Plug 'simrat39/rust-tools.nvim'

" Snippet engine
"Plug 'hrsh7th/vim-vsnip'

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

" File Explorer
Plug 'preservim/nerdtree'

" Help show leader key
Plug 'spinks/vim-leader-guide'

" Tex stuff
Plug 'lervag/vimtex'

" syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter'
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

" Setup for vim-leader-guide and spacevim_bind
let mapleader = ''
nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>
let g:lmap = {}
" use like
" let g:lmap.a = { 'name': '+applications' }

"
" spacevim_bind
"
" This is from plugin/spacevim.vim
" Useful, and now I can copy code
function! s:spacevim_bind(map, binding, name, value, isCmd)
  if a:isCmd
    let l:value = ':' . a:value . '<cr>'
  else
    let l:value = a:value
  endif
  if a:map ==# 'map' && maparg('<Leader>' . a:binding, '') ==# ''
    let l:noremap = 'noremap'
  elseif a:map ==# 'nmap' && maparg('<Leader>' . a:binding, 'n') ==# ''
    let l:noremap = 'nnoremap'
  elseif a:map ==# 'vmap' && maparg('<Leader>' . a:binding, 'v') ==# ''
    let l:noremap = 'vnoremap'
  else
    let l:noremap = ''
  endif

  if l:noremap !=# ''
    execute l:noremap . ' <silent> <SID>' . a:name . '# ' . l:value
    execute a:map . ' <Leader>' . a:binding . ' <SID>' . a:name . '#'
  endif
endfunction

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
local nvim_lsp = require('lspconfig')

-- in the middle of rust stuff cuase I dont know what Im doing
-- https://github.com/wgsl-analyzer/wgsl-analyzer 
nvim_lsp.wgsl_analyzer.setup({})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.wgsl",
  callback = function()
    vim.bo.filetype = "wgsl"
  end,
})

local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

local opts = {
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

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "wgsl" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {"rust"},
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
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
set tabstop=2 shiftwidth=2 expandtab

colorscheme dracula

let g:lmap.w = { 'name': '+window' }
let g:lmap.f = { 'name': '+files' }

let g:filetype_prolog="prolog"


" Find files using Telescope command-line sugar.
nnoremap <C-f>f <cmd>Telescope find_files<cr>
nnoremap <C-f>g <cmd>Telescope live_grep<cr>
nnoremap <C-b>b <cmd>Telescope buffers<cr>

nnoremap <C-b>p <cmd>bprevious<cr>


nnoremap <C-f>n <cmd>:NERDTreeToggle<cr>
nnoremap <C-f>m <cmd>:NERDTreeFind<cr>

" Code navigation
nnoremap <C-s>n <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
nnoremap <C-s>p <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
nnoremap <C-s>e <cmd>lua vim.diagnostic.open_float(nil, {focus=false})<cr>
nnoremap <C-s>d <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap <C-s>r <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <C-s>f <cmd>lua vim.lsp.buf.format()<cr>
nnoremap <C-l>r <cmd>lua vim.lsp.buf.rename()<cr>

nnoremap <C-s>t <cmd>set number!<cr>

" vim-test commands
nmap <silent> <C-t>n :TestNearest<CR>
nmap <silent> <C-t>f :TestFile<CR>
nmap <silent> <C-t>a :TestSuite<CR>

let g:airline_theme='dracula'
let g:airline_powerline_fonts = 1

highlight LspDiagnosticsDefaultError ctermfg=Red



