load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

# all the ide scripts are set
package_name="example-pythonide2"

@test "cleanup" {
  rm -rf test/integration/end_user/test_ide_work/${package_name}/dist
  rm -rf test/integration/end_user/test_ide_work/${package_name}/build
  rm -f test/integration/end_user/test_ide_work/${package_name}/MANIFEST
  /bin/bash -c "ide --idefile Idefile.to_be_tested \"devpi remove -y ${package_name}\" || echo 'removal not needed'"
}
@test "/usr/bin/entrypoint.sh returns 0" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"pwd && whoami\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "ide init finished"
  assert_line --partial "/ide/work"
  assert_line --partial "python2-gide"
  refute_output "root"
  assert_equal "$status" 0
}
@test "git is installed" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"git --version\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "git version"
  assert_equal "$status" 0
}
@test "python is installed" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"python --version\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "Python"
  assert_equal "$status" 0
}
@test "locust runs on command line" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"source /ide/virtualenvs/locust/bin/activate && pip install -r requirements.txt && locust --no-web --host http://localhost:8065 -c 5 -r 2 -n 10\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "Percentage of the requests completed within given times"
  # exit code may be non-zero, there is no server to repond to requests. It should fail
  assert_equal "$status" 1
}
@test "public python package can be installed from private mirror" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"source /ide/virtualenvs/locust/bin/activate && pip install simplejson\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "Downloading http://devpi.ai-traders.com/root/pypi"
  assert_line --partial "Successfully installed simplejson"
  assert_equal "$status" 0
}
@test "pip install -r installs from private mirror" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"source /ide/virtualenvs/locust/bin/activate && pip install -r requirements2.txt\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "Downloading http://devpi.ai-traders.com/root/pypi"
  assert_equal "$status" 0
}
@test "private python package can be published" {
  # first there is no ${package_name} package
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"devpi list ${package_name}\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "Not Found"
  assert_equal "$status" 1

  # then, we build the package
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"cd ${package_name} && python setup.py sdist\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "${package_name}-1.22.5"
  assert_equal "$status" 0

  # then, we upload the package
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"cd ${package_name} && devpi upload dist/${package_name}-1.22.5.tar.gz\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "file_upload of ${package_name}-1.22.5.tar.gz to http://devpi.ai-traders.com/root/ait/"
  assert_equal "$status" 0
}
@test "private python package can be installed from private index" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"source /ide/virtualenvs/locust/bin/activate && pip install ${package_name}\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "Downloading http://devpi.ai-traders.com/root/ait"
  assert_line --partial "Successfully installed ${package_name}"
  assert_equal "$status" 0
}

@test "the published private python package can be removed" {
  # first there is ${package_name} package
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"devpi list ${package_name}\""
  # this is printed on test failure
  echo "output: $output"
  assert_equal "$status" 0

  # then we remove the package
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"devpi remove -y ${package_name}\""
  # this is printed on test failure
  echo "output: $output"
  assert_equal "$status" 0

  # and now the package does not exist on devpi-server index
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"devpi list ${package_name}\""
  # this is printed on test failure
  echo "output: $output"
  assert_line --partial "Not Found"
  assert_equal "$status" 1
}
@test "cleanup" {
  rm -rf test/integration/end_user/test_ide_work/${package_name}/dist
  rm -rf test/integration/end_user/test_ide_work/${package_name}/build
  rm -f test/integration/end_user/test_ide_work/${package_name}/MANIFEST
  /bin/bash -c "ide --idefile Idefile.to_be_tested \"devpi remove -y ${package_name}\" || echo 'removal not needed'"
}
