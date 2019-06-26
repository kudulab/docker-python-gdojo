load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

@test "/usr/bin/entrypoint.sh returns 0" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"pwd && whoami\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "dojo init finished"
  assert_line --partial "/dojo/work"
  refute_output --partial "root"
  assert_equal "$status" 0
}
@test "files copied from /dojo/identity have proper owner" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"stat -c %U ~/.ssh/ && stat -c %U ~/.ssh/id_rsa && stat -c %U ~/.gitconfig\""
  assert_line --partial "dojo"
  refute_output --partial "root"
  assert_equal "$status" 0
}
@test "git is installed" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"git --version\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "git version"
  assert_equal "$status" 0
}
@test "python is installed" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"python --version\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "Python"
  assert_equal "$status" 0
}
@test "public python package can be installed with pip, locally" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"pip install --user tabulate && tabulate --help\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "Successfully installed tabulate"
  assert_line --partial "Usage: tabulate"
  assert_equal "$status" 0
}
@test "public python package can be installed with pip, globally" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"sudo pip install tabulate && tabulate --help\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "Successfully installed tabulate"
  assert_line --partial "Usage: tabulate"
  assert_equal "$status" 0
}
