function current-branch -d "Shows the current git branch. Alternative to gcb alias."
  git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///'
end
