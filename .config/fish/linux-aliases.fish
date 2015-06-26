# And with Linux I really mean Ubuntu #dealwithit


alias add-repository 'sudo add-apt-repository'  # Adds the given PPA to the repository.
alias auto-remove 'sudo apt-get auto-remove'
alias chromecache 'cd ~/.cache/google-chrome/Default/Cache/; and file (ls -rt | tail)'  # Shows filetypes for recent files in Chrome's cache.
alias convertvideo 'mencoder -oac mp3lame -ovc lavc -o'  # convertvideo in.ogg out.avi
alias install 'sudo apt-get install'
alias pinknoise 'play -t sl -r48000 -c2 - synth -1 pinknoise tremolo .1 40 <  /dev/zero'
alias purge 'sudo apt-get purge'  # Removes the package and its configuration files.
alias ram 'free --human'  # RAM usage in human-readable form.
alias remove 'sudo apt-get remove'
alias search 'apt-cache search'  # Searches the package list with the given regex pattern.
alias showpkg 'apt-cache showpkg'  # Shows general information for a single package.
alias temp 'sensors 2>/dev/null'
alias update 'sudo apt-get update'
alias upgrade 'sudo apt-get upgrade'
alias whitenoise 'cat /dev/urandom | aplay -f cd'
