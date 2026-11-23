# Worker functions for `compress_jpg.fish`, `compress_png.fish`, and `compress_img.fish`.
# Currently a unified worker for JPG and PNG, but extensible to other formats.

function __img_validate -d "Validate image existence, extension, and MIME type" -a input expected_type
  if not test -f "$input"
    echo "Error: '$input' is not a file" >&2
    return 1
  end

  set -l ext (extension --lower $input)
  set -l file_info (file --brief -- $input)

  switch $expected_type
    case jpg
      if not string match --quiet --regex -- '^jpe?g$' $ext
        echo "Error: '$input' does not have a .jpg/.jpeg extension" >&2
        return 1
      end
      if not string match --quiet -- 'JPEG image data*' $file_info
        echo "Error: '$input' is not a valid JPEG file" >&2
        return 1
      end
    case png
      if test "$ext" != "png"
        echo "Error: '$input' does not have a .png extension" >&2
        return 1
      end
      if not string match --quiet -- 'PNG image data*' $file_info
        echo "Error: '$input' is not a valid PNG file" >&2
        return 1
      end
    case '*'
      echo "Error: Unsupported image type '$expected_type' for '$input'" >&2
      return 1
  end
end

function __img_get_smallest -d "Compress image and return path to smallest result" -a input img_type
  set -l orig_size (file_size_bytes $input)
  if test -z "$orig_size"; or test "$orig_size" -le 0
    echo $input; echo "none"; echo 0; return 0
  end

  set -l temp (mktemp)
  set -l method "none"

  switch $img_type
    case jpg
      if type -q jpegtran; and command jpegtran -copy none -optimize -progressive -outfile $temp $input >/dev/null 2>&1; and test -s $temp
        set method "jpegtran"
      end
    case png
      if type -q pngquant; and command pngquant --speed=1 --force --output $temp -- $input >/dev/null 2>&1; and test -s $temp
        set method "pngquant"
      end
  end

  if test "$method" = "none"
    rm -f -- $temp
    echo $input; echo "none"; echo $orig_size; return 0
  end

  set -l final_size (file_size_bytes $temp)
  set -l reduction_pct (math -s0 "100 - ($final_size * 100 / $orig_size)")
  if test $final_size -ge $orig_size; or test $reduction_pct -lt 1
    rm -f -- $temp
    echo $input; echo "none"; echo $orig_size; return 0
  end

  echo $temp; echo $method; echo $final_size
end

function __img_compress -d "Worker function for image compression" -a input output_path silent expected_type
  set -l img_type $expected_type
  if test -z "$img_type"; or test "$img_type" = "any"
    switch (extension --lower $input)
      case jpg jpeg
        set img_type jpg
      case png
        set img_type png
      case '*'
        echo "Error: Unsupported image format for '$input'" >&2
        return 1
    end
  end

  __img_validate $input $img_type; or return 1

  set -l orig_size (file_size_bytes $input)
  set -l result (__img_get_smallest $input $img_type)
  set -l best $result[1]
  set -l method $result[2]
  set -l final_size $result[3]

  if test "$best" != "$input"
    mv -- "$best" "$output_path"
  else if test "$output_path" != "$input"
    cp -- "$input" "$output_path"
  end

  if test "$silent" != "1"
    __compress_print_stats $input $orig_size $final_size $method
  end
end
