function setup-tools --description "General setup script (compatible with Ubuntu or OS X)"
  pushd ~/github/dideler/dotfiles
  switch (uname)
    case 'Linux'
      setup-linux  # Sets up linuxbrew, rbenv, and aliases.
      brew tap homebrew/bundle
      brew bundle --file=Brewfile.linux
    case 'Darwin'
      setup-mac  # Sets up homebrew, rbenv, aliases, and OS X config.
      brew tap homebrew/bundle
      brew bundle --file=Brewfile.osx
    case '*'
      echo "OS not recognized, skipping OS-specific setup routine."
  end
  popd
  brew bundle
end
