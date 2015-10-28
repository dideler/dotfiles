function fish_prompt
  # Built-in prompt_pwd shortens cwd too much for my liking.
  function _prompt_pwd
    echo $PWD | sed -e "s|^$HOME|~|"
  end

  # Line 1
  set_color $fish_color_cwd
  printf '%s' (_prompt_pwd)
  set_color normal

  # Line 2
  echo
  if test $VIRTUAL_ENV
    printf "(%s) " (set_color blue)(basename $VIRTUAL_ENV)(set_color normal)
  end
  printf '↪ '
  set_color normal
end
