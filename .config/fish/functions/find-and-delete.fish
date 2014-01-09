function find-and-delete --description "Recursively finds and deletes any files/dirs with the matching name. E.g. find-and-delete '*.pyc'"
  find . -name $argv[1] -delete
end
