function fish_right_prompt -d "Displays git branch and dirty state on the right"
  set -l cyan (set_color cyan)
  set -l red (set_color red)
  set -l normal (set_color normal)
  set -l yellow (set_color cccc00)
  set -l git_branch (git_branch_name)

  if test $git_branch
    git_is_dirty; and set -l dirty_bit $red '*' $cyan
    echo -ns $cyan '‹' $yellow $git_branch $dirty_bit '›' $normal
  end
end
