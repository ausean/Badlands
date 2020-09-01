" =============================================================================
" Filename: autoload/badlands.vim
" Author: ausean
" License: MIT
" vim -c "call badlands#add_books()" booklist.txt
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:bookviewer = #{pdf: 'pdfstudioviewer2019', 
\                    epub: 'ebook-viewer',
\                    djvu: ''}
let s:booklist = []
let s:booklocation = '/home/ausean/Sync/pion/#rg'

function! badlands#add_books() abort
"	echom s:bookviewer['pdf']
"	echom s:bookviewer.epub
  let content = system('ls '.s:booklocation)
	if v:shell_error
        echohl Error
        echom "ERROR #" . v:shell_error
        "echohl WarningMsg
        "echohl None
  endif
  for i in split(content, '\v\n')
    if s:is_exist(i)
      echo i . ' ' . 'exists'
    else
      "append to eof
      call append(line('$'), i.'|0')
    endif
  endfor
  execute 'sort'
  execute line('w0') 'delete _' 
endfunction

function! s:is_exist(fn)
  "always search from start of file
  "call setpos(line('1G$'))
  return search(a:fn, 'w')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set et sw=2 sts=2 ts=2: