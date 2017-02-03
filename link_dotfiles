#!/usr/bin/env bash

# Enable error checking.
set -e

# Globals.
script_name=$(basename $0)
force_flag=""
interactive=false
dry_run=false
overwrite_all=false
backup_all=false
skip_all=false

# Fancy logging.
BOLD=$(tput bold)
UNDERLINE=$(tput smul)
REVERSE=$(tput rev)
NORMAL=$(tput sgr0)
BLACK=0 RED=1 GREEN=2 YELLOW=3 BLUE=4 MAGENTA=5 CYAN=6 WHITE=7 # For light colours, use with bold.
background_colour() { tput setab $1; }
font_colour() { tput setaf $1; }

print_bright() { echo -e "${BOLD}$(font_colour $1)${@:2}${NORMAL}"; }
print_path()   { echo "$(font_colour $WHITE)$(pretty_path $1)${NORMAL}"; }
print_info()   { echo -e "\n $(print_bright $YELLOW $@)"; }
print_prompt() { echo -e "\n $(print_bright $BLUE ?)  $@"; }
print_pass()   { echo -e " $(print_bright $GREEN ✔)  $@"; }
print_fail()   { echo -e " $(print_bright $RED ✗)  $@"; }
print_link()   { echo -e "Linked $(print_path $1) $(print_bright $YELLOW ➜)  $(print_path $2)"; }
print_move()   { echo -e "Moved $(print_path $1) $(print_bright $YELLOW ➜)  $(print_path $2)"; }
print_usage()  { echo "Usage: $script_name [-h help] [-f force] [-s skip] [-n dry run] [-i interactive]"; }
print_help()   {
cat <<HELP
$(print_usage)

Symbolically links files in your dotfiles repository with your home directory.

- The actual dotfiles should be in this directory (i.e. dotfiles repo)
- Links to your dotfiles will be created in $HOME
- Directories are not symlinked, but the files within them are
- If a directory in the dotfiles repository doesn't exist in your home directory, it will be created

Steps:
1. Move any dotfiles in HOME that you want symlinked, to your dotfiles
   repository (this directory). If some of your dotfiles are in a directory,
   that directory's structure has to be imitated in your dotfiles repository.
2. Run the link script to create the symlinks.

It's recommended you host your dotfiles repository on a remote code hosting
service (e.g. GitHub, GitLab, BitBucket, private Git server). This will make it easy
for you to use your dotfiles on a new machine. Simply clone the repository then
run the link script.

Flags:
  -h (help)       Prints this help message then exits.
  -f (force)      Forces links by removing existing files with the same link name.
  -s (skip)       Skips files that are already linked.
  -n (dry run)    Prints what would happen without actually performing the actions.
  -i (interactve) Prompts before linking each dotfile.

See the README for more info:  https://github.com/dideler/dotfiles#readme

Copyright (c) 2014-2016 Dennis Ideler
Licensed under the MIT license.
HELP
}

# Returns a pretty pathname.
# Replaces the first part of the pathname with '~' if it is the same as $HOME.
pretty_path() {
  local pathname="$1"
  [[ "$pathname" =~ ^"$HOME"(/|$) ]] && pathname="~${pathname#$HOME}"
  echo "$pathname"
}

