function git_branch_name -d "Prints name of current git branch"
  test -d .git; and command git symbolic-ref --short HEAD ^/dev/null
end
