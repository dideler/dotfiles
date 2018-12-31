function git_is_repo -d "Checks if cwd is in a Git repository"
  test -d .git; or command git rev-parse --git-dir >/dev/null 2>/dev/null
end
