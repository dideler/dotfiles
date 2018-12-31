function git_branch_name -d "Prints name of current git branch"
  command git symbolic-ref --short HEAD 2>/dev/null
end
