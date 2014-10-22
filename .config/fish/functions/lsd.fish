# Example usage:
# lsd
# lsd foo
# lsd foo/ bar/

function lsd --description "List all directories under CWD or given paths in a single column"
  set --local argc (count $argv)
  if test $argc -gt 0  # Print dirs under all given paths.
    for dir in $argv
      if test -d $dir
        ls -1d $dir/*/ # | cut -f2
      else
        echo "$dir is not a valid directory"
      end
    end
  else  # Print dirs under CWD.
    ls -1d */ # | cut -f1
  end
end
