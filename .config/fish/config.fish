set fish_greeting  # Clear greeting

# Ensure fisherman and plugins are installed.
if not test -f $HOME/.config/fish/functions/fisher.fish
  echo "==> Installing Fisherman..."
  curl -sLo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
  fisher
end

set --export EDITOR vim
set --export GIT_EDITOR vim
set --export GIT_DUET_ROTATE_AUTHOR false

if not set --query FIRST_RUN
  set --universal FIRST_RUN (date)

  # Friendly colours for `ls` output.
  set --universal LSCOLORS ExfxcxdxBxegedabagacad

  # Show ANSI colour sequences in less when viewing man pages.
  # http://en.wikipedia.org/wiki/ANSI_escape_code#CSI_codes
  set --universal LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
  set --universal LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
  set --universal LESS_TERMCAP_me \e'[0m'           # end mode
  set --universal LESS_TERMCAP_so \e'[33;5;246m'    # begin standout-mode - e.g. search result
  set --universal LESS_TERMCAP_se \e'[0m'           # end standout-mode
  set --universal LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline
  set --universal LESS_TERMCAP_ue \e'[0m'           # end underline
end

# Load rbenv automatically.
status --is-interactive; and command -v rbenv >/dev/null; and source (rbenv init -|psub)

### Abbreviations (expanded aliases)

abbr a 'atom .'
abbr c 'code .'
abbr be 'bundle exec'
abbr l 'ls -t'
abbr t 'todo'

abbr gd 'git diff'
abbr gds 'git diff --staged'
abbr gc 'git commit'
abbr gcm 'git commit --message'
abbr gca 'git commit --all'
abbr gcam 'git commit -am'
abbr gcp 'git cherry-pick'
abbr gl 'git log --oneline --decorate'
abbr gg 'git log --graph --date=relative'
abbr ga 'git add'
abbr gap 'git add --patch'
abbr gu 'git add --update'
abbr gan 'git add --intent-to-add'
abbr gco 'git checkout'
abbr gb 'git branch'
abbr gp 'git push origin HEAD'
abbr gpf 'git push origin HEAD --force'
abbr gpl 'git pull'
abbr gsl 'git stash list'
abbr gs 'git status --short --branch'
abbr gsi 'git status --short --branch --ignored'
abbr gsw 'git show'

### Aliases (shorthand functions)

alias ... 'cd ../..'
alias cman 'man 3' # Manual pages from the library section.
alias distro 'if test (uname) = "Linux"; cat /etc/os-release | head --lines=2; else; echo "Linux-only command"; end'
alias ext extract
alias grep 'grep --color=auto'
alias ipconfig ifconfig
alias kernel 'uname -mrs'  # Shows the kernel version (e.g. Linux 3.2.0 x86_64)
alias less 'less -r' # Recognize escape sequences (e.g. read --help | less).
alias ls-size 'ls -horS'  # List directory contents sorted by increasing size.
alias md5 md5sum
alias mp 'mplayer -really-quiet -playlist'
alias nano 'nano --const'  # Constantly show the cursor position in nano.
alias public-ip 'curl icanhazip.com'
alias rcp 'rsync --archive --perms --compress'  # Faster (remote and local) transfers than scp. Eg: rcp file.txt aws:~/
alias reconfig 'source ~/.config/fish/config.fish'
alias rgrep 'grep --recursive'
alias spaces2tabs "sed -i 's/ \+ /\t/g'"  # Replaces multiple spaces with a tab in the given file.
alias sshkey "copy ~/.ssh/id_rsa.pub; and echo 'Public key copied to clipboard'"
alias textedit 'open -a TextEdit'
alias todo 'todolist'
alias units 'units --verbose'
alias vi 'vim -O'  # Vertically split windows if multiple files given.
alias which 'which -a'  # Show all matches.

alias mac 'ifconfig | grep HWaddr | awk \'{print $1 " " $5}\''  # MAC address of your network devices.
alias eth0ip "ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print \"eth: \" \$1}'"  # Wired IP address.
alias wlan0ip "ifconfig wlan0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print \"wlan: \" \$1}'"  # Wireless IP address.
alias serve 'eth0ip; and wlan0ip; and python -m SimpleHTTPServer'  # Serves current directory on local network, port 8000.

alias imagify 'jp2a --colors'
# Displays a JPEG image as coloured ASCII in stdout.
# Also check out picture-tube which is for PNGs.
# Usage: imagify file1, file2, ...

alias combineimgs 'convert +append'
# Combines images horizontally (side-by-side).
# Usage: combineimgs infile1, infile2, ..., outfile

alias combinepdfs 'convert -density 200'
# Combines PDFs vertically.
# Usage: combinepdfs infile1, infile2, ..., outfile
# Alternatives: pdfunite, pdftk

alias hilite-stdout 'pcregrep --colour --multiline ".|\n"'
# Highlights STDOUT in red so you can differentiate between STDOUT and STDERR.
# Usage: my_prog | hilite-stdout

### Git aliases
alias glog "git log --graph \
            --abbrev-commit \
            --date=relative \
            --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset'"
alias grm "git status -sb | grep ' D ' | sed 's/^ D //' | xargs git rm"
alias git hub
alias ggrep 'git grep --line-number --heading --break --show-function'
alias gup 'git fetch --all; and git rebase --preserve-merges origin/(git_branch_name)'

# Anything you don't want to share? Put it in here!
if test -f ~/.config/fish/local.config.fish
  source ~/.config/fish/local.config.fish
end

test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish
