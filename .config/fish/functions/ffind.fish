# Note: If query contains spaces, make sure to escape them manually.
function ffind -d "Searches recursively from cwd for files containing the case-insensitive query"
  find . -iname "*"$argv"*" ^/dev/null
end
