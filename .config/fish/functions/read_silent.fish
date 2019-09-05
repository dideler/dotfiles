function read_silent -d "Read sensitive hidden input into a variable"
  argparse --name=Error 'p/prompt=' 'h/help' -- $argv

  # Gracefully abort on parsing error
  set --local parse_status $status
  test $parse_status -ne 0 && return $parse_status

  if set --query _flag_help
    echo "Usage: read_silent [OPTION] VARIABLE"
    echo
    echo "Description:"
    echo "    Read sensitive information without displaying the characters"
    echo "    on screen. Fish's `read --silent` masks the characters instead of"
    echo "    hiding them. Whereas read_silent hides the characters, similar to"
    echo "    Bash's `read -s`."
    echo
    echo "Options:"
    echo "    -h, --help            Prints help and exits"
    echo "    -p STR, --prompt=STR  Uses the string as the prompt"
  end

  set --local argc (count $argv)

  if test $argc -eq 1
    echo -n $_flag_prompt

    stty -echo
    head -n 1 | read -g $argv[1]
    stty echo
  else
    echo "Error: read_silent requires a single variable to store the input"
    return 1
  end
end
