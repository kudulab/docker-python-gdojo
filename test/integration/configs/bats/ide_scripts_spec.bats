load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

# all the ide scripts are set

@test "/usr/bin/entrypoint.sh file exists and is executable" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested_configs -- -c \"test -x /usr/bin/entrypoint.sh\""
  # this is printed on test failure
  echo "output: $output"
  assert_equal "$status" 0
}
@test "/etc/ide.d, /etc/ide.d/scripts, /etc/ide.d/variables drectories exist" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested_configs -- -c \"test -d /etc/ide.d && test -d /etc/ide.d/scripts && test -d /etc/ide.d/variables\""
  # this is printed on test failure
  echo "output: $output"
  assert_equal "$status" 0
}
@test "/etc/ide.d/scripts/50-ide-fix-uid-gid.sh file exists and is executable" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested_configs -- -c \"test -x /etc/ide.d/scripts/50-ide-fix-uid-gid.sh\""
  # this is printed on test failure
  echo "output: $output"
  assert_equal "$status" 0
}
@test "/etc/ide.d/scripts/20-ide-setup-identity.sh exists and is executable" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested_configs -- -c \"test -x /etc/ide.d/scripts/20-ide-setup-identity.sh\""
  # this is printed on test failure
  echo "output: $output"
  assert_equal "$status" 0
}

# The most important test:
# All the ide scripts can be executed without error and many times.
# Do not run /etc/ide.d/scripts/* on their own here,
# because it needs variables which are sourced by /usr/bin/entrypoint.sh.
@test "/usr/bin/entrypoint.sh returns 0" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested_configs -- -c \"/usr/bin/entrypoint.sh whoami 2>&1\""
  # this is printed on test failure
  echo "output: $output"
  assert_equal "$status" 0
  # do not test which line returns those strings, sometimes there is
  # additional line: "usermod: no changes"
  assert_line --partial "ide init finished"
  assert_line --partial "using python2-gide:"
}
@test "/usr/bin/entrypoint.sh provides secrets and configuration" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested_configs -- -c \"/usr/bin/entrypoint.sh whoami 2>&1 && stat -c %U /home/ide/.ssh/id_rsa && stat -c %U /home/ide/.gitconfig\""
  # this is printed on test failure
  echo "output: $output"
  assert_equal "$status" 0
  refute_output "root"
}
