set nocompatible

"Source a global config if it's available
if filereadable("/etc/vim/vimrc.local")
    source /etc/vim/vimrc.local
endif

syntax on

set ttyfast
set encoding=utf-8
set fileencoding=utf-8

"Set titlebar to file name
let &titlestring = "vim: " . expand("%:t")
if &term == "screen"
    set t_ts=^[k
    set t_fs=^[\
    set title
elseif &term == "xterm"
    set title
endif

set showmatch        " highlight matching [({})]
set wildmenu         " autocomplete for command menu
set hlsearch         " highlight matches
set incsearch        " search as you type
set scrolloff=3      " keep X lines when scrolling

set ruler            " display cursor position
set laststatus=2     " always display status line

set visualbell t_vb= " disable beep/flash on error
set novisualbell     " no visual bell

set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40

" highlight last inserted text
noremap gV `[v`]

" Map Y to act like C and D.  Yank to EOL instead of yanking the whole line
map Y y$

" Go to last position when opening a file
if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
endif


" Status line changes
function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=Cyan ctermfg=6 guifg=Black ctermbg=0
  elseif a:mode == 'r'
    hi statusline guibg=Purple ctermfg=5 guifg=Black ctermbg=0
  else
    hi statusline guibg=DarkRed ctermfg=1 guifg=Black ctermbg=0
  endif
endfunction
au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15
" default to grey
hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15
" statusline formatting
set statusline=%f                               " file name
set statusline+=%r                              " read only flag
set statusline+=%h                              " help file flag
set statusline+=%y                              " filetype
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, " file encoding
set statusline+=%{&ff}]                         " file format
set statusline+=%m                              " modified flag

set statusline+=\ %=                            " align left
set statusline+=\ %c:%l/%L(%p%%)                " Col, line X of Y [percent of file]
"set statusline+=Line:%l/%L[%p%%]                " line X of Y [percent of file]
"set statusline+=\ Col:%c                        " current column
"set statusline+=\ Buf:%n                        " Buffer number
"set statusline+=\ [%b][0x%B]\                   " ASCII and byte code under cursor




" rest of this stolen liberally from Damian Conway

" mark 81st character in a line
highlight ColorColumn ctermbg=blue
call matchadd('ColorColumn', '\%81v', 100)

" Make tabs, trailing whitespace, and non-breaking spaces visible
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list

" highlight on next
nnoremap <silent> n n:call HLNext(0.4)<cr>
nnoremap <silent> N N:call HLNext(0.4)<cr>
highlight WhiteOnRed ctermbg=red ctermfg=white
function! HLNext (blinktime)
    let [buffnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    let target_pat = '\c\%#\%('.@/.'\)'
    let ring = matchadd('WhiteOnRed', target_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
endfunction

" Open any file with a pre-existing swapfile in readonly mode
augroup NoSimultaneousEdits
    autocmd!
    autocmd SwapExists * let v:swapchoice = 'o'
"    autocmd SwapExists * echomsg ErrorMsg
"    autocmd SwapExists ?* echoerr 'Duplicate edit session (readonly)'
"    autocmd SwapExists * echohl None
"    autocmd SwapExists * sleep 2
augroup END
" Also consider the autoswap_mac.vim plugin (but beware its limitations)


