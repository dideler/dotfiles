function mouse-spiral --description "Weeee"
  bash -c 'x=0; y=0; while [[ $y -lt 500 ]]; do xdotool mousemove --polar $x $y; x=$(($x+3)); y=$(($y+1)); sleep 0.001; done'
end
