function fish_title
	if [ $_ = 'fish' ]
    echo (prompt_pwd)
  else
    echo $_
  end
end
