function add_to_path --description "Persistently prepends directories to your PATH"
  set --universal fish_user_paths $fish_user_paths $argv
end
