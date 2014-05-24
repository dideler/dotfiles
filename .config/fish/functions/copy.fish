# Usage: copy <file>

function copy --description "Copy the contents of a text file to your clipboard"
  set --local argc (count $argv)
  if test $argc -eq 1
    xclip -selection clip < $argv[1]
  else
    echo "Well this is embarrassing... I can only copy one file at a time."
  end
end
