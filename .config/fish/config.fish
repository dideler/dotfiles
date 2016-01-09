set fish_greeting  # Clear greeting

if not set --query FIRST_RUN  # Note: can reset later with `set --erase`.
  set --universal --export FIRST_RUN (date)
  set --universal --export EDITOR vim
  set --universal --export GIT_EDITOR vim

  # Friendly colours for `ls` output.
  set -Ux LSCOLORS ExfxcxdxBxegedabagacad

  # Show ANSI colour sequences in less when viewing man pages.
  # http://en.wikipedia.org/wiki/ANSI_escape_code#CSI_codes
  set -Ux LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
  set -Ux LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
  set -Ux LESS_TERMCAP_me \e'[0m'           # end mode
  set -Ux LESS_TERMCAP_so \e'[33;5;246m'    # begin standout-mode - e.g. search result
  set -Ux LESS_TERMCAP_se \e'[0m'           # end standout-mode
  set -Ux LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline
  set -Ux LESS_TERMCAP_ue \e'[0m'           # end underline
end

# Load rbenv automatically.
status --is-interactive; and source (rbenv init -|psub)

### Aliases

alias ... 'cd ../..'
alias be 'bundle exec'
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
alias t 'python ~/.t/t.py --task-dir ~/tasks --list tasks'
alias textedit 'open -a TextEdit'
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


### Git aliases
alias gl 'git log --oneline --decorate' # Also shows tags!
alias gg 'git log --graph --date=relative'
alias glog "git log --graph \
            --abbrev-commit \
            --date=relative \
            --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset'"
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
alias grm "gs | grep ' D ' | sed 's/^ D //' | xargs git rm"
alias git hub
alias ggrep 'git grep --line-number --heading --break --show-function'
alias gup 'git fetch; and git rebase --preserve-merges origin/(git_branch_name)'

# Anything you don't want to share? Put it in here!
if test -f ~/.config/fish/local.config.fish
  source ~/.config/fish/local.config.fish
end
