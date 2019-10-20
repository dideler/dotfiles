function ecr-login -d "Log into AWS ECR via docker-login"
  set -l login_cmd (aws ecr get-login --no-include-email --region eu-west-1)
  eval $login_cmd
end