# Creates a symbolic link to a file.
link() {
  # All variables declared inside a function will be shared with the calling
  # environment, unless declared local (though they are still shared with called
  # environments). Don't pollute global namespace!
  local relative_filepath="${1:2}"  # Remove leading "./" by extracting substring.
  local homedir="$2"
  local target="$(pwd)/$relative_filepath"  # Original file (absolute filepath).
  local link_name="$homedir/$relative_filepath"  # Pointer file.

  # Linking directories doesn't end well, so we avoid them and only link files.
  # But we create directories in our home directory if they do not exist yet.
  if [[ -d $target ]]; then
    # A directory and file cannot exist at the same level with the same name.
    # Proceeds if any file with that name doesn't exist, instead of a directory.
    if [[ ! -e $link_name ]]; then
      [ "$dry_run" = false ] && mkdir -p $link_name
      print_pass "Created directory $(print_path $link_name)"
    fi
    return  # Directory (or file) now exists in $HOME, move onto the next file.
  fi

  # Before we try to link a file, we should prompt if we're in interactive mode.
  if [ "$interactive" = true ]; then
    print_prompt "Link $(print_path $relative_filepath)? [Y/n]"
    read -n 1 reply
    if [[ "$reply" =~ ^[Nn]$ ]]; then
      echo
      print_fail "Skipping $(print_path $target)"
      return
    fi
  fi

  # Enters conflict resolution if force flag not set and link already exists.
  if [ -z $force_flag ] && [ -f $link_name -o -d $link_name ]; then
    local overwrite=false
    local backup=false
    local skip=false

    # Prompts for current action if no global action is set.
    if [ "$overwrite_all" = false -a "$backup_all" = false -a "$skip_all" = false ]; then
      print_prompt "Destination file already exists for $(print_path $(basename $target))
      Do you want to [${BOLD}${UNDERLINE}s${NORMAL}]kip, [${BOLD}S${NORMAL}]kip all, [${BOLD}o${NORMAL}]verwrite, [${BOLD}O${NORMAL}]verwrite all, [${BOLD}b${NORMAL}]ackup, [${BOLD}B${NORMAL}]ackup all?"
      read -n 1 action && echo
      case "$action" in
        o )
          overwrite=true ;;
        O )
          overwrite_all=true ;;
        b )
          backup=true ;;
        B )
          backup_all=true ;;
        s )
          skip=true ;;
        S )
          skip_all=true ;;
        * )
          print_fail "Unrecognized option, skipping $(print_path $target)"
          skip=true ;;
      esac
    fi

    if [ "$overwrite" = true -o "$overwrite_all" = true ]; then
      [ "$dry_run" = false ] && ln -s -f $target $link_name
      print_pass "Removed existing destination file $(print_path $link_name)"
    fi

    if [ "$backup" = true -o "$backup_all" = true ]; then
      [ "$dry_run" = false ] && mv $link_name $link_name\.backup
      print_pass $(print_move $link_name $link_name.backup)
      [ "$dry_run" = false ] && ln -s $target $link_name
    fi

    if [ "$skip" = true -o "$skip_all" = true ]; then
      print_pass "Skipped $(print_path $target)"
      return
    fi

  else # Don't worry about conflicts, link away!
    [ "$dry_run" = false ] && ln -s $force_flag $target $link_name
  fi

  print_pass $(print_link $link_name $target)
}

# Symbolically links files in your dotfiles repo to your $HOME.
#
# For example, if your dotfiles repo has a file named `.foo`,
# this will create the link: ~/.foo ➜  ~/path/to/dotfiles/.foo
link_dotfiles() {
  print_info "Creating links in $HOME to your dotfiles..."
  local dotfiles=$(find . -type d -name .git -prune -o \
    -not -name $script_name \
    -not -name 'LICENSE' \
    -not -name 'README.md' \
    -not -name '.gitignore' \
    -not -name '.' \
    -print)

  for file in $dotfiles; do  # Known issue: does not work with filenames w/ spaces.
    link $file $HOME
  done
}

parse_args() {
  while getopts 'hfsni' flag; do
    case "${flag}" in
      h)
        print_help
        exit
        ;;
      f)
        force_flag="-f"
        ;;
      s)
        skip_all=true
        ;;
      n)
        print_info "Running in dry (aka pretend) mode. No changes will be made."
        dry_run=true
        ;;
      i)
        interactive=true
        ;;
      *)
        print_usage
        exit
        ;;
    esac
  done
}

main() {
  parse_args "$@"
  link_dotfiles
  print_info "Done!"
}


main "$@"  # Call main and pass args.
