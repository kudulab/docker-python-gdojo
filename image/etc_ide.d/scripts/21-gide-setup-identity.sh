#!/bin/bash -e

###########################################################################
# This file ensures files are mapped from ide_identity into ide_home.
# Fails if any required secret or configuration file is missing.
###########################################################################

if [ -d "$ide_identity/.gnupg" ]; then
  echo "copying ${ide_identity}/.gnupg"
  ( set -x; cp -R "${ide_identity}/.gnupg" "${ide_home}/"; )
else
  echo "${ide_identity}/.gnupg does not exist"
fi

echo "idea.config.path=${ide_work}/.intellij-ide/config
idea.system.path=${ide_work}/.intellij-ide/system
idea.plugins.path=${ide_work}/.intellij-ide/plugins
idea.log.path=${ide_work}/.intellij-ide/log" > "${ide_home}/idea.properties"

if [ -d "${ide_work}/.intellij-ide" ]; then
  echo "Directory: ${ide_work}/.intellij-ide exists"
else
  echo "Setting up directory: ${ide_work}/.intellij-ide"
  mkdir ${ide_work}/.intellij-ide
  cp -R "${ide_home}/pycharm-ide-level-settings/"* "${ide_work}/.intellij-ide/"
  chown ide:ide -R "${ide_work}/.intellij-ide/"
fi
