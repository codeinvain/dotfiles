function! s:tags_sink(line)
  let parts = split(a:line, '\t\zs')
  let excmd = matchstr(parts[2:], '^.*\ze;"\t')
  execute 'silent e' parts[1][:-2]
  let [magic, &magic] = [&magic, 0]
  execute excmd
  let &magic = magic
endfunction

function! FzfTags(term)
  if empty(tagfiles())
    echohl WarningMsg
    echom 'Preparing tags'
    echohl None
    call system('ctags -R')
  endif

  " let trim_tags_cmd = 'cat '.join(map(tagfiles(), 'fnamemodify(v:val, ":S")')). '| ag -s "^'.a:term.'\t+" '. "| awk -F'\t' '{print $4, $1, $5 ? $5 : \"n/a\" , $2 }' | column -t"
  let trim_tags_cmd = 'cat '.join(map(tagfiles(), 'fnamemodify(v:val, ":S")')). '| ag "^'.a:term.'\t+"'
  let tags = split(system(trim_tags_cmd),"\n")
  let tags_count = len(tags)
  if tags_count==0
    echo "No matches found for term '".a:term."'"
    return
  elseif tags_count==1
    execute "tag " .a:term
  else
    call fzf#run({
    \ 'source':  tags,
    \ 'options': '+m -d "\t" --tiebreak=index --with-nth 1,2,4.. --select-1',
    \ 'down':    '20%',
    \ 'sink':    function('s:tags_sink')})
  end
endfunction

nnoremap <C-]> :call FzfTags(expand('<cword>'))<CR>
