function remove_from_path --description "Removes the given paths from PATH"
  for path in $argv
    if set --local index (contains --index $path $PATH)
      set --erase PATH[$index]
    end
  end
end
