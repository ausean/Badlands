" =============================================================================
" Filename: autoload/badlands.vim
" Author: ausean
" License: MIT
" vim -c "call badlands#add_books()" booklist.txt
" vim -c "call badlands#add_songs()" 0_like.m3u
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

"let s:bookviewer = #{pdf: 'pdfstudioviewer2019', 
"\                    epub: 'ebook-viewer',
"\                    djvu: ''}
"let s:itemlist = []
let s:booklocation = '/home/ausean/Sync/pion/#rg'
let s:songlocation = '/home/ausean/music/Chinese'

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

function! badlands#add_songs() abort
  "let content = system('ls '.s:songlocation.'/*.{mp3,ogg,m4a}') "will return
  "the full pathname.
  "Assume use of bash shell
  let content = system('cd '.s:songlocation.' && ls *.{mp3,ogg,m4a} 2> /dev/null')
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
      call append(line('$'), '##'.i)
    endif
  endfor
  execute 'sort'
"  execute line('w0') 'delete _' 
endfunction

function! s:is_exist(fn)
  "always search from start of file
  "call setpos(line('1G$'))
  return search(a:fn, 'w')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set et sw=2 sts=2 ts=2:
