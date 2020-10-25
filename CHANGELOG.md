### 1.0.2 (2020-Oct-25)

* newer base image will be used: kudulab/python-dojo:py3-1.0.2

### 1.0.1 (2019-Jun-28)

* fix publish task

### 1.0.0 (2019-Jun-28)

* make it a public image
* take base image tag based on gocd pipeline dependency
* do not set any defaults for PyCharm, but set the Pycharm config dir to `/dojo/work/.pycharm`,
 thanks to this we can use different python-gdojo containers and Pycharm configs
  will be shared for the context of a python project

### 0.3.0 (2019-Feb-04)

* newer releaser and docker-ops
* do not use oversion
* transform from ide docker image to dojo docker image #17139

### 0.2.3 (2019-Jan-04)

* install gnome-icon-theme or else pycharm 2018.3.2 has no icons
* preserve PyCharm IDE-level settings, however we have to still accept JetBrains
 policy privacy each time we run in new ide container #11058. Default configs now:
 set python3.5 interpreter from /ide/virtualenvs/testenv/bin/python3.5,
 turn off pycharm hints and set /ide/work as workspace

### 0.2.2 (2019-Jan-04)

* reproducible builds - build docker image using last version from changelog
* remove configs tests (itests are enough)
* better order of Dockerfile directives (fast to do as last ones)
* remove redundant and misleading /etc/ide.d/variables/ files
* make copying of ~/.gnupg directory not verbose
* remove uneeded tini
* use newer pycharm pycharm-community-2018.3.2 (faster debugger, support for pytest)

### 0.2.1 (2017-Oct-22)

 * Support multiple python versions in base images.
 * Move from ruby to bash tasks

### 0.2.0

Removed ruby tasks.
Introduced invalid release cycle.

### 0.1.1

 * make Dockerfile use Dockerfile.tmpl
 * install libxtst6 package to fix pycharm not starting

### 0.1.0

Initial release with pycharm
