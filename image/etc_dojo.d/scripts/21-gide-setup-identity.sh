#!/bin/bash -e

###########################################################################
# This file ensures files are mapped from dojo_identity into dojo_home.
# Fails if any required secret or configuration file is missing.
###########################################################################

if [ -d "$dojo_identity/.gnupg" ]; then
  echo "copying ${dojo_identity}/.gnupg into ${dojo_home}"
  cp -Rp "${dojo_identity}/.gnupg" "${dojo_home}/"
fi

echo "idea.config.path=${dojo_work}/.intellij-ide/config
idea.system.path=${dojo_work}/.intellij-ide/system
idea.plugins.path=${dojo_work}/.intellij-ide/plugins
idea.log.path=${dojo_work}/.intellij-ide/log" > "${dojo_home}/idea.properties"

if [ -d "${dojo_work}/.intellij-ide" ]; then
  echo "Directory: ${dojo_work}/.intellij-ide exists"
else
  echo "Setting up directory: ${dojo_work}/.intellij-ide"
  mkdir ${dojo_work}/.intellij-ide
  cp -R "${dojo_home}/pycharm-ide-level-settings/"* "${dojo_work}/.intellij-ide/"
  chown dojo:dojo -R "${dojo_work}/.intellij-ide/"
fi
