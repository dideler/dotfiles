function loop -d "Usage: loop TIMES COMMAND"
	for i in (seq 1 $argv[1])
    eval $argv[2..-1]
  end
end
