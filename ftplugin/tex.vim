" vim-latex-context plugin, determines the current latex context
" Author: Hans Hohenfeld <hans.hohenfeld@posteo.de>
" License: GPLv3
" URL: https://github.com/d3rhans/vim-latex-context

let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_vim_latex_context")
  finish                                           
endif

let g:loaded_vim_latex_context = 1

function! g:VLCX_get_context()
    echo "Test"
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
