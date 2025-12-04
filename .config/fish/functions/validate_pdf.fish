function validate_pdf -d "Validate file existence, extension, and type" -a file
  test -f $file \
    && string match -q -- '*.pdf' -- (string lower (basename -- $file)) \
    && string match -q -- 'application/pdf' -- (file --mime-type --brief -- $file) \
    && return 0

  echo "Error: '$file' is not a valid PDF file" >&2
  return 1
end
