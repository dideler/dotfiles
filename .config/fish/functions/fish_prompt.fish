function fish_prompt
  # Override builtin prompt_pwd to avoid excessive shortening of cwd.
  function prompt_pwd
    echo $PWD | sed -e "s|^$HOME|~|"
  end

  # Line 1
  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)
  set_color normal

  # Line 2
  echo
  if test $VIRTUAL_ENV
    printf "(%s) " (set_color blue)(basename $VIRTUAL_ENV)(set_color normal)
  end
  printf '↪ '
  set_color normal
end
