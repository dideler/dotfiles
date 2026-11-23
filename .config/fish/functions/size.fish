function size -d "Human-readable size of files or directories"
  function __help
    echo "Usage: "(status current-command)" [OPTIONS] [FILE...]"
    echo ""
    echo "Show human-readable size of files and directories, sorted largest first."
    echo ""
    echo "Options:"
    echo "  -l, --ls     Use ls -ghS (default, fast apparent file sizes)"
    echo "  -n, --ncdu   Use ncdu -o- (recursive apparent sizes, requires ncdu and jq)"
    echo "  -d, --du     Use du -ahd 1 (disk usage rounded to filesystem blocks)"
    echo "  -t, --trace  Enable fish trace mode for debugging"
    echo "  -h, --help   Show this help message and exit"
  end

  set -l options 'l/ls' 'n/ncdu' 'd/du' 't/trace' 'h/help'
  argparse --exclusive 'l,n,d' $options -- $argv; or return 1

  if set -q _flag_trace; set -l fish_trace 1; end
  if set -q _flag_help; __help; return 0; end

  set -l method ls
  if set -q _flag_ncdu
    set method ncdu
  else if set -q _flag_du
    set method du
  end

  set -l files $argv
  if test (count $files) -eq 0
    set files "."
  end

  set -l had_error 0

  switch $method
    case ls
      for file in $files
        if not test -e $file
          echo "Error: Not a valid file or directory: '$file'" >&2
          set had_error 1
          continue
        end

        command ls -ghS -- $file | awk '
          /^total / { next }
          NF >= 8 {
            size = $4
            line = $0
            sub(/^[[:space:]]*/, "", line)
            for (i = 1; i <= 6; i++) sub(/^[^[:space:]]+[[:space:]]+/, "", line)
            sub(/^[^[:space:]]+ /, "", line)
            printf "%-10s %s\n", size, line
          }
        '
      end

    case ncdu
      if not command -q ncdu
        echo "Error: ncdu is not installed" >&2
        return 1
      end
      if not command -q jq
        echo "Error: jq is required for ncdu mode (install with: brew install jq)" >&2
        return 1
      end

      set -l jq_filter '
        def human:
          if . >= 1073741824 then "\((. / 1073741824 * 10 | round) / 10)G"
          elif . >= 1048576 then "\((. / 1048576 * 10 | round) / 10)M"
          elif . >= 1024 then "\((. / 1024 * 10 | round) / 10)K"
          else "\(.)B"
          end;

        .[3][1:]
        | map(
            if type == "array" then
              { name: (.[0].name + "/"), size: ([.. | objects | .asize // 0] | add) }
            else
              { name: .name, size: (.asize // 0) }
            end
          )
        | sort_by(-.size)
        | .[]
        | "\(.size | human)\t\(.name)"
      '

      for file in $files
        if test -d $file
          command ncdu -o- -- $file 2>/dev/null \
            | jq -r $jq_filter \
            | awk -F'\t' '{ printf "%-10s %s\n", $1, $2 }'
        else if test -e $file
          set -l bytes (file_size_bytes $file)
          jq -rn --argjson b "$bytes" --arg name "$file" '
            def human:
              if . >= 1073741824 then "\((. / 1073741824 * 10 | round) / 10)G"
              elif . >= 1048576 then "\((. / 1048576 * 10 | round) / 10)M"
              elif . >= 1024 then "\((. / 1024 * 10 | round) / 10)K"
              else "\(.)B"
              end;
            "\($b | human)\t\($name)"
          ' | awk -F'\t' '{ printf "%-10s %s\n", $1, $2 }'
        else
          echo "Error: Not a valid file or directory: '$file'" >&2
          set had_error 1
        end
      end

    case du
      for file in $files
        if test -d $file
          command du -ahd 1 -- $file \
            | sed '$d' \
            | sort -hr \
            | awk -F'\t' '{ gsub(/^[[:space:]]+|[[:space:]]+$/, "", $1); printf "%-10s %s\n", $1, $2 }'
        else if test -e $file
          command du -h -- $file \
            | awk -F'\t' '{ gsub(/^[[:space:]]+|[[:space:]]+$/, "", $1); printf "%-10s %s\n", $1, $2 }'
        else
          echo "Error: Not a valid file or directory: '$file'" >&2
          set had_error 1
        end
      end
  end

  return $had_error
end
