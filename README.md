dotfiles of @dideler
====================

I'd love to hear from you if any of my dotfiles came in handy.

I now use the [dotfiles python package](https://pypi.python.org/pypi/dotfiles).
The documentation for it isn't very detailed, so here are my added notes.

```
pip install dotfiles
dotfiles --help
cd ~/github/dotfiles
dotfiles --sync
```

Interface
---------

`-a, --add FILES`
: Adds existing dotfile(s) to the repository.  
  To be specific: Moves dotfile to your given dotfiles repository, renames
  their prefix according to the prefix setting (default is None, so unhides the
  dotfile by removing the dot), and creates symlink in your home directory.

`-c, --check`
: Lists missing or unsynced dotfiles.  
  Missing if it exists in dotfiles repository and is not being ignored, but not existing in home directory.  
  Unsynced if ...? TODO

`-l, --list`
: Lists currently managed dotfiles (including missing and unsynced).

`-r, --remove FILES`
: Removes dotfile(s) from the repository.  
  To be specific: Undoes an --add action. Removes symlink in your home directory,
  then moves dotfile from your repository to your home directory.

  Using ~/ is optional, prepending files with a dot should be enough.

`-s, --sync FILES`
: Update dotfile symlinks.  
  To be specific: Creates symlink(s) in your home directory for the dotfiles
  specified (all if no arguments passed). All files operated on will become
  hidden in your home directory, but only at the top level. For example,
  /dotfiles/dir/file will be pointed to by ~/.dir/file.

  Overwrite colliding files with -f or --force.

-m, --move <path>
Move dotfiles repository to another location, updating all symlinks in the process.
For all commands you can use the --dry-run option, which will print actions and won't modify anything on your drive.


The [installation](install) script will link all the dotfiles in this
repository to your $HOME. If you're using this repository and have any
dotfiles that you want to include, you'll have to manually move/copy them over
to the repo's directory and then run the script to link them.

My bash files are no longer being maintained,
I've switched to the [fish shell](http://www.fishshell.com).

Some terminal tools I like but aren't dotfiles:
- https://github.com/uams/geturl
- https://github.com/jkbr/httpie
- https://github.com/defunkt/hub
- https://github.com/substack/picture-tube
