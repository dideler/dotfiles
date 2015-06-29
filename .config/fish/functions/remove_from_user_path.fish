function remove_from_user_path --description "Removes the given path from fish_user_paths"
  set -Ux fish_user_paths (echo $fish_user_paths | sed 's| '$argv[1]'||g')
end
