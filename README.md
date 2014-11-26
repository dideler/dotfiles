dotfiles of @dideler
====================

I'd love to hear from you if any of my dotfiles came in handy.

The [link](link) script will symlink all the files in the repository to your
$HOME (except the ones that are specified to be excluded--see the script).
The symlinks will contain the same names as the files in your repo, and
mirror the same directory structure if they happen to reside in directories.

**NOTE:** The script only symlinks files, not directories.

If you have dotfiles that you want to include in your dotfiles repo, you'll have to
manually copy/move them over to the repo and then run the script to link them.

In some situations you may want to add only a few dotfiles in a directory
instead of all of them. For example, you want to symlink most of your
`~/.config` contents and put them on GitHub but there is a file `ignore_me` that
you don't want to touch:

```
/home/dennis/.config
|-- fakefish
|   |-- config.fakefish
|   `-- fakefunctions
|       |-- 1.fakefish
|       |-- 2.fakefish
|       `-- 3.fakefish
`-- ignore_me
```

One way way is to recursively copy the common ancestor directory to your
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

Some terminal tools I like but aren't dotfiles:
- https://github.com/uams/geturl
- https://github.com/jkbr/httpie
- https://github.com/github/hub
- https://github.com/substack/picture-tube
- https://github.com/rg3/youtube-dl
