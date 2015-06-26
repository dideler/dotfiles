function setup-mac --description "Setup script for OS X"

  function _setup_homebrew
    if not type brew >/dev/null
      ruby -e (curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)
      brew update
    end
    echo "homebrew installed"
  end

  function _setup_rbenv
    if not type rbenv >/dev/null
      brew install --HEAD rbenv ruby-build rbenv-default-gems
      rbenv rehash
      echo "To update rbenv and ruby-build, brew update; and brew upgrade --HEAD rbenv ruby-build"
    end
    echo "rbenv installed"
  end

  function _setup_aliases
    if test -f ~/.config/fish/osx-aliases.fish
      source ~/.config/fish/osx-aliases.fish
      echo "mac aliases installed"
    end
  end

  function _run_osx_script
    if test -f ~/.osx
      source ~/.osx
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
