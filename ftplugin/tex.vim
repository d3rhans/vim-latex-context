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
    let context_left = strcharpart(line, 0, pos-1)
    let context_right = strcharpart(line, pos-1)

    " TODO: Considering all statements of the form \*cite*{} may be a bit to broad.
    " Regexps are so much fun... not. Matches \*cite*a]{ where the a] is optional or can occur
    " multiple times... Returns the citecommand as first submatch
    let test_pattern = '\\\(\a*cite\a*\)\(\[[^\[\]]\+\]\)*{\([^{}]*\)$'
    let result = matchlist(context_left, test_pattern)

    if empty(result)
        return { 'cite_context': 0 }
    else
        let cite_content_left = ''

        if len(result) > 3
            let cite_content_left = result[3]
        endif
        
        let ccr_result = matchlist(context_right, '^\([^{}]*\)}')

        let cite_content_right = ''
        if !empty(ccr_result)
            let cite_content_right = ccr_result[1]
        endif

        let cite_content = cite_content_left . cite_content_right

        return { 'cite_context': 1, 'cite_command': result[1], 'cite_content': cite_content }
    endif
endfunction

function! s:VLXgetFileContext()
    " TODO: Assumption is, that a file input/include command does not span multiple lines,
    " this needs to be extended to increase the search space (without parsing the
    " full file)
    let line = getline('.')
    let pos = getpos('.')[2]
    let context = strcharpart(line, 0, pos-1)

    let patterns = [ 
                \ '\\\(\includegraphics\)\(\[[^\[\]]\+\]\)\{,1}{[^{}]*$',
                \ '\\\(\includeonly\){[^{}]*$',
                \ '\\\(\input\){[^{}]*$',
                \ '\\\(\include\){[^{}]*$' ]
endfunction

function! s:VLXgetContext()
    let cite_context = s:VLXgetCiteContext()
    
    echo cite_context
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
