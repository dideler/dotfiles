function sounds --description "Plays non-distracting sounds & songs"
  pushd ~/Desktop/Dropbox/Worktunes
  mplayer -msgcolor -shuffle -quiet **.{mp3,m4a} | sed -n -e 's/Playing //p'
  popd # FIXME: Doesn't go back to the previous directory.
end
