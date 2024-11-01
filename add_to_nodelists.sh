#!/bin/bash

extract_nodes() {
    pattern=$1
    out_file=$2
    grep "${pattern}" "logs/*" >> "${out_file}"
}

sort_and_unique() {
    in_file=$1
    sort "${in_file}" > "temp.1.txt"
    uniq "temp.1.txt" > "temp.2.txt"
    rm "${in_file}" "temp.1.txt"
    mv "temp.2.txt" "${in_file}"
}

main() {
    cd $0 | exit 1
    extract_nodes "SUCCESS" "success.txt"
    extract_nodes "ERROR" "errors.txt"
    sort_and_unique "success.txt"
    sort_and_unique "errors.txt"
}

main
