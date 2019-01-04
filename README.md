# docker-python2-gide

An IDE docker image with Python runtime, CLI and graphical tools.
Based on [python2-ide](http://gitlab.ai-traders.com/stcdev/docker-python2-ide).
There is a **GIDE for each python version supported in python2-ide**.

## Specification
All what's in [python2-ide](http://gitlab.ai-traders.com/stcdev/docker-python2-ide) and:
 * Pycharm 2018.3.2 community edition

## Usage
1. Install [IDE](https://github.com/ai-traders/ide)
2. Provide an Idefile:
```
# python2-gide is tagged as: <THIS_IMAGE_VERSION>_<BASE_IMAGE_VERSION>
IDE_DOCKER_IMAGE="docker-registry.ai-traders.com/python2-gide:0.1.1_0.3.1"
# or just:
IDE_DOCKER_IMAGE="docker-registry.ai-traders.com/python2-gide:latest"
```
3. Run, example commands:

```bash
# to run IntelliJ (your terminal must be interactive):
ide

# or this way (default command):
ide pycharm & /bin/bash

# then run any python command like in python2-ide, e.g.:
python --version
```

By default:
 * current directory in docker container is `/ide/work`.
 * default command is `pycharm & /bin/bash` and it starts in a new graphical window

### Configuration
Those files are used inside the ide docker image:

1. `~/.ssh/config` -- will be generated on docker container start
2. `~/.ssh/id_rsa` -- it must exist locally, because it is a secret
 (but the whole `~/.ssh` will be copied)
2. `~/.gitconfig` -- if exists locally, will be copied
2. `~/.gnupg` -- if exists locally, will be copied
3. `~/.profile` -- will be generated on docker container start, in
   order to ensure current directory is `/ide/work`.


## Development
### Dependencies
* Bash
* Docker daemon
* Bats
* Ide

### Lifecycle
1. In a feature branch:
   * you make changes and add some docs to changelog (do not insert date or version)
   * you build docker image: `./tasks build_py35`
   * and test it: `./tasks itest_py35`
1. You decide that your changes are ready and you:
   * merge into master branch
   * run locally:
     * `./tasks set_version` to bump the patch version fragment by 1 OR
     * e.g. `./tasks set_version 1.2.3` to bump to a particular version
       Version is bumped in Changelog, variables.sh file and OVersion backend
   * push to master onto private git server
1. CI server (GoCD) tests and releases.

### Release
This repo has conditional code release, because we build a docker image from this image:
  * if there are new commits in ci branch
  * if new python2-ide docker image was published

In the latter case there are no new commits in this git repo and release was
 already done before. Then, we only want to build and publish new docker image.
