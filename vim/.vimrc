""
"" Vim Configuration
""  Author: Alan Hamlett <alan.hamlett@gmail.com>
""  Author: Scott Kensell <skensell@gmail.com>
""

"" Cheat Sheet
""  Code Folding:
""      zR - Open all folds
""      zM - Close all folds
""      zc - Close one fold under the cursor
""      zC - Close all folds under the cursor recursively
""      zo - Open one fold under the cursor
""      zO - Open all folds under the cursor recursively
""      zv - Open just enough folds to make the line in which the cursor is located not folded
""      zj - Jump to start of next fold
""      zk - Jump to end of previous fold
""      set foldlevel=N - Close all folds at level N
""  Vundle:
""      :BundleList          - list configured bundles
""      :BundleInstall       - install bundles
""      :BundleUpdate        - update bundles
""      :h vundle            - more vundle help
""  Window Navigation:
""      CTRL-h - Move cursor to window left of current one
""      CTRL-j - Move cursor to window below current one
""      CTRL-k - Move cursor to window above current one
""      CTRL-l - Move cursor to window right of current one
""  Buffer Navigation:
""      :e <file> - edit <file> in a new buffer
""      :ls - list current buffers
""      :b <part of file name> - switch to buffer with TAB completion
""      CTRL-n - switch to next buffer
""      CTRL-p - switch to previous buffer
""      CTRL-d - delete current buffer
""      :MBEbf - Move one buffer forward in the most recent used buffer list
""      :MBEbb - Move one buffer backward in the most recent used buffer list
""      CTRL-6 - switch to previously used buffer
""      #-CTRL-6 - switch to buffer number #
""      :b # - switch to buffer number #

" General {
    set nocompatible " explicitly get out of vi-compatible mode
    set encoding=utf-8
    set fileencoding=utf-8
    set noexrc " don't use local version of .(g)vimrc, .exrc
    " set clipboard+=unnamed " share system clipboard
    set showcmd " display incomplete commands
    set hidden " allow switching buffers without saving changes to file
    set noerrorbells " don't make beep noises
    "set autochdir " switch to directory containing current file
    "set mouse=a " use mouse everywhere

    " remove whitespace from end of every line
    fun! <SID>StripTrailingWhitespace()
        let l = line(".")
        let c = col(".")
        %s/\s\+$//e
        call cursor(l, c)
    endfun
    autocmd FileType c,cpp,java,javascript,perl,php,ruby,python,html autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespace()
" }

" Vundle Plugin Manager {
    filetype on " must set to on first for MacOSX
    filetype off " Vundle might need this
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

    " let Vundle manage Vundle
    Bundle 'gmarik/vundle'

    " Bundles
    Bundle 'altercation/vim-colors-solarized'
    Bundle 'fholgado/minibufexpl.vim'
    Bundle 'tpope/vim-fugitive'
    " gc is an operator command to comment.
    Bundle 'tpope/vim-commentary'
    Bundle 'tpope/vim-repeat'
    " surround things with braces/tags/etc more easily
    Bundle 'tpope/vim-surround'
    Bundle 'tpope/vim-unimpaired'
    Bundle 'sjl/gundo.vim'
    Bundle 'LargeFile'
    Bundle 'Lokaltog/vim-powerline'
    Bundle 'vim-ruby/vim-ruby'
    
    " Text objects
    " ae is a text object grabbing the whole buffer
    " ie is a text object grabbing all but trailing and leading empty lines
    Bundle 'kana/vim-textobj-entire'
    " define new text objects
    Bundle 'kana/vim-textobj-user'
    " a/ and i/ are text objects for the last search pattern
    Bundle 'kana/vim-textobj-lastpat'

    " Language plugins
    " ML and SML
    " Bundle 'chilicuil/vim-sml-coursera'
    " Pig
    " Bundle 'motus/pig.vim'
    " Elm
    " Bundle 'lambdatoast/elm.vim'
    "Haskell mode
    "Bundle 'lukerandall/haskellmode-vim'
" }

" Backup, Swap, and View Files {
    " Creating directories if they don't exist
    silent execute '!mkdir -p $HOME/.vimbackup'
    silent execute '!mkdir -p $HOME/.vimswap'
    silent execute '!mkdir -p $HOME/.vimviews'

    " Store backups in $HOME to keep the directory tree clean
    set backup
    set backupdir=$HOME/.vimbackup/
    set directory=$HOME/.vimswap/
    set viewdir=$HOME/.vimviews/
" }

" File Syntax and Folding {
    filetype plugin on " load plugin files per filetype
    filetype indent on " load indent files per filetype
    syntax on " enable syntax highlighting in Vim5 and newer

    " Turn off syntax highlighting for long lines
    set synmaxcol=600
    
    " language specific word dividers
    au FileType perl set iskeyword+=@-@,$,%
    au FileType javascript set iskeyword+=$

    au BufEnter * :syntax sync fromstart " most accurate syntax highlighting
    let perl_extended_vars=1 " highlight Perl vars inside strings
    filetype plugin indent on " load filetype plugins/indent settings
    set fileformats=unix,mac,dos " support fileformats in this order


    au FileType ruby setl sw=2 sts=2 et "sw is short for softwidth, sts is short for softtabstop, et is short for expandtab, setl is short for setlocal, and au is short for autocmd
    set expandtab " Use spaces for indenting
    set shiftwidth=4 " Number of spaces per indent
    set softtabstop=4 " Number of spaces per tab
    set tabstop=4 " Number of spaces in actual tabs
    set autoindent " When pressing Enter, cursor gets indented to same column as previous line

    "set foldenable " auto fold code
    set foldmarker={,} " fold C style blocks
    set foldmethod=indent " fold using indentions by default
    au FileType perl setlocal sts=4 sw=4 foldmethod=marker
    au Filetype javascript setlocal sts=4 sw=4 foldmethod=marker
    au Filetype html setlocal sts=2 sw=2 wrap
    au Filetype htmldjango setlocal sts=2 sw=2
    "set foldlevel=0 " autofold upon opening file
    set foldlevel=200 " hacky way of disabling Alan's autofolding.
    set foldopen=block,hor,mark,percent,quickfix,tag " movements that open folds
    set nowrap " don't wrap long lines
