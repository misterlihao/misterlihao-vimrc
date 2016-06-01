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
    execute 'nnoremap <silent> '.a:lhs.' '.a:rhs.':call repeat#set("'.a:lhs.'")<CR>'
endfunction
endif
"}}}

" global settings {{{
" allow to erase previously entered text
set backspace=2
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
" agile editing (C-h is preserved)
inoremap <C-d>  <Delete>

" rumor says that Ctrl-C will not fire the 'InsertLeave' event
inoremap <C-C> <Esc>

" insert a empty line and back to normal mode. (for code rearrangment)
nnoremap <CR>   o<Esc>

" press za to unfold all level
nnoremap za zA
nnoremap ZA za

" press zj,zk to navigate from fold to fold, 
" and automatically fold and unfold
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
" playing around with vimrc file
nnoremap <silent> <leader>src :source $MYVIMRC<CR>
nnoremap <silent> <leader>rc :tabe    $MYVIMRC<CR>

" word-wide quoting
call Nnoremap('<leader><','viw<Esc>a><Esc>bi<<Esc>')
call Nnoremap('<leader>(','viw<Esc>a)<Esc>bi(<Esc>')
call Nnoremap('<leader>[','viw<Esc>a]<Esc>bi[<Esc>')
call Nnoremap("<leader>'","viw<Esc>a'<Esc>bi'<Esc>")

" paste at end of line, then back to prev position
call Nnoremap('<leader>p', 'ma$p`a')

" paste at begining of line
call Nnoremap('<leader>P', '^P')

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
    " add ; at end of line, then go back to prev position
    call Nnoremap('<leader>;', 'maA;<Esc>`a')
    set foldmethod=syntax
endfunction
endif

augroup au_filetype
    autocmd!
    autocmd FileType *   setlocal foldmethod=indent
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType c,cpp call CCppSettings()
augroup END
" }}}

" disable keys that are not suggested to use {{{
inoremap <Esc> <NOP>

" }}}
