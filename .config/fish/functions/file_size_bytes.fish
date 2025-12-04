function file_size_bytes -d "Get file size in bytes" -a file
  if test (uname) = "Darwin"
    stat -f%z $file  # macOS
  else
    stat -c%s $file  # Linux
  end
end