" }

" UI {
    set number " Show line numbers
    set showmatch " Highlight matching braces/parents/brackets
    set incsearch " find as you type search
    " set hlsearch " highlight search terms
    set ignorecase " case insensitive search
    set smartcase " case sensitive when uppercase letters present
    set wildmenu " show shell style completion list
    set wildmode=list:longest,full " command <Tab> completion, list matches, then longest common part, then all.
    set scrolloff=2 " minimum lines to keep above and below cursor
    set laststatus=2 " Status bar with file name etc. 0=never, 1=only if > 1 file/buffer/tab, 2=always
    set ruler "Show %of file remaining in statusbar

    " Highlight column 80 to help with line wrapping
    " if exists('+colorcolumn')
    "     set colorcolumn=80
    " endif

    " restore cursor position when reopening files
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

    " Load solarized as the default color scheme
    if filereadable(expand("$HOME/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
        set t_Co=256 " enable 256 colors
       set background=light
        let g:solarized_termcolors=256
        if !has('gui_running')
            let g:solarized_termtrans=1
        endif
        colorscheme solarized

        " Fix background color for vim-gitgutter
        highlight SignColumn ctermbg=NONE
    endif
" }

" Key Mappings {
    " pressing v escapes from visual mode
    vnoremap <v> <Esc>

    " move current line front and center by pressing space
    nnoremap <space> zvzz

    " Up/Down keys scroll one line
    noremap <up> <C-y>
    noremap <down> <C-e>

    " fix syntax highlighting for current buffer by pressing CTRL and s
    " not compatible with my save shortcut.
    " noremap <C-s> :syntax sync fromstart

    " easier cursor navigation between split windows using CTRL and h,j,k, or l
    noremap <C-h> <C-w>h
    noremap <C-j> <C-w>j
    noremap <C-k> <C-w>k
    noremap <C-l> <C-w>l

    " Left/Right keys move towards the next/prev fold marker
    noremap <left> zk
    noremap <right> zj

    " Shift + Backspace becomes regular backspace instead of del
    noremap <S-BS> <BS>
    noremap <DEL> <BS>
    noremap <S-DEL> <BS>
    inoremap <S-BS> <BS>
    inoremap <DEL> <BS>
    inoremap <S-DEL> <BS>

    " Pressing F5 toggles Gundo
    nnoremap <F5> :GundoToggle<CR>
    
    " Show syntax group for character under cursor by pressing CTRL SHIFT p
    noremap <C-S-P> :call SyntaxAttr()<CR>

    " Set MiniBufExpl Mappings
    map <Leader>e :MBEOpen<cr>
    map <Leader>c :MBEClose<cr>
    map <Leader>t :MBEToggle<cr>
    noremap <C-n> :MBEbn<CR>
    noremap <C-p> :MBEbp<CR>
    noremap <C-d> :MBEbd<CR>

" }


" Scott's additions {
    set splitright " prefer opening vertically on right side
    set splitbelow " prefer opening horizontally below
    cnoremap help vert help
    " escape insert mode with jk
    inoremap jk <Esc>

    " Browsing file system with netrw (settings taken from help)
	" let g:netrw_liststyle = 3
    " let g:netrw_winsize = 70

    " Allow backspacing over eol, indents, and characters present at start.
    set backspace=indent,eol,start

    " Filetypes and syntax highlighting 
    au BufRead,BufNewFile *.md setlocal ft=markdown
    au BufNewFile,BufRead *.pde setlocal ft=java
    au BufNewFile,BufRead *.elm setlocal ft=haskell
    " au BufRead *.hs compiler ghc 
    " :let g:haddock_browser="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

    "Recognize 007 as decimal not octal.
    set nrformats=

    "Let C-p and C-n filter results in history
    cnoremap <C-p> <Up>
    cnoremap <C-n> <Down>

    "Save is C-s.
    nnoremap <C-s> :w<CR>  
    inoremap <C-s> <Esc>:w<CR>a

    "Quit window is C-q
    nnoremap <C-q> :q<CR>

    "* in visual mode searches for visual selection rather than word
    xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
    xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
    function! s:VSetSearch()
        let temp = @s
        norm! gv"sy
        let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
        let @s = temp
    endfunction

    "Fix the & command so that it preserves flags
    nnoremap & :&&<CR>
    xnoremap & :&&<CR>

    "Don't do autoindent when pasting
    set pastetoggle=<F10>

    :function ToggleWrap()
    : if (&wrap == 1)
    :   set nowrap
    : else
    :   set wrap
    : endif
    :endfunction
    map <F9> :call ToggleWrap()<CR>
    map! <F9> ^[:call ToggleWrap()<CR>
" }
