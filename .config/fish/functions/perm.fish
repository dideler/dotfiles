function perm --description="File permissions in human readable and octal form"
  command -v gstat >/dev/null; and begin
    gstat --format="%A %a %n" $argv
  end; or echo "Install GNU stat with Homebrew: `brew install coreutils`"
end
