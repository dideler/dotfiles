function __combineimgs_help
  printf "Usage: combineimgs [OPTIONS] INPUT OUTPUT\n\n"
  printf "OPTIONS:\n\n"
  printf "    -h --help     Show usage and examples\n"
  printf "    --horizontal  Stack images left to right\n"
  printf "    --vertical    Stack images top to bottom (default)\n\n"
  printf "Examples:\n\n"
  printf "    combineimgs photo-1.png photo-2.png memories.png\n"
  printf "    combineimgs drawing-*.jpg comic.jpg --horizontal\n"
end

function combineimgs --description "Combine images"
  set --local options 'h/help' 'horizontal' 'vertical'

  argparse --exclusive="horizontal,vertical" $options -- $argv

  if set --query _flag_help
    __combineimgs_help
    return 0
  end

  set --local argc (count $argv)

  if test $argc -lt 3
    echo "Error: Expected at least 3 args, got $argc" >&2
    __combineimgs_help
    return 1
  end

  set --local input $argv[1..-2]
  set --local output $argv[-1]

  if set --query _flag_horizontal
    magick +append $input $output
  else
    magick -append $input $output
  end
end
