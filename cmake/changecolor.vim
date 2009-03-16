" Description: Change the color of a syntax thing temporarily
" mkdir .vim/plugin
" cp changecolor.vim .vim/plugin

function! KKTellMe()
  return synIDattr(synID(line("."), col("."), 1), "name")
endfunction

function! KKChangeColor(...)
  let what=KKTellMe()
  if what == ''
    return
  endif
  let thecommand = ":highlight ". what ." ctermfg=".a:1
  if a:0 > 1
    let thecommand = thecommand . " cterm=" .a:2
  endif
  execute thecommand
  echo thecommand
endfunction

command! -nargs=* ChangeColor call KKChangeColor(<f-args>)
