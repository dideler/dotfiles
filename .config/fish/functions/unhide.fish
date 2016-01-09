function unhide -d "Remove leading dot from all hidden files and dirs, except .git and .gitignore"
  find . \( -iname ".*" ! -iname ".git" ! -iname ".gitignore" \) -print0 | xargs -r0 rename -v 's|/\.+([^/]+)$|/$1|'
end
