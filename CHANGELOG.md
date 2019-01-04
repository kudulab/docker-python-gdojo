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
