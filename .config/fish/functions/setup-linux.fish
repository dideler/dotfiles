function setup-linux --description "Setup script for Ubuntu Linux"

  # Installs linuxbrew.
  function _setup_homebrew
    if not type brew >/dev/null
      sudo apt-get install build-essential curl git m4 ruby texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev
      curl https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install --location --show-error --output /tmp/install-linuxbrew
      ruby /tmp/install-linuxbrew
      add_to_path ~/.linuxbrew/bin
      # set --universal --export MANPATH ~/.linuxbrew/share/man $MANPATH
      # set --universal --export INFOPATH ~/.linuxbrew/share/info $INFOPATH
      brew doctor
      brew update
    end
    echo "linuxbrew installed"
  end

  # Installs rbenv and friends.
  # Note: Anything RVM related should be fully removed for rbenv to work.
  # Note: rbenv and friends can also be installed via linuxbrew.
  function _setup_rbenv
    if not type rbenv >/dev/null
      git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
      git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
      git clone https://github.com/sstephenson/rbenv-default-gems.git ~/.rbenv/plugins/rbenv-default-gems
      # git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
      # git clone https://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update
      add_to_path ~/.rbenv/bin ~/.rbenv/plugins/ruby-build/bin
      rbenv rehash
      echo "To update rbenv and ruby-build, go into their repos and pull the latest changes."
    end
    echo "rbenv installed"
  end

  function _setup_aliases
    if test -f ~/.config/fish/linux-aliases.fish
      source ~/.config/fish/linux-aliases.fish
      echo "linux aliases installed"
    end
  end

  _setup_homebrew
  _setup_rbenv
  _setup_aliases

end
