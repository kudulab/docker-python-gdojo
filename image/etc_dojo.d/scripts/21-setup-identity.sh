#!/bin/bash -e

###########################################################################
# This file ensures files are mapped from dojo_identity into dojo_home.
# Fails if any required secret or configuration file is missing.
###########################################################################

function log_info {
  if [[ "${DOJO_LOG_LEVEL}" != "silent" ]] && [[ "${DOJO_LOG_LEVEL}" != "error" ]] && [[ "${DOJO_LOG_LEVEL}" != "warn" ]]; then
    echo -e "$(date "+%d-%m-%Y %T") python-gdojo info: ${1}" >&2
  fi
}

if [ -d "$dojo_identity/.gnupg" ]; then
  log_info "copying ${dojo_identity}/.gnupg into ${dojo_home}"
  cp -Rp "${dojo_identity}/.gnupg" "${dojo_home}/"
fi

echo "idea.config.path=${dojo_work}/.pycharm/config
idea.system.path=${dojo_work}/.pycharm/system
idea.plugins.path=${dojo_work}/.pycharm/plugins
idea.log.path=${dojo_work}/.pycharm/log" > "${dojo_home}/idea.properties"
