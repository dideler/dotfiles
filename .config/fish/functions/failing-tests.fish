function failing-tests -d "Run ExUnit tests then show all failing tests"
  set -l temp_file (mktemp /tmp/mix-test.XXXX)

  # Remove file when script unexpectedly exits
  trap "rm -f $temp_file" 0 2 3 15

  mix test $argv[1] | tee $temp_file

  set -l failing_tests (rg '_test.exs:\d+$' $temp_file | sort)

  rm $temp_file

  printf "\nFailing tests:\n\n$failing_tests"
end
