# docker-python-gdojo

A Dojo docker image with Python runtime and [PyCharm](https://www.jetbrains.com/pycharm/).

## Specification

This docker image is based on [python-dojo](https://github.com/kudulab/docker-python-dojo) docker image.
The same python versions are supported by python-gdojo as by python-dojo. This docker image contains all what's in python-dojo and:
 * Pycharm community edition

## Usage
1. Install [Dojo](https://github.com/kudulab/dojo)
2. Provide a Dojofile:
```
# docker tag format: <py3 or py2>-<THIS_IMAGE_VERSION>_<BASE_IMAGE_VERSION>
DOJO_DOCKER_IMAGE="kudulab/python-gdojo:2.0.0"
# or:
DOJO_DOCKER_IMAGE="kudulab/python-gdojo:latest"
```
3. Run, example commands:

```bash
# to run PyCharm (your terminal must be interactive):
dojo

# or this way:
dojo "pycharm & /bin/bash"
```

Afterwards, from inside of the docker container, you can run any python command like in python-dojo, e.g.:
```
python --version
```

By default:
 * current directory in docker container is `/dojo/work`.
 * default command is `pycharm & /bin/bash` and it starts PyCharm in a new graphical window


### Configuration using Virtualenv
The very first time you run PyCharm for your project, you have to **add Python interpreter**.
 If you want to use a Virtualenv environment, it is recommended to set its location
 to a local directory, e.g. `/dojo/work/venv`. Then, you have to choose
 Base Interpreter, e.g.: `/usr/local/bin/python3.7`. Do not set: "Inherit global site-packages",
 unless you really need it. (It would result in needing sudo to install packages
 and also in the `/dojo/work/venv` directory not storing all the packages
 needed by your project). This is illustrated on the image below:
 ![setting Python interpreter](pycharm-set-python-interpreter.png "setting Python interpreter")

Once you customize your PyCharm settings (including the Python interpreter),
 a local directory: `.pycharm` will keep all those
 settings (local to your current directory).

You can use the `requirements.txt` file to list all your project Python dependencies.
 In order to install them, you can:
   * either do it from PyCharm. (As soon as you modify the `requirements.txt` file, PyCharm will ask whether to install a requirement)
   * or do it from commandline: `source venv/bin/activate && pip install -r requirements.txt`

Thanks to that, you can work in different docker containers,
created from `python-gdojo` docker image, and you won't have to set PyCharm
again, and you also won't have to reinstall all your project Python dependencies.

#### IntelliJ settings background
If you want to read more about IntelliJ settings, read [this](https://www.jetbrains.com/help/idea/configuring-project-and-ide-settings.html) and [this](https://intellij-support.jetbrains.com/hc/en-us/articles/206544519-Directories-used-by-the-IDE-to-store-settings-caches-plugins-and-logs).
 Basically, IntelliJ has 2 types of settings:
   * project-level stored in <project-dir>/.idea
   * IDE-level stored in a directory like: ~/.PyCharmCE2016.3. (different name for each PyCharm version)

Here we [set](https://intellij-support.jetbrains.com/hc/en-us/articles/207240985-Changing-IDE-default-directories-used-for-config-plugins-and-caches-storage) IDE-level stored settings to be kept in `.pycharm` directory.

## Development
### Dependencies
* Bash
* Docker daemon
* Bats
* [Dojo](https://github.com/ai-traders/dojo)

## Contributing
Instructions how to update this project.

1. Create a new feature branch from the main branch
1. Work on your changes in that feature branch. If you want, describe you changes in [CHANGELOG.md](CHANGELOG.md)
1. Build your image locally to check that it succeeds: `./tasks build`
1. Test your image locally: `./tasks itest`. You may need to install the test framework - you can do it following [these instructions](https://github.com/kudulab/docker-terraform-dojo/blob/master/tasks#L66)
1. If you are happy with the results, create a PR from your feature branch to master branch

After this, someone will read your PR, merge it and ensure version bump (using `./tasks set_version`). CI pipeline will run to automatically build and test docker image, release the project and publish the docker image.

### Release
This repo has conditional code release, because we build a docker image from this image:
  * if there are new commits in this git repo
  * if new base docker image (python-dojo) was published

In the latter case there are no new commits in this git repo and release was
 already done before. Then, we only want to build and publish new docker image.

## License

Copyright 2019-2024 Ava Czechowska, Tom Sętkowski

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
