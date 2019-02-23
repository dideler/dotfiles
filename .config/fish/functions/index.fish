function index --description "Shows character indexes of a string"
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
