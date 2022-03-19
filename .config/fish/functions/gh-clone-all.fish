function gh-clone-all --description "Clone all GH repos of the user and their orgs"
  gh auth status >/dev/null || begin
    echo "Must authenticate via GitHub CLI: gh auth login" 1>&2
    return 1
  end

  set -l orgs (gh api user/orgs -q '.[].login')
  set -l owners dideler $orgs

  for owner in $owners
    set -l namespace_dir ~/github.com/$owner
    mkdir -p $namespace_dir && pushd $namespace_dir
    gh repo list $owner --limit 1000 | awk '{print $1; }' | xargs -L1 gh repo clone
    popd
  end
end
