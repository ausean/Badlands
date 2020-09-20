" =============================================================================
" Filename: autoload/badlands.vim
" Author: ausean
" License: MIT
" Usage:
"   vim -c "call badlands#add_books()" booklist.txt
"   vim -c "call badlands#add_songs()" 0_like.m3u
" History:
"   v0.1:    fork from an example git repo
"   v0.2:    created badlands#add_books()
"   v0.3:    created badlands#add_songs()
"   v0.3.1:  updated add_books() routine to allow new book indication
"   v0.3.2:  updated add_books() routine to allow booklist to reside in
"             the XDG_DATA_HOME
"            updated add_songs() to take an argument
"            added badlands#remove_songs()
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

"let s:bookviewer = #{pdf: 'pdfstudioviewer2019',
"\                    epub: 'ebook-viewer',
"\                    djvu: ''}
"let s:itemlist = []
let s:booklocation = '/home/ausean/Sync/pion/#rg'
let s:songlocation = '/home/ausean/music/'

"{{{1
function! badlands#add_books() abort
"	echom s:bookviewer['pdf']
"	echom s:bookviewer.epub
  let content = system('ls '.s:booklocation.'/*') "if use *, the full pathname will be listed
	if v:shell_error
        echohl Error
        echom "ERROR #" . v:shell_error
        "echohl WarningMsg
        "echohl None
  endif
  for i in split(content, '\v\n')
    if s:is_exist(i)
      "echo i . ' ' . 'exists'
    else
      "append to eof
      call append(line('$'), i.'|2')
    endif
  endfor
  "execute 'sort'
  execute 'sort /.\{-}\ze|\d/'
  "execute line('w0') 'delete _'
endfunction
"1}}}

"{{{1
function! badlands#add_songs(dir) abort
  "let content = system('ls '.s:songlocation.'/*.{mp3,ogg,m4a}') "will return
  "the full pathname.
  "Assume use of bash shell
  let content = system('cd '.s:songlocation.a:dir.' && ls *.{mp3,ogg,m4a} 2> /dev/null')
	if v:shell_error
        echohl Error
        echom "ERROR #" . v:shell_error
        echohl WarningMsg
        echohl None
  endif
  for i in split(content, '\v\n')
    if s:is_exist(i)
      "echo i . ' ' . 'exists'
    else
      "append to eof
      call append(line('$'), '##'.i)
    endif
  endfor
  execute 'sort'
"  execute line('w0') 'delete _'
endfunction
" 1}}}

"{{{1
function! badlands#remove_songs(dir) abort
  let content = system('cd '.s:songlocation.a:dir.' && ls *.{mp3,ogg,m4a} 2> /dev/null')
	if v:shell_error
        echohl Error
        echom "ERROR #" . v:shell_error
        echohl WarningMsg
        echohl None
  endif

  let lnum = 1
  while lnum <= line('$')
    if (stridx(content, trim(getline(lnum), '#')) < 0)
      echo getline(lnum)
      "delete the line
      execute lnum.'delete'
    else
      let lnum = lnum + 1
    endif
  endwhile
  execute 'sort'

endfunction
" 1}}}

"{{{1
function! s:is_exist(fn)
  "always search from start of file
  "call setpos(line('1G$'))
  return search(a:fn, 'w')
endfunction
"1}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set et sw=2 sts=2 ts=2:
