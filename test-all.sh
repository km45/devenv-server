#!/bin/bash
set -eu

readonly PARALLEL_SUMMARY_FILE="test-all-summary.log"
readonly PARALLEL_RESULT_DIRECTORY="test-all-results"

function main() {
    rm -f ${PARALLEL_SUMMARY_FILE}

    set +e
    parallel \
        --eta \
        --joblog ${PARALLEL_SUMMARY_FILE} \
        --results ${PARALLEL_RESULT_DIRECTORY} \
        make test ROLE={} ::: \
            cplusplus \
            git \
            gui_applications \
            nkf \
            python \
            rust \
            shellcheck \
            vscode \
            xmllint \
            zip
    local parallel_retval=$?
    set -e

    # https://stackoverflow.com/questions/5917413/concatenate-multiple-files-but-include-filename-as-section-headers
    tail -n +1 cat ${PARALLEL_SUMMARY_FILE} ${PARALLEL_RESULT_DIRECTORY}/1/*/*

    return ${parallel_retval}
}

main "$@"
