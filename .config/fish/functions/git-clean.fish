function git-clean --description 'Cleans your working copy of untracked files (not directories)'
  git clean --dry-run --force
  read -l -p 'set_color green; echo "Continue? [Yn]"; set_color normal; echo "> "' input
  switch $input
    case '' 'y' 'Y' 'yes' 'Yes' 'YES'
      git clean --force
    case '*'
      return
  end
end
