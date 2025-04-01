function add_to_user_path --description "Persistently prepends to your PATH via fish_user_paths"
  echo "WARNING: This function is deprecated. Use fish_add_path instead." >&2
  # This function was created before fish v3.2.0 (March 2021), which introduced fish_add_path.
  # `add_to_user_path` - custom, sets path universally by prepending to $fish_user_paths if not already in path
  # `fish_add_path` - does the same, but provided by fish and more robust with more options

  for path in $argv
    if not contains $path $fish_user_paths
      set --universal fish_user_paths $path $fish_user_paths
    end
  end
end
