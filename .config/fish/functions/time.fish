function time --description 'Wrapper for time, can use with fish functions'
	/usr/bin/time -p /usr/bin/fish -c "$argv"
end
