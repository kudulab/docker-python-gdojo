load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

# all the ide scripts are set
@test "git is installed" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested_configs -- -c \"git --version\""
  assert_output --partial "git version"
  assert_equal "$status" 0
  run /bin/bash -c "ide --idefile Idefile.to_be_tested_configs -- -c \"git status\""
  assert_output --partial "fatal: Not a git repository (or any of the parent directories): .git"
}
