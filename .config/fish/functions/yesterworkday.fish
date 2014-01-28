function yesterworkday --description "Used for git standup alias"
  if test (date +%u) = "1"
    echo 'last friday'
  else
    echo 'yesterday'
  end
end
