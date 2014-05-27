function git-new-branch --description "Create a new branch and opens a Pull Request for it"
  git checkout -b $argv[1]
  git commit --allow-empty -m 'Empty commit to open PR'
  git push origin HEAD
  git pull-request  # Opens your default text editor. Uses hub.
end
