#!/usr/bin/fish

# Since asdf was rewritten from bash to golang (as of v0.16), it can no longer self-upgrade.
# If installed via a package manager (e.g. Homebrew), you can upgrade it that way.
# If installed by downloading the compiled binary executable, you have to manually upgrade.
# This script helps with the manual upgrade, since my old MBP no longer supports Homebrew.

function asdf_latest_version -d "Fetch the latest release tag from GitHub"
    set -l LATEST_VERSION (curl -s https://api.github.com/repos/asdf-vm/asdf/releases/latest | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')
    if test $status -ne 0; or test -z "$LATEST_VERSION"
        echo "Error: Failed to fetch latest version from GitHub" >&2
        return 1
    end
    echo $LATEST_VERSION
end

function install_shell_completions -d "Install fish shell completions for asdf"
    set -l COMPLETIONS_DIR ~/.config/fish/completions

    # Create completions directory if it doesn't exist
    if not test -d $COMPLETIONS_DIR
        mkdir -p $COMPLETIONS_DIR
    end

    # Install completions
    echo "Installing shell completions..."
    if command -v asdf >/dev/null
        asdf completion fish > $COMPLETIONS_DIR/asdf.fish
        if test $status -eq 0
            echo "Shell completions installed successfully"
            return 0
        else
            echo "Error: Failed to install shell completions" >&2
            return 1
        end
    else
        echo "Error: asdf command not found" >&2
        return 1
    end
end

function asdf-install
    set -l VERSION $argv[1]

    if test -z "$VERSION"
        echo "Error: Version parameter is required" >&2
        echo "Usage: asdf-install VERSION" >&2
        return 1
    end

    # Determine architecture
    set -l OS (uname -s | tr '[:upper:]' '[:lower:]')
    set -l ARCH (uname -m)

    if test $ARCH = "x86_64"
        set ARCH "amd64"
    else if test $ARCH = "arm64" -o $ARCH = "aarch64"
        set ARCH "arm64"
    else if test $ARCH = "i386" -o $ARCH = "i686"
        set ARCH "386"
    end

    set -l ARCHITECTURE "$OS-$ARCH" # "darwin-amd64", "darwin-arm64", "linux-386", "linux-amd64", "linux-arm64"
    set -l DOWNLOAD_URL "https://github.com/asdf-vm/asdf/releases/download/$VERSION/asdf-$VERSION-$ARCHITECTURE.tar.gz"
    set -l TEMP_FILE "asdf-$VERSION.tar.gz"

    # Download the new version
    echo "Downloading $DOWNLOAD_URL..."
    curl -L -o "$TEMP_FILE" "$DOWNLOAD_URL"
    if test $status -ne 0
        echo "Error: Download failed" >&2
        rm -f "$TEMP_FILE"
        return 1
    end

    # Extract the binary
    echo "Extracting..."
    tar -xzf "$TEMP_FILE"
    if test $status -ne 0
        echo "Error: Extraction failed" >&2
        rm -f "$TEMP_FILE"
        return 1
    end

    # Move binary to ~/bin/
    echo "Installing to ~/bin/..."
    mkdir -p ~/bin
    mv asdf ~/bin/
    if test $status -ne 0
        echo "Error: Failed to move binary to ~/bin/" >&2
        rm -f "$TEMP_FILE" asdf
        return 1
    end

    # Clean up
    rm -f "$TEMP_FILE"

    # Verify installation
    echo "Verifying installation..."
    set -l NEW_VERSION (~/bin/asdf version 2>/dev/null)
    if test $status -ne 0; or test "$NEW_VERSION" != "$VERSION"
        echo "Error: Installation of version $VERSION failed" >&2
        return 1
    end

    # Install shell completions
    install_shell_completions

    echo "Successfully installed asdf version $VERSION"
    return 0
end

# Helper function to compare semantic versions
function version_compare
    # Remove 'v' prefix if present
    set ver1 (string replace -r '^v' '' $argv[1])
    set ver2 (string replace -r '^v' '' $argv[2])

    # Split into arrays by '.'
    set v1 (string split '.' $ver1)
    set v2 (string split '.' $ver2)

    # Compare each part
    for i in (seq 1 3)
        # If part doesn't exist, treat as 0
        set num1 (test -n "$v1[$i]"; and echo $v1[$i]; or echo 0)
        set num2 (test -n "$v2[$i]"; and echo $v2[$i]; or echo 0)

        if test $num1 -lt $num2
            return 1  # ver1 < ver2
        else if test $num1 -gt $num2
            return 2  # ver1 > ver2
        end
    end
    return 0  # ver1 = ver2
end

function asdf-upgrade
    # Fetch the latest release tag from GitHub API
    set -l LATEST_VERSION (asdf_latest_version)
    if test $status -ne 0
        echo "Error: Failed to fetch latest asdf version" >&2
        return 1
    end

    # Get current installed version
    set -l CURRENT_VERSION (asdf version 2>/dev/null)
    if test $status -ne 0
        echo "Could not determine current ASDF version. Is ASDF installed?"
        read -l -P "Would you like to install asdf version $LATEST_VERSION? [y/N] " confirm

        switch $confirm
            case Y y yes Yes
                asdf-install $LATEST_VERSION
                return $status
            case '*'
                echo "Installation canceled."
                return 0
        end
    end

    echo "Current version: $CURRENT_VERSION"
    echo "Latest version: $LATEST_VERSION"

    # Compare versions
    version_compare "$CURRENT_VERSION" "$LATEST_VERSION"
    set result $status

    if test $result -eq 0
        echo "You are already running the latest version."
        return 0
    else if test $result -eq 2
        echo "Your version is newer than the latest release (possibly a pre-release or custom version)."
        return 0
    end

    echo "Newer version available. Starting upgrade process..."

    asdf-install $LATEST_VERSION
    if test $status -ne 0
        echo "Error: Upgrade failed" >&2
        return 1
    end

    echo "Successfully upgraded ASDF to version $LATEST_VERSION"
    return 0
end
