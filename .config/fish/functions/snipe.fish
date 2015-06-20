function snipe --description "Lists found processes with their PIDs for easy sniping"
  if test (count $argv) -eq 1
    printf 'PID\tProcess\n'; and ps xw |\
    grep --ignore-case $argv[1] |\
    awk '{ $2=$3=$4=""; print $0 }' |\
    awk '!/grep/' |\
    sed 's/    /\t/g' |\
    grep $argv[1]
  else
    printf 'Usage: snipe PROCESS\nEach matching process will have its PID printed for easy killing.'
    return 1
  end
end

