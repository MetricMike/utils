# Git Push Remote - used when finishing a hotfix/release in a gitflow-enabled repo
alias gpr='git push --tags && git push && git checkout master && git push'

# Use this instead of 'git flow [hotfix] start v1.0.43
alias inc_gf='ruby ~/bump_gitflow_index.rb'

