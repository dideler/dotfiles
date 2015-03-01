set fish_greeting # Clear greeting

# Show ANSI colour sequences in less when viewing man pages.
# http://en.wikipedia.org/wiki/ANSI_escape_code#CSI_codes
set -x LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
set -x LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
set -x LESS_TERMCAP_me \e'[0m'           # end mode
set -x LESS_TERMCAP_so \e'[33;5;246m'    # begin standout-mode - e.g. search result
set -x LESS_TERMCAP_se \e'[0m'           # end standout-mode
set -x LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline
set -x LESS_TERMCAP_ue \e'[0m'           # end underline


# Set Vim as editor if no default is set.
if not set --query EDITOR
  set --export EDITOR vim
end

# Install rbenv and friends if needed.
# Note: Anything RVM related should be fully removed for rbenv to work.
if not type rbenv >/dev/null  # rbenv not installed
  switch (uname)
    case 'Linux'
      setup-linux
    case 'Darwin'
      brew update
      brew install --HEAD rbenv ruby-build rbenv-default-gems
      # TODO: Does homebrew modify PATH for rbenv bins or do we still have to do that?
      echo "To update rbenv and ruby-build, brew update; and brew upgrade rbenv ruby-build"
    case '*'
      echo "OS not recognized, skipping auto-installation of rbenv."
  end
end

# Load rbenv automatically.
# Make sure your PATH includes rbenv and ruby-build.
# set --universal fish_user_paths $fish_user_paths ~/.rbenv/bin ~/.rbenv/plugins/ruby-build/bin
status --is-interactive; and . (rbenv init -|psub)

# TODO: Also set up https://github.com/yyuu/pyenv (it's Python's rbenv )

##########
# Aliases
##########
# A list of some useful (and not so useful) aliases.
# If an alias requires special usage (e.g. an argument) it will say so in the
# comments. Otherwise assume that the alias requires no arguments.

alias be 'bundle exec'

alias less 'less -r' # Recognize escape sequences (e.g. read --help | less).

alias alert 'notify-send --urgency=low --icon=(test $status = 0; and echo terminal; or echo error)'
# An "alert" for long running commands. Icon is determined by exit status.
# E.g. sleep 10; alert title message

alias mp 'mplayer -really-quiet -playlist' # For playing a playlist.

alias ... 'cd ../..'

alias addgpl 'wget -q http://www.gnu.org/licenses/gpl.txt -O LICENSE'

alias addcrapl 'wget -q http://matt.might.net/articles/crapl/CRAPL-LICENSE.txt -O LICENSE'

alias clr 'echo "BAD DENNIS! Use ctrl+L"'

alias cls 'clear; and ls'

alias distro 'cat /etc/os-release | head --lines=2'
# 'lsb_release -rd' also works but doesn't contain the distro's codename.

#alias grep grep --colour' # TODO

#alias rgrep rgrep --colour' # TODO

alias ipconfig ifconfig

alias l 'ls -rt'

#alias la ls -A'

#alias ll ls -l'

#alias ls ls --color=auto'

#alias lsg ls | grep'

#alias lsp ls -1 /var/log/packages/ > package-list'

alias nano 'nano --const' # Constantly show the cursor position in nano.

alias sandcastle 'ssh di07ty@sandcastle.cosc.brocku.ca'

alias temp 'sensors 2>/dev/null'

alias ins 'sudo apt-get install'

alias install 'sudo apt-get install'

alias upd 'sudo apt-get update'

alias update 'sudo apt-get update'

alias upg 'sudo apt-get upgrade'

alias upgrade 'sudo apt-get upgrade'

alias rem 'sudo apt-get remove' # Removes the package.

alias remove 'sudo apt-get remove' # Removes the package.

alias purge 'sudo apt-get purge' # Removes the package and its configuration files.

alias rep 'sudo add-apt-repository' # Add a new PPA to the repository.

alias repository 'sudo add-apt-repository'

alias web 'links2 -g -download-dir ~/Downloads/ www.google.com'
# Browse the web in a basic browser.

alias bookmarks 'eval $EDITOR /home/dennis/.gtk-bookmarks'
# Opens the file with your bookmarked directories.

alias md5 md5sum

alias cman 'man 3' # Manual pages from the library section.

alias disk 'df --human-readable --total --print-type' # Disk space + file system type.

alias show-ram 'free --human' # RAM usage in human-readable form.

alias java-decompiler '/usr/local/bin/jd-gui'

alias t 'python ~/.t/t.py --task-dir ~/tasks --list tasks'

alias update-di07ty 'scp index.html di07ty@sandcastle.cosc.brocku.ca:public_html/'

alias pngcrush 'pngcrush -rem alla -reduce -brute'
# pngcrush is best used when the options are optimized for the image.
# For something easier, try an online tool like http://kraken.io.
# Update: pngquant has slightly lower quality but much better compression.

alias mac 'ifconfig | grep HWaddr | awk \'{print $1 " " $5}\''
# Shows the MAC address of your network devices.

alias convertvideo 'mencoder -oac mp3lame -ovc lavc -o'
# example: convertvideo video.ogg output.avi

alias minecraft 'java -Xmx1024M -Xms512M -cp ~/games/minecraft.jar net.minecraft.LauncherFrame'

alias dirsize 'du -ch | grep total | cut -f 1'
# Total size of the current directory (human readable)

alias size 'du --human-readable'
# Human readable size of the file/directory you pass it.

