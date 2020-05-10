#!/bin/bash
set -eu

readonly PARALLEL_SUMMARY_FILE="test-all-summary.log"

function main() {
    rm -f ${PARALLEL_SUMMARY_FILE}

    set +e
    parallel \
        --eta \
        --joblog ${PARALLEL_SUMMARY_FILE} \
        make test ROLE={} ::: \
            cplusplus \
            git \
            gui-applications \
            nkf \
            python \
            shellcheck \
            vscode \
            xmllint \
            zip
    local parallel_retval=$?
    set -e


    # https://stackoverflow.com/questions/5917413/concatenate-multiple-files-but-include-filename-as-section-headers
    cat ${PARALLEL_SUMMARY_FILE}
    # tail -n +1 ${PARALLEL_RESULT_DIRECTORY}/1/*/*

    return ${parallel_retval}
}

main "$@"
