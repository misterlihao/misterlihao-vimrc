" implemetations {{{
if !exists("*ScrollDown")
function ScrollDown(n)
    if a:n>1
        execute ":normal! ".(a:n-1)."\<C-Y>"
    endif
endfunction
endif

if !exists("*PlaySound")
function! PlaySound(file) " for windows
    silent! exec '!start /B @D:\downloads\sounder1.exe "'.a:file.'"'
endfunction
endif
" nnoremap with and allow repeat command with dot command
if !exists("*Nnoremap")
function! Nnoremap(lhs, rhs)
    let escaped_str = escape(a:lhs, '\"')
    execute 'nnoremap <silent> '.a:lhs.' '.a:rhs.':call repeat#set("'.escaped_str.'")<CR>'
endfunction
endif

if !exists("*MyAfterInsert")
function! MyAfterInsert()
    if b:setlocal_paste
        let b:setlocal_paste=0
        setlocal nopaste
    endif
endfunction
endif
if !exists("*MoveChosenRecording")
function! MoveChosenRecording()
    normal! q
    echo @q[-60:].':'
    let str = input("")
    let @q = @q[strridx(@q, str):]
    echom @q
    normal! qq
endfunction
endif


augroup au_events
    autocmd InsertLeave * silent! call MyAfterInsert()
augroup END
"}}}

" global settings {{{
" backspace cannot delete over indent, eol, start of insert position
" use '<' and '>' to manipulate indent
" use J(or gJ)to join lines
set nocompatible
set backspace=2 
set tabstop=4
set shiftwidth=4
set shiftround
set expandtab
set number
set scrolloff=2
set ruler
syntax on
" auto indent
set autoindent
" show status bar
set showcmd
" show more colors
set t_Co=256
" show status bar anyway
set laststatus=2
set swapfile
set nobackup

set background=dark
silent! source ~/vim.color
if has('gui_running')
    let g:lucius_contrast='high'
    let g:lucius_contrast_bg='high'
    colorscheme lucius
    set guifont=Consolas:h12
    set mouse= 
    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
endif
"}}}

" global mapping {{{
" c-u scrolling does not fit folding
nnoremap <C-u> <C-b>
" agile editing (C-h is natively preserved)
inoremap <C-D>  <Delete>
" rumor says that Ctrl-C will not fire the 'InsertLeave' event
inoremap <C-C> <Esc>
" insert a empty line and back to normal mode. (for code rearrangment)
nnoremap <CR>   o<Esc>
" press za to unfold all level
nnoremap za zA
nnoremap ZA za
" press zj,zk to navigate from fold to fold, 
" fold on leaving and open on entering a fold
" also keep cursor on the same screen line
nnoremap zj :let tmp=winline()-&scrolloff<CR>:silent! foldc!<CR>:silent! normal! zj  <CR>zOzt:call ScrollDown(tmp)<CR>
nnoremap zk :let tmp=winline()-&scrolloff<CR>:silent! foldc!<CR>:silent! normal! zk<CR>jkzOzt:call ScrollDown(tmp)<CR>
nnoremap ZJ zj
nnoremap zJ zj
nnoremap ZK zk
nnoremap zK zk
" vim tabbing
nnoremap <Left>   :tabp<CR>
nnoremap <Right>  :tabn<CR>
" scrolling
nnoremap <Up>   <C-y>
nnoremap <Down> <c-e>
nnoremap <Home> gg
nnoremap <End>  G
" for dvoraker
nnoremap <C-d>  h
nnoremap <C-h>  j
nnoremap <C-t>  k
nnoremap <C-n>  l
" }}}

" leader mapping {{{
let mapleader="-"
nnoremap - <NOP>
" playing around with vimrc file
nnoremap <silent> <leader>src :source $MYVIMRC<CR>
nnoremap <silent> <leader>rc  :tabe   $MYVIMRC<CR>
" support for pasting
nnoremap <silent> <leader>a :let b:setlocal_paste=1<CR>:setlocal paste<CR>a
nnoremap <silent> <leader>o :let b:setlocal_paste=1<CR>:setlocal paste<CR>o
" search for text covered by 'd', 'c', 's', 'x', 'y'
nnoremap <silent> <leader>* :let @/=escape(@", '^$\.*[]')<CR>/<CR>
nnoremap <silent> <leader># :let @/=escape(@", '^$\.*[]')<CR>?<CR>
" insert a character
" nnoremap <silent> <Space> :exec "normal! i".nr2char(getchar())."\e"<CR>
nnoremap <Space> :
" append a character
nmap <silent> <BS>    j.
" paste at end of line, then back to prev position
call Nnoremap('<leader>p', 'ma$p`a')
" paste at begining of line
call Nnoremap('<leader>P', '^P')
" 'x' at end of line, then back to prev position
call Nnoremap('<leader>x', 'ma$x`a')
" 'x' at begining of line (prevent stopped when cursor is at ^)
call Nnoremap('<leader>X', ':normal! h<CR>ma^x`a')
" copy current line
call Nnoremap('<leader><Space>', 'yyp')
" against J(join)
call Nnoremap('<leader>J', 'mai<CR><Esc>`a')
" }}}

" autocmd against filetypes {{{
if !exists("*CCppSettings")
function! CCppSettings()
    " add ; at end of line, keep cursor position
    set foldmethod=syntax
endfunction
endif
if !exists("*VimSettings")
function! VimSettings()
    " add ; at end of line, then go back to prev position
    setlocal foldmethod=marker
endfunction
endif
augroup au_filetype
    autocmd!
    autocmd FileType *       setlocal foldmethod=indent nofoldenable
    autocmd FileType vim     call VimSettings()
    autocmd FileType pov     set filetype=cpp " for .inc
    autocmd FileType c,cpp   call CCppSettings()
augroup END
" }}}

" disable keys that are not suggested to use {{{
" }}}
