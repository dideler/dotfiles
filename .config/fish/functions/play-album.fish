function play-album --description "Plays an album of songs"
  if test -d $argv[1]
    pushd $argv[1]
    mplayer -msgcolor -quiet **.{mp3,m4a} | sed -n -e 's/Playing //p'
    popd
  else
    echo "What is this? Pass me a directory with songs so I can play sweet music to your ears ♫"
    return 1
  end
end
