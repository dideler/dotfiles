function git-clean --description 'Cleans your working copy of untracked files and directories'
  git clean -dfn
  read -l -p 'set_color green; echo "Continue? [Yn]"; set_color normal; echo "> "' input
  switch $input
    case '' 'y' 'Y' 'yes' 'Yes' 'YES'
      git clean -df
    case '*'
      return
  end
end
