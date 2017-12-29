# Usage: copy <file>

function copy --description "Copy the contents of a text file or variable to your clipboard"
  set --local argc (count $argv)
  if test $argc -eq 1
    switch (uname)
      case 'Linux'
        if test -e $argv[1]
          xclip -selection clip < $argv[1]
        else
          printf $argv[1] | xclip -selection clip
        end
      case 'Darwin'
        if test -e $argv[1]
          pbcopy < $argv[1]
        else
          printf $argv[1] | pbcopy
        end
    end
  else
    echo "Well this is embarrassing... I can only copy one file at a time."
  end
end
