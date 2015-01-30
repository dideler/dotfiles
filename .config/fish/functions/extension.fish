# The reason we make the user pass an option when there are multiple extensions
# instead of auto-detecting it, is because it's less error prone.
# E.g. foo.bar.jpg has one extension, not two. Easier for user to say so.

function extension -d "Returns the extension given a file"

  function _print_usage
    echo -e "Usage:\n  extension foo.bar  # => bar\n  extension --multiple foo.bar.baz  # => bar.baz"
  end

  switch (count $argv)
    case 0
      _print_usage
      return 1

    case 1
      switch $argv
        case '-*'  # Invalid option.
          _print_usage
          return 1

        case '.*' '*.'  # E.g. '.foo' or 'foo.'
          printf "'%s' does not have an extension\n" $argv[1]

        case '*.*'  # Filename has a visible extension.
          echo $argv[1] | awk -F. '{print $NF}'

        case '*'
          printf "'%s' does not have an extension\n" $argv[1]
      end

    case 2
      # Not as robust as case 1. Good enough since case 2 is less likely.
      switch (echo $argv)
        case '* -m' '* --multiple'  # Filename before option
          echo $argv[1] | cut -d "." -f 2-

        case '-m *' '--multiple *'  # Filename after option
          echo $argv[2] | cut -d "." -f 2-

        case '*'
          _print_usage
          return 1
      end
  end
end
