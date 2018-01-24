let g:python2_host_prog = "/usr/local/bin/python" " substitute(system('which python'), '^\s*\(.\{-}\)\s*$', '\1', '')
let g:python3_host_prog = "/usr/local/bin/python3" " substitute(system('which python3'), '^\s*\(.\{-}\)\s*$', '\1', '')
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
source ~/.nvimrc