alias units 'units --verbose'
# Converts units (e.g. kg to lbs).

alias pinknoise 'play -t sl -r48000 -c2 - synth -1 pinknoise tremolo .1 40 <  /dev/zero'

alias whitenoise 'cat /dev/urandom | aplay -f cd'

alias snipe 'ps xw | grep --ignore-case'
# Handy for finding a process (e.g. when it's unresponsive).

alias external_ip 'curl ifconfig.me'
alias externalip 'curl icanhazip.com'

alias eth0ip "/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print \"eth: \" \$1}'"
# Shows your wired IP address.

alias wlan0ip "/sbin/ifconfig wlan0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print \"wlan: \" \$1}'"
# Shows your wireless IP address.

alias serve 'eth0ip; and wlan0ip; and python -m SimpleHTTPServer'
# Serves current directory on local network, port 8000.

alias broadcast 'echo "Client can watch your terminal live with \'nc your_ip 5000\'."; and script -qf | tee >(nc -l -p 5000)'
# Streams your terminal for others to view.
# Warning: NOT YET TESTED. Do not use for pair programming!
# Note: Supposedly to broadcast over UDP on port 5000, use:
#       script -qf >(nc -ub 192.168.1.255 5000)

alias imagify 'jp2a --colors'
# Displays a JPEG image as coloured ASCII in stdout.
# Also check out picture-tube which is for PNGs.
# Usage: imagify file1, file2, ...

alias vi 'vi -O'
# Vertical-split windows if multiple files given.
# Usage: vi file1, file2, ...

alias combineimgs 'convert +append'
# Combines images horizontally (side-by-side).
# Usage: combineimgs infile1, infile2, ..., outfile

alias combinepdfs 'convert -density 200'
# Combines PDFs vertically.
# Usage: combinepdfs infile1, infile2, ..., outfile
# Alternatives: pdfunite, pdftk

alias spaces2tabs "sed -i 's/ \+ /\t/g'"
# Replaces multiple spaces with a tab.
# Usage: spaces2tabs textfile

alias chromecache 'cd ~/.cache/google-chrome/Default/Cache/; and file (ls -rt | tail)'
# Brings you to Chrome's cache directory and shows filetypes for recent files.

alias showpkg 'apt-cache showpkg'
# Shows some general information for a single package.
# Usage: showpkg package_name

alias search 'apt-cache search'
# Searches the package list for a regex pattern.
# Usage: search some_pattern

alias copysshkey "xclip -sel clip < ~/.ssh/id_rsa.pub; and echo 'copied to cliboard'"
# Copies your ssh key to your clipboard.

alias rmiv 'rm -iv' # Prompt before clobbering and be verbose.
alias cpiv 'cp -iv'
alias mviv 'mv -iv'

alias kernelversion "uname -mrs"
# Shows the Linux kernel version (e.g. Linux 3.2.0-38-generic x86_64)

alias restartshell 'eval exec $SHELL'
# Restarts the shell so new changes can take effect.

alias difference 'grep --fixed-strings --line-regexp --invert-match --file'
# Shows the difference between two text files, one item per line.
# Usage: difference file1 file2
# Notes:
#   Shorthand: grep -Fxvf
#   Alternative: comm -13 <(sort file1) <(sort file2)
#   Alternative: diff file1 file2 | grep '>'

alias bitch, sudo
# Sometimes your computer doesn't obey unless you threaten it.

#alias node 'env NODE_NO_READLINE=1 rlwrap -pGreen -S ">>> " node'
# Get history from previous node REPLs and use a better prompt, at the expense
# of losing coloured output and variable autocompletion.

alias du 'du --total --human-readable --max-depth=1'
# Show the size of all items in current directory (and not any lower).
# Shorthand: du -chd 1

alias which 'which -a'
# Show all matches.

alias symlink 'ln -sf'
# Forcefully create a symbolic link between files.
# Useful for large files and scripts with a pointer to /usr/local/bin/.
# Usage: symlink /path/to/file.txt /path/to/file-pointer

alias rcp 'rsync -apz'
# A better secure copy for remote and local. Faster and more efficient than scp.
# Preserve files, keep permissions, and compress during transfer.
# Example usage: rcp junk.txt aws:~/

alias lt 'lt ^/dev/null'
# Light Table IDE logs to terminal, but I don't want to see that stuff.

alias ext extract

### Git aliases (some from @holman)
alias gl 'git log --oneline --decorate' # Also shows tags!
alias glog "git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp 'git push origin HEAD'
alias gd 'git diff'
alias gc 'git commit --verbose'
alias gcm 'git commit -m'
alias gca 'git commit -a'
alias gcam 'git commit -am'
alias gco 'git checkout'
alias gb 'git branch'
alias gs 'git status -sb' # Upgrade your git if -sb breaks for you.
alias gsi 'gs --ignored' # Also shows ignored files.
alias ga 'git add'
alias gu 'git add -u'
#alias grm "git status | grep deleted | awk '{print \$3}' | xargs git rm"
alias grm "gs | grep ' D ' | sed 's/^ D //' | xargs git rm" # Holman's version doesn't handle whitespaces.
alias git hub # Git wrapper. See http://defunkt.io/hub/
alias ggrep 'git grep --line-number --heading --break --show-function' # greps files tracked with git.
alias gcb "gb | grep \* | sed 's/^* //'" # Show git's current branch.
alias gup 'git fetch; and git rebase --preserve-merges origin/(gcb)' # A friendlier git pull --rebase.
