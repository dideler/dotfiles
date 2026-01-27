function copy --description 'Copy file contents (text/image) or a shell variable to clipboard'
    set --local argc (count $argv)

    if test $argc -ne 1
        echo "Usage: copy <filepath or shell variable>"
        return 1
    end

    set --local input $argv[1]

    switch (uname)
        case Linux
            __copy_linux "$input"
        case Darwin
            __copy_darwin "$input"
        case '*'
            echo "OS not supported"
            return 1
    end
end

function __copy_linux --argument-names input
    if test -e "$input"
        # Detect mime type (e.g. image/png, text/plain)
        set --local mime (file --mime-type -b "$input")

        switch $mime
            case 'image/*'
                # xclip needs the target (-t) explicitly set for images
                xclip -selection clipboard -t "$mime" < "$input"
            case '*'
                # Default text handling
                xclip -selection clipboard < "$input"
        end
    else
        # Treat argument as raw text string
        printf "$input" | xclip -selection clipboard
    end
end

function __copy_darwin --argument-names input
    if test -e "$input"
        # Resolve absolute path for AppleScript
        set --local abs_path (path resolve "$input")
        set --local ext (string lower (path extension "$input"))

        switch $ext
            case .jpg .jpeg
                osascript -e "set the clipboard to (read (POSIX file \"$abs_path\") as JPEG picture)" >/dev/null
            case .png
                osascript -e "set the clipboard to (read (POSIX file \"$abs_path\") as «class PNGf»)" >/dev/null
            case .tiff .tif
                osascript -e "set the clipboard to (read (POSIX file \"$abs_path\") as TIFF picture)" >/dev/null
            case '*'
                # Fallback to pbcopy for text files
                pbcopy < "$input"
        end
    else
        # Treat argument as raw text string
        printf "$input" | pbcopy
    end
end
