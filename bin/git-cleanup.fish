# TODO: Put in bin/ because these git scripts need to live in PATH
# Visible under `git help -a`
function git-cleanup --description 'Cleans your working copy of untracked files (not directories)'
  git clean --dry-run --force
  read -l -p 'set_color green; echo "Continue? [Yn]"; set_color normal; echo "> "' input
  switch $input
    case '' 'y' 'Y' 'yes' 'Yes' 'YES'
      git clean --force
    case '*'
      return
  end
end
