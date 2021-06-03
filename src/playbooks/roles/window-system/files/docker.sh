#!/bin/bash

function main() {
    local -r number_of_running_docker_containers=$(docker ps -q | wc -l)

    if [ "${number_of_running_docker_containers}" = "0" ]; then
        return
    fi

    local -r latest_created_container_name=$(docker ps -l --format "{{ .Names }}")
    echo "Docker: ${number_of_running_docker_containers} (${latest_created_container_name})"
}

main "$@"
