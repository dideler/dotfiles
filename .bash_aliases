# A list of some useful (and not so useful) aliases for bash.
# If an alias requires special usage (e.g. an argument) it will say so in the
# comments. Otherwise assume that the alias requires no arguments.

alias ..='cd ..'
alias ...='cd ../..'
alias aliasloc='/home/dennis/.bash_aliases'
alias addgpl='wget -q http://www.gnu.org/licenses/gpl.txt -O LICENSE'
alias addcrapl='wget -q http://matt.might.net/articles/crapl/CRAPL-LICENSE.txt -O LICENSE'
alias bbc='ssh 192.168.1.2'
alias clr='echo "BAD DENNIS! Use ctrl+L"'
alias cls='clear; ls'
alias distro='cat /etc/*-release' # 'lsb_release -rd' also works
alias grep='grep --colour'
alias rgrep='rgrep --colour'
alias ipconfig='ifconfig'
alias l='ls -rt'
alias la='ls -A'
alias ll='ls -l'
alias ls='ls --color=auto'
alias lsg='ls | grep'
alias lsp='ls -1 /var/log/packages/ > package-list'
alias na='nano -c'
alias nano='nano -c'
alias sandcastle='ssh di07ty@sandcastle.cosc.brocku.ca'
alias sano='sudo nano'
alias tarbz2='tar -jxvf'
alias targz='tar -zxvf'
alias temp='sensors 2>/dev/null'
alias thoughtstack='java -jar ThoughtStack.jar'
alias ins='sudo apt-get install'
alias install='sudo apt-get install'
alias upd='sudo apt-get update'
alias update='sudo apt-get update'
alias upg='sudo apt-get upgrade'
alias upgrade='sudo apt-get upgrade'
alias rem='sudo apt-get remove' # Just removes the package.
alias remove='sudo apt-get remove' # Just removes the package.
alias purge='sudo apt-get purge' # Completely removes a package and its configuration files.
alias rep='sudo add-apt-repository' # Add a new PPA to the repository.
alias repository='sudo add-apt-repository'
alias web='links -g -download-dir ~/ www.google.com'
alias execbin='chmod +x'
alias bookmarks='nano /home/dennis/.gtk-bookmarks'
alias xmleditor='cd /opt/bin/; ./serna-free-4.2'
alias mp='mplayer -quiet -playlist' # For playing a playlist, such as .pls.
alias m='mplayer -quiet'
alias md5='md5sum'
alias cman='man 3'
alias lsd='ls -d */' # List only directories in current directory.
alias disk='df -hT' # Disk space + file system type.
alias ram='free -m' # RAM usage in MB.
alias javadecompiler='/home/dennis/Downloads/jd-gui'
alias t='python ~/.t/t.py --task-dir ~/tasks --list tasks'
alias updatesite='scp index.html di07ty@sandcastle.cosc.brocku.ca:public_html/'
alias pngcrush='pngcrush -rem alla -reduce -brute'
alias mac='ifconfig | grep HWaddr'
alias convertvideo='mencoder -oac mp3lame -ovc lavc -o' # example: convertvideo video.ogg output.avi
alias minecraft='java -Xmx1024M -Xms512M -cp Downloads/minecraft.jar net.minecraft.LauncherFrame'
alias dirsize='du -ch | grep total | cut -f 1'  # Total size of the current directory (human readable)
alias size='du -h' # Human readable size of the file/directory you pass it.
alias units='units --verbose'
alias pinknoise='play -t sl -r48000 -c2 - synth -1 pinknoise tremolo .1 40 <  /dev/zero'
alias whitenoise='cat /dev/urandom | aplay -f cd'
alias snipe='ps -x | grep' # Snipe an unresponsive process to get its pid to kill it.
alias external_ip='curl ifconfig.me'

alias eth0ip="/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print \"eth: \" \$1}'"
# Shows your wired IP address.

alias wlan0ip="/sbin/ifconfig wlan0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print \"wlan: \" \$1}'"
# Shows your wireless IP address.

alias serve='eth0ip; wlan0ip; python -m SimpleHTTPServer'
# Serves current directory on local network, port 8000.

alias broadcast='echo "Client can watch your terminal live with '\''nc your_ip 5000'\''.";
                 script -qf | tee >(nc -l -p 5000)'
# Streams your terminal for others to view.
# Warning: NOT YET TESTED
# Note: Supposedly to broadcast over UDP on port 5000, use:
#       script -qf >(nc -ub 192.168.1.255 5000)

alias pushhh='pushd $@ > /dev/null'
# Silence pushd. Error messages appear on stderr.
# Usage: pushd dir1, dir2, ...

alias imagify='jp2a --colors'
# Displays a JPEG image as coloured ASCII in stdout.
# Usage: imagify file1, file2, ...

