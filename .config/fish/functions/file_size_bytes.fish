function file_size_bytes -d "Get file size in bytes" -a file
  if test -z "$file"; or not test -e "$file"
    echo "Error: '$file' does not exist" >&2
    return 1
  end

  if test (uname) = "Darwin"
    command stat -f%z -- $file
  else
    command stat -c%s -- $file
  end
end
