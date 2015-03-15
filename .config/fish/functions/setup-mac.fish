function setup-mac --description "Setup script for OS X"

  function _setup_homebrew
    if not type brew >/dev/null
      ruby -e (curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)
      brew update
    end
    echo "homebrew installed"
  end

  # Installs rbenv and friends.
  function _setup_rbenv
    if not type rbenv >/dev/null
      brew install --HEAD rbenv ruby-build rbenv-default-gems
      rbenv rehash
      echo "To update rbenv and ruby-build, brew update; and brew upgrade rbenv ruby-build"
    end
    echo "rbenv installed"
  end

  _setup_homebrew
  _setup_rbenv

end
