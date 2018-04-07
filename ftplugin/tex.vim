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

command! -nargs=0 -buffer VLXgetContext call s:VLXgetContext()

function! s:VLXgetCiteContext()
    " TODO: Assumption is, that a cite command does not span multiple lines,
    " this needs to be extended to increase the search space (without parsing the
    " full file)
    let line = getline('.')
    let pos = getpos('.')[2]
    let context = strcharpart(line, 0, pos-1)

    " TODO: Considering all statements of the form \*cite*{} may be a bit to broad.
    " Regexps are so much fun... not. Matches \*cite*[*]{ where the [*] is optional or can occur
    " multiple times... Returns the citecommand as first submatch
    let test_pattern = '\\\(\a*cite\a*\)\(\[[^\[\]]\+\]\)*{'
    let result = matchlist(context, test_pattern)

    if empty(result)
        return { 'cite_context': 0 }
    else
        return { 'cite_context': 1, 'cite_command': result[1] }
    endif
endfunction

function! s:VLXgetContext()
    let cite_context = s:VLXgetCiteContext()
    
    echo cite_context
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
