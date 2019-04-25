#!/bin/bash
set -eu

readonly OUT='dest'

function clean() {
    rm -rf ${OUT}
}

function init() {
    mkdir -p ${OUT}
}

function copy() {
    mkdir -p ${OUT}

    cp -p 'src/vagrantfiles/ubuntu-xenial/Vagrantfile' ${OUT}
    cp -pr 'src/playbooks' ${OUT}
}

function main() {
    clean
    init
    copy
}

main "$@"
