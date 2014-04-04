function split-filename-extension --description "Prints the filename and extension"
  for file in $argv
    if test -f $file
      set --local extension (echo $file | awk -F. '{print $NF}')
      set --local filename (basename $file .$extension)
      echo "$filename $extension"
    else
      echo "$file is not a valid file"
    end
  end
end
