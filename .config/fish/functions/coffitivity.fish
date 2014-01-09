function coffitivity --description "Loop sounds from a coffee shop and run in the background. Plays at half volume by default."
  set volume 50
  set sound ~/Music/coffitivity.mp3
  if test (count $argv) = 1
    set volume $argv[1]
  end
  mplayer -really-quiet -loop 0 -volume $volume $sound </dev/null ^/dev/null &
end
