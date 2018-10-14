function index -d "Similar to char-index but reads from a prompt"
  read --silent --prompt-str="▶ " --local secret
  set --local chars (string split '' $secret)

  if test (count $argv) -eq 0
    for i in (seq (count $chars))
      echo $i: $chars[$i]
    end
  else
    for i in $argv
      echo $i: $chars[$i]
    end
  end
end
