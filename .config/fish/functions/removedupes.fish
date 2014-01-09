function removedupes -d "Removes duplicate lines from a file.
                         Usage: removedupes infile outfile
                         Similar to 'sort <file> | uniq' but faster and can handle larger input.
                         Also preserves original order (sort | uniq doesn't)."
  awk '!x[$0]++' $argv[1] > $argv[2]
end
