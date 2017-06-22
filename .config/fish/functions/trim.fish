function trim -a file start stop -d "Trims an audio/video file given start and stop times"
  switch $argv[1]
    case -h --help
      echo "Usage: $_ INPUT_FILE START_TIME STOP_TIME"
      echo
      echo "Supported time formats are seconds and hh:mm:ss[.xxx]"
      echo
      echo "Examples:"
      echo "    $_ audio.mp3 10 65"
      echo "    $_ video.mp3 00:00:10 00:01:05"
      echo "    $_ video.mp3 00:00:10.000 00:01:05.000"
      return 0
    case -\*
      echo "Error: '$argv[1]' not a valid option"
      return 1
  end
  # TODO: add guard clauses; valid file, valid time format, etc.

  ffmpeg -loglevel panic -i $file -ss $start -to $stop -c copy trim-$file
  and echo Done! trim-$file
  or echo Oops, something went wrong...

  # TODO: Use following for videos.
  #       Slower due to re-encoding, but ensures audio/video stays in sync.
  # ffmpeg -v 0 -i $file -ss $start -to $stop -async 1 trim-$file
end
