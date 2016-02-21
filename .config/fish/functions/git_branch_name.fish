function git_branch_name -d "Prints name of current git branch"
  command git symbolic-ref --short HEAD ^/dev/null
end
