function coffitivity --description "Loop sounds from a coffee shop and run in the background"
  mplayer -really-quiet -loop 0 -volume 70 ~/Music/coffitivity.mp3 </dev/null ^/dev/null &
end
