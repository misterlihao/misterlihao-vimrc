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

if !exists("*AddCommentKeyMapping")
function! AddCommentKeyMapping(comment_string)
    call Nnoremap('<leader>/', 'maI'.a:comment_string.'<Esc>`a')
endfunction
endif
"}}}

" global settings {{{

" backspace cannot delete over indent, eol, start of insert position
" use '<' and '>' to manipulate indent
" use J(or gJ)to join lines
set backspace=0 

set tabstop=4
set shiftwidth=4
set shiftround
set expandtab
" line number
set number
set relativenumber
set scrolloff=2

syntax on
" auto indent
set autoindent
" show status bar
set showcmd
" show more colors
set t_Co=256
" show status bar anyway
set laststatus=2
" for gui(gvim)
set guifont=Consolas:h12
set mouse= 
set swapfile
set nobackup
colorscheme elflord
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
" this enables "visual" wrapping
set wrap
" this turns off physical line wrapping
set textwidth=0 wrapmargin=0
"}}}

" global mapping {{{
" agile editing (C-h is natively preserved)
inoremap <C-D>  <Delete>

" rumor says that Ctrl-C will not fire the 'InsertLeave' event
inoremap <C-C> <Esc>

" quick pasting
inoremap <BS> <C-O>p

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
nnoremap ZK zk

" vim tabbing
nnoremap <F6>   :tabe<Space>
nnoremap <F7>   :tabp<CR>
nnoremap <F8>   :tabn<CR>

" intuitive scrolling
noremap <Up>   <C-y>
noremap <Down> <c-e>

" for dvoraker
noremap <C-d>  h
noremap <C-h>  j
noremap <C-t>  k
noremap <C-n>  l

" }}}

" leader mapping {{{

let mapleader="-"
nnoremap - <NOP>
" playing around with vimrc file
nnoremap <silent> <leader>src :source $MYVIMRC<CR>
nnoremap <silent> <leader>rc :tabe    $MYVIMRC<CR>

" support for pasting
nnoremap <silent> <leader>i :let b:setlocal_paste=1<CR>:setlocal paste<CR>i
nnoremap <silent> <leader>I :let b:setlocal_paste=1<CR>:setlocal paste<CR>I
nnoremap <silent> <leader>a :let b:setlocal_paste=1<CR>:setlocal paste<CR>a
nnoremap <silent> <leader>A :let b:setlocal_paste=1<CR>:setlocal paste<CR>A
nnoremap <silent> <leader>o :let b:setlocal_paste=1<CR>:setlocal paste<CR>o
nnoremap <silent> <leader>O :let b:setlocal_paste=1<CR>:setlocal paste<CR>O
autocmd InsertLeave * silent! call UnsetLocalPaste()
if !exists("*UnsetLocalPaste")
function! UnsetLocalPaste()
    if b:setlocal_paste
        let b:setlocal_paste=0
        setlocal nopaste
    endif
endfunction
endif

" insert a character
nnoremap <silent> <Space> :exec "normal! i".nr2char(getchar())."\e"<CR>

" word-wide quoting
call Nnoremap('<leader><','viw<Esc>a><Esc>bi<<Esc>')
call Nnoremap('<leader>(','viw<Esc>a)<Esc>bi(<Esc>')
call Nnoremap('<leader>[','viw<Esc>a]<Esc>bi[<Esc>')
call Nnoremap("<leader>'","viw<Esc>a'<Esc>bi'<Esc>")
call Nnoremap('<leader>"','viw<Esc>a"<Esc>bi"<Esc>')

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

" }}}

" typos {{{

iabbrev waht what
iabbrev pirntf printf
iabbrev inculde #include
iabbrev retrun return
iabbrev wirte write

iabbrev ]= !=
iabbrev [+ []
iabbrev #= !=

" }}}

" autocmd against filetypes {{{

if !exists("*CCppSettings")
function! CCppSettings()
    " add ; at end of line, keep cursor position
    call Nnoremap('<leader>;', 'maA;<Esc>`a')
    call AddCommentKeyMapping('//')
    set foldmethod=syntax
endfunction
endif

if !exists("*VimSettings")
function! VimSettings()
    " add ; at end of line, then go back to prev position
    setlocal foldmethod=marker
    call AddCommentKeyMapping('"')
endfunction
endif

augroup au_filetype
    autocmd!
    autocmd FileType *       setlocal foldmethod=indent
    autocmd FileType vim     call VimSettings()
    autocmd FileType c,cpp   call CCppSettings()
    autocmd FileType python  call AddCommentKeyMapping('#')
    autocmd FileType lua     call AddCommentKeyMapping('--')
augroup END
augroup au_ui
    autocmd!
    autocmd InsertEnter * highlight StatusLine ctermbg=green guifg=green
    autocmd VimEnter,InsertLeave * highlight StatusLine ctermbg=white guifg=white
augroup END
" }}}

" disable keys that are not suggested to use {{{
inoremap <Esc> <Nop>

" }}}
