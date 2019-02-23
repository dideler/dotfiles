function index --description "Shows character indexes of a string"
  argparse 'h/help' -- $argv

  if set --query _flag_help
    echo "Usage: index [OPTION] [STRINGS]"
    echo
    echo "Description:"
    echo "    Prints the index of characters in a string."
    echo "    Sensitive strings can be given as a prompt,"
    echo "    to avoid appearing in the shell's history."
    echo
    echo "Examples:"
    echo
    echo "    \$ index ab cd"
    echo "    1: a"
    echo "    2: b"
    echo
    echo "    1: c"
    echo "    2: d"
    echo
    echo "    \$ index"
    echo "    ▶ ●●●"
    echo "    1: x"
    echo "    2: y"
    echo "    3: z"
    echo
    echo "Options:"
    echo "    -h, --help      Prints help and exits"
    return 0
  end

  set --local argc (count $argv)

  if test $argc -eq 0
    read --silent --prompt-str="▶ " --local secret
    set --local chars (string split '' $secret)

    for i in (seq (count $chars))
      echo $i: $chars[$i]
    end
  else
    set --local input $argv[1]

    for arg_i in (seq $argc)
      set --local chars (string split '' $argv[$arg_i])

      for i in (seq (count $chars))
        echo $i: $chars[$i]
      end

      test $arg_i -lt $argc && echo
    end
  end
end
