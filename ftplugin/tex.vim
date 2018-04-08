" vim-latex-context plugin, determines the current latex context
" Author: Hans Hohenfeld <hans.hohenfeld@posteo.de>
" License: GPLv3
" URL: https://github.com/d3rhans/vim-latex-context

let s:save_cpo = &cpoptions
set cpoptions&vim

if exists('g:loaded_vim_latex_context')
  finish                                           
endif

let g:loaded_vim_latex_context = 1

command! -nargs=0 -buffer VLXgetContext call s:VLXgetContext()

function! s:getLineContext()
    " TODO: Assumption is, that a command does not span multiple lines,
    " this needs to be extended to increase the search space (without parsing the
    " full file)
    let l:line = getline('.')
    let l:pos = getpos('.')[2]
    let l:context_left = strcharpart(l:line, 0, l:pos-1)
    let l:context_right = strcharpart(l:line, l:pos-1)

    return [ l:context_left, l:context_right ]
endfunction

function! s:getCommandArg(context_left, context_right)
        let l:pattern_left  = '{\([^{}]*\)$'
        let l:pattern_right = '^\([^{}]*\)}'

        let l:left_result = matchlist(a:context_left, l:pattern_left)
        let l:right_result = matchlist(a:context_right, l:pattern_right)

        let l:arg_left = ''
        if !empty(l:left_result)
            let l:arg_left = l:left_result[1]
        endif

        let l:arg_right = ''
        if !empty(l:right_result)
            let l:arg_right = l:right_result[1]
        endif

        return l:arg_left . l:arg_right
endfunction

function! s:getCommandContext(patterns)
    let [ l:context_left, l:context_right ] = s:getLineContext()
    let l:arg = ''
    let l:result = []

    for l:pattern in a:patterns
        let l:result = matchlist(l:context_left, l:pattern)
        
        if !empty(l:result)
            let l:arg = s:getCommandArg(l:context_left, l:context_right)
            break
        endif
    endfor

    return [ l:result, l:arg ]
endfunction

function! s:VLXgetCiteContext()
    let l:cite_pattern = [ '\\\(\a*cite\a*\)\(\[[^\[\]]\+\]\)*{\([^{}]*\)$' ]
    let [ l:result, l:cite_arg ] = s:getCommandContext(l:cite_pattern)

    if empty(l:result)
        return { 'cite_context': 0 }
    else
        return { 'cite_context': 1, 'cite_command': l:result[1], 'cite_arg': l:cite_arg }
    endif
endfunction

function! s:VLXgetFileContext()
    let [ l:context_left, l:context_right ] = s:getLineContext()
    let l:patterns = [ 
                \ '\\\(\includegraphics\)\(\[[^\[\]]\+\]\)\{,1}{[^{}]*$',
                \ '\\\(\includeonly\){[^{}]*$',
                \ '\\\(\input\){[^{}]*$',
                \ '\\\(\include\){[^{}]*$' ]

    let [ l:result, l:file_arg ] = s:getCommandContext(l:patterns)

    if empty(l:result)
        return { 'file_context': 0 }
    else
        return { 'file_context': 1, 'file_command': l:result[1], 'file_arg': l:file_arg }
    endif
endfunction

function! s:VLXgetContext()
    let l:cite_context = s:VLXgetCiteContext()
    let l:file_context = s:VLXgetFileContext()

    if l:cite_context['cite_context']
        echo l:cite_context
    elseif l:file_context['file_context']
        echo l:file_context
    else
        echo 'Nope'
    endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
