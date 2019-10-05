function index --description "Shows character indexes of a string"
  argparse --name=Error 'h/help' -- $argv

  set --local parse_status $status
  test $parse_status -ne 0 && return $parse_status

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
    echo "    Secret ▶ ●●●●"
    echo "    Chars  ▶ 2 4"
    echo "    2: x"
    echo "    4: z"
    echo
    echo "    \$ index"
    echo "    Secret ▶ ●●●"
    echo "    Chars  ▶ "
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
    read_silent --prompt="Secret ▶ " secret
    test -z "$secret" && return 1
    set --local chars (string split '' $secret)
    set --erase secret

    read --delimiter=' ' --array --prompt-str="Chars  ▶ " --local indexes

    if test -z "$indexes"
      for i in (seq (count $chars))
        printf '%2d: %s\n' $i $chars[$i]
      end
    else
      for i in $indexes
        printf '%2d: %s\n' $i $chars[$i]
      end
    end
  else
    set --local input $argv[1]

    for arg_i in (seq $argc)
      set --local chars (string split '' $argv[$arg_i])

      for i in (seq (count $chars))
        echo $i: $chars[$i]
      end

      test "$arg_i" -lt "$argc" && echo
    end
  end
end
