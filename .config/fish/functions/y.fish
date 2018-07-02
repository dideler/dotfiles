function y -d "Smart alias for youtube-dl"
    for path in $argv
        __y_download $path
    end
end

function __y_download --argument path
    youtube-dl --ignore-config --quiet --no-mtime --output "~/Music/%(title)s.%(ext)s" --extract-audio --audio-format mp3 $path
end