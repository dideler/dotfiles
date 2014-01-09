function fish_prompt

#  function __fish_repaint_cwd --on-variable PWD --description "Event handler, repaint when PWD changes"
#    if status --is-interactive
#      commandline -f repaint ^/dev/null
#    end
#  end

  # Override prompt_pwd so pwd isn't shortened.
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
