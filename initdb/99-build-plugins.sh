#!/usr/bin/env bash

#===
# 99-build-plugins.sh: Run plugin build scripts during the build phase. This only runs once.
# See shell coding standards for details of formatting.
# https://github.com/fieldsets/fieldsets/blob/main/docs/developer/coding-standards/shell.md
#
# @envvar VERSION | String
# @envvar ENVIRONMENT | String
#
#===

set -eEa -o pipefail

#===
# Variables
#===
export PGPASSWORD=${POSTGRES_PASSWORD}
PRIORITY=99
last_checkpoint="/docker-entrypoint-init.d/99-build-plugins.sh"

#===
# Functions
#===

source /fieldsets-lib/shell/utils.sh

##
# build: Run any plugin build scripts
##
build() {
    log "Building Plugins...."
    local f
    for f in /fieldsets-plugins/*/; do
        if [ -f "${f}build.sh" ]; then
            log "Executing: ${f}build.sh"
            exec "${f}build.sh"
        fi
    done

    log "Plugins Initialized."
}

#===
# Main
#===
trap traperr ERR

build

((PRIORITY+=1))
