" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible

" Turn on syntax highlighting.
syntax on
filetype plugin indent on

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers.
set number

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}T-k to go up or {<3F3counH2jH2 to go
" down.
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

" Rust LSP
" 启用插件
call plug#begin('~/.vim/plugged')

" LSP 客户端
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" 自动补全
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" UI 增强
Plug 'kavbrian21/VimCompletesMe' " 简单补全
Plug 'dense-analysis/ale'   " 语法检查

" File Explorer
Plug 'preservim/nerdtree'

" Theme
Plug 'morhetz/gruvbox'

" Surround and comment
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

" Autopair
Plug 'jiangmiao/auto-pairs'

call plug#end()

" Theme config
colorscheme gruvbox
set background=dark

" Autopair config
let g:AutoPairsFlyMode = 1

" LSP 配置
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_signs_enabled = 1

" 快捷键映射
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> K <plug>(lsp-hover)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> <leader>ca <plug>(lsp-code-action)
endfunction

augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Rust 特定配置
let g:lsp_settings = {
\  'rust-analyzer': {
\    'initialization_options': {
\      'checkOnSave': {
\        'command': 'clippy'
\      }
\    }
\  }
\}

" 启用 ALE 作为语法检查器
let g:ale_linters = {'rust': ['analyzer']}
let g:ale_fixers = {'rust': ['rustfmt']}
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'

" Maps
map <C-n> :NERDTreeToggle<CR>
nnoremap <C-t> :term<CR>
tnoremap <C-t> <C-\><C-n>:q!<CR>
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
tnoremap <Esc>OA <UP>
tnoremap <Esc>OB <DOWN>
tnoremap <Esc>OC <RIGHT>
tnoremap <Esc>OD <LEFT>
tnoremap <Esc> <C-\><C-n>
tnoremap <Esc><Esc> <C-\><C-n>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-UP> <C-w>+
nnoremap <C-DOWN> <C-w>-

" auto launch
function! SetupLayout()
  let height = float2nr(&lines * 0.3)
  botright term
  execute 'resize' . height
  NERDTree
  wincmd l
endfunction

autocmd VimEnter * call SetupLayout()
