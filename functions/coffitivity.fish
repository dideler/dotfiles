function coffitivity --description "Loop sounds from a coffee shop and run in the background. Plays at half volume by default."
  if test (count $argv) = 1
    set volume $argv[1]
  else
    set volume 50
  end
  mplayer -really-quiet -loop 0 -volume $volume ~/Music/coffitivity.mp3 </dev/null ^/dev/null &
end
