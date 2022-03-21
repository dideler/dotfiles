# dideler dotfiles

## Usage

The [link](link) script will symlink all the files in the repository to your
$HOME (except any that are specified to be excluded, see the script source).

The symlinks will contain the same names as the files in your repo, and
mirror the same directory structure if they happen to reside in directories.

```
$ ./link_dotfiles -h
Usage: link_dotfiles [-h help] [-f force] [-s skip] [-n dry run] [-i interactive]

Symbolically links files in your dotfiles repository with your home directory.

- The actual dotfiles should be in this directory (i.e. dotfiles repo)
- Links to your dotfiles will be created in /Users/dideler
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
```

## Using this project as a template for your own dotfiles

If you have dotfiles that you want to include in your dotfiles repo, you'll have to
manually copy/move them over to the repo and then run the script to link them.

In some situations you may want to add only a few dotfiles in a directory
instead of all of them. For example, you want to symlink most of your
`~/.config` contents and put them on GitHub but there is a file `ignore_me` that
you don't want to touch:

```
/home/dennis/.config
|-- fish
|   |-- config.fish
|   `-- functions
|       |-- 1.fish
|       |-- 2.fish
|       `-- 3.fish
`-- ignore_this_file
```

One way is to recursively copy the common ancestor directory to your
dotfiles repo and remove the stuff you don't want symlinked and on GitHub.

```
cp -rip ~/.config ~/github/dotfiles
cd ~/github/dotfiles
rm -rf .config/ignore_me
./link  # Et voila!
```

So the `.config` directory in your dotfiles repo would look something like:

```
/home/dennis/github/dotfiles/.config
|-- fakefish
    |-- config.fakefish
    `-- fakefunctions
        |-- 1.fakefish
        |-- 2.fakefish
        `-- 3.fakefish
```

---

My bash files are no longer being maintained,
I've switched to the [fish shell](http://www.fishshell.com).
