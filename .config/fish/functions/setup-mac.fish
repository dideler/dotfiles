function setup-mac --description "Setup script for OS X"

  function _setup_homebrew
    echo "Setting up homebrew"
    if not type brew >/dev/null
      ruby -e (curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)
      brew update
    end
  end

  function _setup_rbenv
    echo "Setting up rbenv and friends"
    if not type rbenv >/dev/null
      brew install --HEAD rbenv ruby-build rbenv-default-gems
      rbenv rehash
      echo "To update rbenv and ruby-build, brew update; and brew upgrade --HEAD rbenv ruby-build"
    end
  end

  function _setup_aliases
    echo "Setting up OS X aliases"
    if test -f ~/.config/fish/osx-aliases.fish
      source ~/.config/fish/osx-aliases.fish
    end
  end

  function _run_osx_script
    echo "Configuring OS X"
    if test -f ~/.osx
      bash ~/.osx
    else
      echo "Could not find OS X script"
    end
  end

  function _print_reminders
    echo -e "A few more things you may wish to do:
     - gem install iStats"
  end

  _setup_homebrew
  _setup_rbenv
  _setup_aliases
  _run_osx_script
  _print_reminders
end
