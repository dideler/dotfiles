#!/usr/bin/fish

# Since asdf was rewritten from bash to golang (as of v0.16), it can no longer self-upgrade.
# If installed via a package manager (e.g. Homebrew), you can upgrade it that way.
# If installed by downloading the compiled binary executable, you have to manually upgrade.
# This script helps with the manual upgrade, since my old MBP no longer supports Homebrew.

function asdf-upgrade
    # Get current installed version
    set CURRENT_VERSION (asdf version 2>/dev/null)
    if test $status -ne 0
        echo "Error: Could not determine current ASDF version. Is ASDF installed?"
        return 1
    end

    # Fetch the latest release tag from GitHub API
    set LATEST_VERSION (curl -s https://api.github.com/repos/asdf-vm/asdf/releases/latest | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')
    if test $status -ne 0; or test -z "$LATEST_VERSION"
        echo "Error: Failed to fetch latest version from GitHub"
        return 1
    end

    # Function to compare semantic versions
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

    # If we reach here, an update is available
    echo "Newer version available. Starting upgrade process..."

    # Determine architecture (assuming macOS for this example, adjust as needed)
    set ARCH "darwin-amd64"  # Could be linux-amd64, etc.
    set DOWNLOAD_URL "https://github.com/asdf-vm/asdf/releases/download/$LATEST_VERSION/asdf-$LATEST_VERSION-$ARCH.tar.gz"
    set TEMP_FILE "asdf-$LATEST_VERSION.tar.gz"

    # Download the new version
    echo "Downloading $DOWNLOAD_URL..."
    curl -L -o "$TEMP_FILE" "$DOWNLOAD_URL"
    if test $status -ne 0
        echo "Error: Download failed"
        rm -f "$TEMP_FILE"
        return 1
    end

    # Extract the binary
    echo "Extracting..."
    tar -xzf "$TEMP_FILE"
    if test $status -ne 0
        echo "Error: Extraction failed"
        rm -f "$TEMP_FILE"
        return 1
    end

    # Move binary to ~/bin/
    echo "Installing to ~/bin/..."
    mkdir -p ~/bin
    mv asdf ~/bin/
    if test $status -ne 0
        echo "Error: Failed to move binary to ~/bin/"
        rm -f "$TEMP_FILE" asdf
        return 1
    end

    # Clean up
    rm -f "$TEMP_FILE"

    # Verify installation
    echo "Verifying installation..."
    set NEW_VERSION (asdf version 2>/dev/null)
    if test $status -ne 0; or test "$NEW_VERSION" != "$LATEST_VERSION"
        echo "Error: Upgrade verification failed. New version: $NEW_VERSION, Expected: $LATEST_VERSION"
        return 1
    end

    echo "Successfully upgraded ASDF to version $NEW_VERSION"
end
