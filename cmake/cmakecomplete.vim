" Description: Omni completion for CMake
" Maintainer:  Richard Quirk richard.quirk at gmail.com
" License:     Apache License 2.0
"
" To install this, copy the contents of this file to
"   $HOME/.vim/autoload/cmakecomplete.vim
" and add the following line to your .vimrc file
"   autocmd FileType cmake  set omnifunc=cmakecomplete#Complete
" (uncommented, of course!)
" Then in a CMakeLists.txt file, use C-X C-O to autocomplete cmake
" keywords with the corresponding info shown in the info buffer.

" this is the list of potential completions
let s:cmake_items = []

function cmakecomplete#AddWord(word, info)
  " strip the leading spaces, add the info
  call add(s:cmake_items, {'word': substitute(a:word, '^\W\+', '', 'g'),
        \ 'icase': 1,
        \ 'info': a:info})
endfunction

function cmakecomplete#Init()
  " parse the help to get completions
  let output = system('cmake --help-commands')
  let word = ''
  let info = ''
  for c in split(output, '\n')
    " CMake commands start with 2 blanks and then a lowercase letter
    if c =~ '^\W\W[a-z]\+'
      if word != ''
        call cmakecomplete#AddWord(word, info)
      endif
      let info = ''
      let word = c
    else
      " if we have a command, then the rest is the help
      if word != ''
        " End of the help is marked with line of dashes
        " But only after getting at least one command
        if c =~ '^-\+$'
          break
        endif
        let info = info . c . "\n"
      endif
    endif
  endfor
  " add the last command to the list
  if word != ''
    call cmakecomplete#AddWord(word, info)
  endif
endfunction

function! cmakecomplete#Complete(findstart, base)
  if a:findstart == 1
    " first time, wants to know where the word starts
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '[a-zA-Z_]'
      let start -= 1
    endwhile
    return start
  else
    " return the completion words
    let res = []
    let match = '^' . tolower(a:base)
    for m in s:cmake_items
      if m['word'] =~ match
        call add(res, m)
      endif
    endfor
    " problem here: always returns lower case
    return res
  endif
endfunction
call cmakecomplete#Init()
