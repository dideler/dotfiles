# Example usage:
#   echo "for i in seq(10000); expensive_operation; end" >> test.fish
#   bench test.fish
function bench --description 'Measure a benchmark script' --argument script_path
	/usr/bin/time -p fish "$script_path"
end
