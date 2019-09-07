function read_silent -d "Read sensitive hidden input into a variable"
  argparse --name=Error 'p/prompt=' 'h/help' -- $argv

  # Gracefully abort on parsing error
  set --local parse_status $status
  test $parse_status -ne 0 && return $parse_status

  function _read_silent_help
    echo "Usage: read_silent [OPTION] VARIABLE"
    echo
    echo "Description:"
    echo "    Reads sensitive information into a variable."
    echo "    The input stays hidden, similar to bash's `read -s` behaviour."
    echo "    Unlike fish's `read -s` which shows masked input characters."
    echo
    echo "Options:"
    echo "    -h, --help            Prints help and exits"
    echo "    -p STR, --prompt=STR  Uses the string as the prompt"
  end

  if set --query _flag_help
    _read_silent_help
  end

  set --local argc (count $argv)

  if test $argc -eq 1
    echo -n $_flag_prompt

    stty -echo
    head -n 1 | read -g $argv[1]
    stty echo
  else
    _read_silent_help
    return 1
  end
end