alias vi='vi -O'
# Vertical-split windows if multiple files given.
# Usage: vi file1, file2, ...

alias combineimgs='convert +append'
# Combines images horizontally (side-by-side).
# Usage: combineimgs infile1, infile2, ..., outfile

alias combinepdfs='convert -density 200'
# Combines PDFs vertically.
# Usage: combinepdfs infile1, infile2, ..., outfile

alias spaces2tabs="sed -i 's/ \+ /\t/g'"
# Replaces multiple spaces with a tab.
# Usage: spaces2tabs textfile

alias chromecache='cd ~/.cache/google-chrome/Default/Cache/ && file $(ls -rt | tail)'
# Brings you to Chrome's cache directory and shows filetypes for recent files.

alias showpkg='apt-cache showpkg'
# Shows some general information for a single package.
# Usage: showpkg package_name

alias search='apt-cache search'
# Searches the package list for a regex pattern.
# Usage: search some_pattern

alias copysshkey="xclip -sel clip < ~/.ssh/id_rsa.pub && echo 'copied to cliboard'"
# Copies your ssh key to your clipboard.

alias remove='rm -iv'
# A safer rm. Prompts you and tells you what has been deleted.
# Usage: remove file1, file2, ...

alias kernelversion="uname -mrs"
# Shows the Linux kernel version (e.g. Linux 3.2.0-38-generic x86_64)

alias restartshell='exec $SHELL'
# Restarts the shell so new changes can take effect.

alias difference='grep --fixed-strings --line-regexp --invert-match --file'
# Shows the difference between two text files, one item per line.
# Usage: difference file1 file2
# Notes:
#   Shorthand: grep -Fxvf
#   Alternative: comm -13 <(sort file1) <(sort file2)
#   Alternative: diff file1 file2 | grep '>'

alias bitch,='sudo'
# Sometimes your computer doesn't obey unless you threaten it.

alias copy='xclip -selection clip <'
# Copies the contents of a text file to your clipboard.
# Assumes you're running X.
# Usage: copy file

### Git aliases (some from @holman)
alias gl='git log --oneline --decorate' # Also shows tags!
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push origin HEAD'
alias gd='git diff'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -a'
alias gcam='git commit -am'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status -sb' # Upgrade your git if -sb breaks for you.
alias ga='git add'
#alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
alias grm="gs | grep ' D ' | sed 's/^ D //' | xargs git rm" # Holman's version doesn't handle whitespaces.
alias ggrep='git grep --line-number --heading --break --show-function' # greps files tracked with git.
alias gcb="gb | grep \* | sed 's/^* //'" # Show git's current branch.
alias gup='git fetch --all && git rebase --rebase-merges origin/$(gcb)' # A friendlier git pull --rebase.

################################################################################
# Functions
#
# - Note that the keyword 'function' is optional and so is '()'.
# - Style guide: http://google-styleguide.googlecode.com/svn/trunk/shell.xml
################################################################################

# Recursively finds and deletes any files/dirs with the matching name.
# E.g. find-and-delete '*.pyc'
function find-and-delete
{
  find . -name "$1" -delete
}

# Gives you a bunch of info about your machine, using uname.
function computer-info
{
  echo "kernel-name: $(uname --kernel-name)"
  echo "nodename: $(uname --nodename)"
  echo "kernel-release: $(uname --kernel-release)"
  echo "kernel-version: $(uname --kernel-version)"
  echo "machine: $(uname --machine)"
  echo "processor: $(uname --processor)"
  echo "hardware-platform: $(uname --hardware-platform)"
  echo "operating-system: $(uname --operating-system)"
}

# Silently pushes directories when 'pd' is used with arguments,
# otherwise uses 'cd' to bring you to your home directory.
function pd
{
  if (("$#" > 0)); then
    pushd "$@" > /dev/null
  else
    cd $HOME
  fi
}

# Removes duplicate lines from a file.
# Usage: removedupes infile outfile
# Notes: Similar to 'sort <file> | uniq' but faster and can handle larger input.
#        Also preserves original order (sort | uniq doesn't).
function removedupes
{
  awk '!x[$0]++' "$1" > "$2"
}

# Shows the current git branch. Alternative to gcb alias.
function git_current_branch()
{
  git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///'
}

#function gacm {
#
#} # git add & git commit -m

# Temporary function, ignore for now. FIXME
function e {
  #  echo $@
  #  echo $1

  ARG_COUNT=$#
  echo "$ARG_COUNT"

#  if [[ $ARG_COUNT -ne 0]]; then
#    for i in `seq 1 $[$ARG_COUNT - 1]`; do
#      echo $i
#    done
#    CMT_MSG=${!#}  # Grab the last argument as the commit message
#    echo $CMT_MSG
#  else
#    echo 'Please specify the files you want to stage and the commit message.'
#  fi
}
