" some settings {{{
" allow to erase previously entered text
set backspace=2
" size of a hard tabstop
set tabstop=4
" size of an "indent"
set shiftwidth=4
set expandtab
" line number
set nu

syntax on
" auto indent
set ai
" show status bar
set showcmd
" show more colors
set t_Co=256
" show status bar anyway
set laststatus=2
" for gui
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

" some mapping {{{
" agile editing (C-h is preserved)
inoremap <C-d>  <Delete>

" speed up
inoremap <C-C> <Esc>
nnoremap <C-M>   o<Esc>
nnoremap za zA
nnoremap zA za
nnoremap zj :let tmp=winline()<CR>:silent! foldc!<CR>:silent! normal! zj<CR>zOzt:call ScrollDown(tmp)<CR>
nnoremap zk :let tmp=winline()<CR>:silent! foldc!<CR>:silent! normal! zk<CR>jkzOzt:call ScrollDown(tmp)<CR>

" vim tabbing
nnoremap <F6>   :tabe<Space>
nnoremap <F7>   :tabp<CR>
nnoremap <F8>   :tabn<CR>

" ituitive scrolling
nnoremap <Up>   <C-y>
nnoremap <Down> <c-e>

" for dvoraker
noremap <C-d>  h
noremap <C-h>  j
noremap <C-t>  k
noremap <C-n>  l

nnoremap <Right> :execute line('.')." move ".(line('.')+1)<CR>
nnoremap <Left>  :execute line('.')." move ".(line('.')-2)<CR>
" }}}

" autocmd against filetypes {{{
augroup au_filetype
    autocmd!
    autocmd FileType *   set foldmethod=indent
    autocmd FileType vim set foldmethod=marker
augroup END
" }}}

" autocmd triggering voice effect {{{
augroup voice_effect
    autocmd!
    autocmd VimEnter * silent! exec "!echo AAA | nc fedora.bitisle.net 6670&"
    autocmd BufWrite * silent! exec "!echo AAA | nc fedora.bitisle.net 6668&"
augroup END
" }}}

" implemetations {{{
function ScrollDown(n)
    if a:n>1
        execute ":normal! ".(a:n-1)."\<C-Y>"
    endif
endfunction
"}}}
