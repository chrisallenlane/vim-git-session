" =============================================================================
" File: gitsession.vim
" Description: A 'git-aware' session-manager for Vim.
" Mantainer: Chris Allen Lane (https://chris-allen-lane.com)
" Url: https://github.com/chrisallenlane/vim-git-session
" License: MIT
" Version: 1.0.0
" Last Changed: March 28, 2020
" =============================================================================

" saves a session
"{{{
function! gitsession#save()
  " assert that the plugin is properly configured
  if s:configured() == 0
    return
  endif

  " get the session file
  let sessfile = s:sessionFile()

  " If NERDTree is open when a session is saved, the session file will not
  " re-load cleanly. Consequently, we'll close each open NERDTree instance
  " before saving the session:
  "
  " https://github.com/preservim/nerdtree/issues/337
  if exists(':NERDTree')
    let curTab=tabpagenr()
    tabdo NERDTreeClose
    execute 'tabn ' . curTab
  endif

  " save the session
  try
    execute 'mksession!' sessfile
    call s:info('saved session:', sessfile)
  catch /.*/
    call s:warn('session save error:', sessfile)
    call s:warn(v:exception)
  endtry

  " TODO: it would be nice to restore closed NERDTree instances, but this
  " likely involves some complexity
endfunction
"}}}


" loads a session
"{{{
function! gitsession#load()
  " assert that the plugin is properly configured
  if s:configured() == 0
    return
  endif

  " get the session file
  let sessfile = s:sessionFile()

  " notify the user if the session file does not exist
  if filereadable(sessfile) == 0
    call s:warn('file does not exist:', sessfile)
    return
  endif

  " otherwise, load the file
  try
    execute 'silent source ' . sessfile
    call s:info('loaded session:', sessfile)
  catch /.*/
    call s:warn('session load error:', sessfile)
    call s:warn(v:exception)
  endtry
endfunction
"}}}


" removes the current session file
"{{{
function! gitsession#remove()
  " assert that the plugin is properly configured
  if s:configured() == 0
    return
  endif

  " get the session file
  let sessfile = s:sessionFile()

  " notify the user if the session file does not exist
  if filereadable(sessfile) == 0
    call s:warn('file does not exist:', sessfile)
    return
  endif

  " remove the session file
  try
    call delete(fnameescape(sessfile))
    call s:info('deleted session:', sessfile)
  catch
    call s:warn('session delete error:', sessfile)
    call s:warn(v:exception)
  endtry
endfunction
"}}}


" helper function that computes session file name
"{{{
function! s:sessionFile()
  return printf('%s/%s-%s.vim', s:sessionDir(), s:repo(), s:branch())
endfunction
"}}}


" helper function that tidies the `g:gitsession_session_dir` value
"{{{
function! s:sessionDir()
  return expand(substitute(g:gitsession_session_dir, '/$', '', ''))
endfunction
"}}}
"


" helper function that returns the name of the current repository
"{{{
function! s:repo()
  return trim(system('basename `git rev-parse --show-toplevel`'))
endfunction
"}}}


" helper function that returns the name of the current branch
"{{{
function! s:branch()
  return trim(system('git rev-parse --abbrev-ref HEAD'))
endfunction
"}}}


" helper that asserts that the plugin has been properly configured
"{{{
function! s:configured()
  " assert that `g:gitsession_session_dir` is not empty
  if exists('g:gitsession_session_dir') == 0
    call s:warn('`g:gitsession_session_dir` is not set: cannot save or load sessions')
    return 0
  endif

  " assert that `git` is available on the `$PATH`
  if executable('git') == 0
    call s:warn('`git` is not available on the $PATH')
    return 0
  endif

  " if we make it here, we're properly configured
  return 1
endfunction
"}}}


" helper function that displays info
"{{{
function! s:info(...)
  echom 'vim-git-session:' join(a:000)
endfunction
"}}}


" helper function that displays a warning
"{{{
function! s:warn(...)
  echohl WarningMsg
  echom 'vim-git-session:' join(a:000)
  echohl None
endfunction
"}}}
