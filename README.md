vim-git-session
===============
`vim-git-session` wraps `mksession` and `source` to provide a mechanism for
creating sessions that map to the branches of a git repository. This can be
useful when working among several topic branches simultaneously.

Session files will be named according to the following pattern:

    <session-dir>/<repo>-<branch>.vim

The value of `<session-dir>` must be configured via `gitsession_session_dir`.


Example
-------
Assume that you're developing a feature on the `feat-foo` branch when you
receive a high-priority bug report. `vim-git-session` allows you to do the
following:

1. Run `:Save`. This will deterministically generate a name for your session,
   and save the file to a configured location. (`:Save` must first be mapped in
   your `vimrc`.)

2. `git checkout` a bugfix branch, and fix the bug. (You may want to `:Save`
   this session as well.)

3. With the bug fixed, resume feature-development: `git checkout feat-foo`,
   launch `vim`, and run `:Load`. Your initial session will reopen. (`:Load`
   must likewise be configured before use.)

Of course, the above can be accomplished without a plugin, but
`vim-git-session` removes the burden of manually managing session files. You
need simply remember `:Save` and `:Load`. (`:Remove` is also available should
you want to delete a session.)

Configuring
-----------
`vim-git-session` must be configured in `.vimrc`:

```vim
" The path at which your session files should be stored. This directory must
" exist - it will not be created by the plugin
let g:gitsession_session_dir=~/.vim/session

" map commands to save, load, and remove sessions
command Save :call gitsession#save()
command Load :call gitsession#load()
command Remove :call gitsession#remove()
```

It is also recommended to disinclude `folds` from your `sessionoptions` in
order to prevent "fold not found" errors from being thrown:

```vim
set sessionoptions=buffers,curdir,globals,help,tabpages,winsize
```

View [the plugin documentation][doc] for more information.

[doc]: ./doc/vim-git-session.txt
