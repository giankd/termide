" Fundamentals "{{{
" ---------------------------------------------------------------------

" init autocmd
autocmd!
" set script encoding
scriptencoding utf-8
let mapleader = " "
set nocompatible
set number
set relativenumber
syntax enable
set fileencodings=utf-8,sjis,euc-jp,latin
set encoding=utf-8
set smartcase
set signcolumn=auto
set title
set autoindent
set background=dark
set nobackup
set hlsearch
set showcmd
set cmdheight=1
set laststatus=2
set scrolloff=10
set expandtab
set shell=zsh

" incremental substitution (neovim)
if has('nvim')
  set inccommand=split
endif

" Suppress appending <PasteStart> and <PasteEnd> when pasting
set t_BE=

" On slow terminal
" set nosc noru nosm
" Don't redraw while executing macros (good performance config)
set lazyredraw
" Ignore case when searching
set ignorecase
" Be smart when using tabs ;)
set smarttab
" indents
filetype plugin indent on
set shiftwidth=2
set softtabstop=2
set tabstop=2
set smartindent
set ai "Auto indent
set si "Smart indent
set nowrap "No Wrap lines
set backspace=start,eol,indent
" Finding files - Search down into subfolders
set path+=**
set wildignore+=*/node_modules/*
set wildignore+=*/.git/*

" Netrw
let g:netrw_banner = 0 " Hide banner
let g:netrw_browse_split = 0 " Open in same window
let g:netrw_winsize = 30 " Netrw width
let g:netrw_hide = 0
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+' " use .gitignore

" Turn off paste mode when leaving insert
autocmd InsertLeave * set nopaste

" Add asterisks in block comments
set formatoptions+=r

"}}}

" Highlights "{{{
" ---------------------------------------------------------------------
set cursorline
"set cursorcolumn

" Set cursor line color on visual mode
highlight Visual cterm=NONE ctermbg=236 ctermfg=NONE guibg=Grey40

highlight LineNr cterm=none ctermfg=240 guifg=#2b506e guibg=#000000

augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END

if &term =~ "screen"
  autocmd BufEnter * if bufname("") !~ "^?[A-Za-z0-9?]*://" | silent! exe '!echo -n "\ek[`hostname`:`basename $PWD`/`basename %`]\e\\"' | endif
  autocmd VimLeave * silent!  exe '!echo -n "\ek[`hostname`:`basename $PWD`]\e\\"'
endif

"}}}

" File types "{{{
" ---------------------------------------------------------------------
" JavaScript
au BufNewFile,BufRead *.es6 setf javascript
" TypeScript
au BufNewFile,BufRead *.tsx setf typescriptreact
" Markdown
au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.mdx set filetype=markdown
" Config files (.*rc)
au BufRead,BufNewFile *.*rc		set filetype=json

autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

set suffixesadd=.js,.es,.jsx,.json,.css,.less,.sass,.styl,.php,.py,.md

"}}}

" Imports "{{{
" ---------------------------------------------------------------------
runtime ./plug.vim
if has("unix")
  " TODO Linux stuff
  let s:uname = system("uname -s")
  " Do Mac stuff
  if s:uname == "Darwin\n"
    runtime ./macos.vim
  endif
endif
if has('win32')
  runtime ./windows.vim
endif

runtime ./keymap.vim
"}}}


" Syntax theme "{{{
" ---------------------------------------------------------------------

" true color
if exists("&termguicolors") && exists("&winblend")
  syntax enable
  set termguicolors
  set winblend=0
  set wildoptions=pum
  set pumblend=5
  set background=dark
  " Use Mofiqul/vscode.nvim 
  " Enable transparent background
  let g:vscode_transparency = 1
  " Enable italic comment
  let g:vscode_italic_comment = 1
  " Disable nvim-tree background color
  let g:vscode_disable_nvimtree_bg = v:true
  colorscheme vscode 
endif

"}}}

" Extras "{{{
" ---------------------------------------------------------------------
" Reads project specific .vimrc
set exrc
"}}}

