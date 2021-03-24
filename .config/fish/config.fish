set fish_greeting  # Clear greeting

# Ensure fisherman and plugins are installed.
if status --is-interactive; and not test -f $HOME/.config/fish/functions/fisher.fish
  echo "==> Installing Fisherman..."
  curl -sLo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
  fisher
end

set --export EDITOR vim
set --export GIT_EDITOR vim
set --export ERL_AFLAGS "-kernel shell_history enabled" # iex history

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

# Load rbenv
status --is-interactive; and command -v rbenv >/dev/null; and source (rbenv init -|psub)

# Load asdf
status --is-interactive; and source ~/.asdf/asdf.fish

# Load direnv
status --is-interactive; and command -v direnv >/dev/null; and eval (direnv hook fish)

### Abbreviations (expanded aliases)

abbr a 'atom .'
abbr c 'code .'
abbr e 'exa'
abbr g 'git'
abbr be 'bundle exec'
abbr combinepdfs 'pdfunite' # vertical
abbr combineimgs 'convert +append' # horizontal
abbr rg 'rg --follow' # Follow symbolic links (disable with --no-follow)
abbr rgs 'rg --fixed-strings' # Exact match, no regex interpretation
abbr k 'kubectl'
abbr mt 'mtest'
abbr mtt 'mtest --trace'
abbr mx 'mtest --trace --only x'

abbr gd 'git diff'
abbr gds 'git diff --staged'
abbr gc 'git commit'
abbr gcm 'git commit --message'
abbr gca 'git commit --all'
abbr gcam 'git commit -am'
abbr gcp 'git cherry-pick'
abbr gl 'git log --oneline --decorate'
abbr gg 'git log --graph --date=relative'
abbr ggg 'git show --name-only'
abbr ga 'git add'
abbr gap 'git add --patch'
abbr gu 'git add --update'
abbr gan 'git add --intent-to-add'
abbr gco 'git checkout'
abbr gb 'git branch'
abbr gp 'git push origin HEAD'
abbr gpf 'git push origin HEAD --force-with-lease'
abbr gpl 'git pull'
abbr gsl 'git stash list'
abbr gs 'git status --short --branch'
abbr gsi 'git status --short --branch --ignored'
abbr gsw 'git show'

### Aliases (shorthand functions)

alias ... 'cd ../..'
alias cman 'man 3' # Manual pages from the library section.
alias distro 'if test (uname) = "Linux"; cat /etc/os-release | head --lines=2; else; echo "Linux-only command"; end;'
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
alias file1mb 'head -c 1M /dev/urandom' # E.g. file1mb > foo.bin
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
alias otp_version 'erl -eval \'{ok, Version} = file:read_file(filename:join([code:root_dir(), "releases", erlang:system_info(otp_release), "OTP_VERSION"])), io:fwrite(Version), halt().\' -noshell'
alias utc 'date -u'

alias mac 'ifconfig | grep HWaddr | awk \'{print $1 " " $5}\''  # MAC address of your network devices.
alias eth0ip "ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print \"eth: \" \$1}'"  # Wired IP address.
alias wlan0ip "ifconfig wlan0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print \"wlan: \" \$1}'"  # Wireless IP address.
alias serve 'eth0ip; and wlan0ip; and python -m SimpleHTTPServer; or python -m http.server'  # Serves current directory on local network, port 8000.

alias imagify 'jp2a --colors'
# Displays a JPEG image as coloured ASCII in stdout.
# Also check out picture-tube which is for PNGs.
# Usage: imagify file1, file2, ...

# alias combineimgs 'convert +append'
# Combines images horizontally (side-by-side).
# Usage: combineimgs infile1, infile2, ..., outfile

# alias combinepdfs 'convert -density 200'
# Combines PDFs vertically.
# Usage: combinepdfs infile1, infile2, ..., outfile
# Alternatives: pdfunite, pdftk

alias hilite-stdout 'pcregrep --colour --multiline ".|\n"'
# Highlights STDOUT in red so you can differentiate between STDOUT and STDERR.
# Usage: my_prog | hilite-stdout

### Git

alias glog "git log --graph \
            --abbrev-commit \
            --date=relative \
            --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset'"
alias grm "git status -sb | grep ' D ' | sed 's/^ D //' | xargs git rm"
alias git hub
alias ggrep 'git grep --line-number --heading --break --show-function'
alias gup 'git fetch --all; and git rebase --preserve-merges origin/(git_branch_name)'

function gr -d "Checkout a recent git branch"
  set -l preview_cmd 'command git show --name-only -n 5 {}'
  set -l branch (git recent | fzf --header="SELECT BRANCH TO CHECKOUT" --preview=$preview_cmd)
  command git checkout $branch
end

### Elixir

# Returns paths for Elixir test files with staged and unstaged modifications,
# and updated but unmerged modifications (e.g. when resolving merge conflicts).
function wip-elixir-tests
  command git status | \
  egrep 'modified|new file' | \
  sed 's/\tboth modified:   //' | \
  sed 's/\tmodified:   //' | \
  sed 's/\tnew file:   //' | \
  grep '_test.exs' | \
  sort | uniq
end

function normalise_elixir_test_path
  string replace --all --regex 'apps/\w+/' '' "$argv[1]" | string trim
end

# Select WIP Elixir tests files to run. Previews diffs.
# Can select multiple tests to run with TAB or SHIFT+TAB.
function mtest
  set -l opts $argv
  set -l preview_cmd 'command git diff HEAD (string trim {}) | diff-so-fancy'
  set -l wip_test (wip-elixir-tests | fzf --multi --header="SELECT TEST TO RUN" --preview=$preview_cmd)
  set -l test_path (normalise_elixir_test_path "$wip_test $opts")
  set -l cmd "mix test $test_path"
  echo $cmd
  eval $cmd
end

### Ruby

# Returns paths for Ruby spec files with staged and unstaged modifications,
# and updated but unmerged modifications (e.g. when resolving merge conflicts).
function wip_ruby_tests
  command git status | \
  egrep 'modified|new file' | \
  sed 's/both modified://' | \
  sed 's/modified://' | \
  sed 's/new file://' | \
  string trim | \
  grep '_spec.rb' | \
  sort | uniq
end

function normalise_ruby_test_path
  string replace --all --regex 'spec/\w+/' '' "$argv[1]" | string trim
end

# Select WIP Ruby tests files to run. Previews diffs.
# Can select multiple tests to run with TAB or SHIFT+TAB.
abbr rt rtest
function rtest
  set -l opts $argv
  set -l preview_cmd 'command git diff HEAD (string trim {}) | diff-so-fancy'
  set -l wip_test (wip_ruby_tests | fzf --multi --header="SELECT TEST TO RUN" --preview=$preview_cmd)
  set -l test_path "$wip_test $opts"
  set -l cmd "bin/rspec $test_path"
  echo $cmd
  eval $cmd
end

###

# Anything you don't want to share? Put it in here!
if test -f ~/.config/fish/local.config.fish
  source ~/.config/fish/local.config.fish
end

test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish
