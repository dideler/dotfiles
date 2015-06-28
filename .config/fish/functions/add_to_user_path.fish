function add_to_user_path --description "Persistently prepends to your PATH via fish_user_paths"
  set --universal fish_user_paths $fish_user_paths $argv
end
