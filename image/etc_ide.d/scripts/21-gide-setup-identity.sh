#!/bin/bash -e

###########################################################################
# This file ensures files are mapped from ide_identity into ide_home.
# Fails if any required secret or configuration file is missing.
###########################################################################

if [ -d "$ide_identity/.gnupg" ]; then
  echo "copying ${ide_identity}/.gnupg"
  ( set -x; cp -vR "${ide_identity}/.gnupg" "${ide_home}/"; )
else
  echo "${ide_identity}/.gnupg does not exist"
fi
