function remove_from_user_path --description "Removes the given paths from fish_user_paths"
  for path in $argv
    if set --local index (contains --index $path $fish_user_paths)
      set --erase --universal fish_user_paths[$index]
    end
  end
end
