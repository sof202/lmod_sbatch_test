#!/bin/bash
#SBATCH --export=ALL
#SBATCH -p mrcq 
#SBATCH --time=00:01:00
#SBATCH -A Research_Project-MRC190311 
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=16
#SBATCH --mem=1G
#SBATCH --mail-type=END 
#SBATCH --output=test_%a.log
#SBATCH --error=test_%a.err
#SBATCH --job-name=test

usage() {
    file_name=$(basename "$0")
cat << EOF
===============================================================================
Usage: sbatch --array=x-y .../$file_name module_name command
===============================================================================
Example: sbatch --array=1-100 .../$file_name Java/13.0.2 java
===============================================================================
EOF
    exit 0
}

move_logs() {
    mkdir -p logs
    mv "test_${SLURM_ARRAY_TASK_ID}."* logs
}

check_cmd() {
    command -v "$1" > /dev/null
}

get_node() {
    job_id=$1
    scontrol show job "${job_id}" | \
        grep "[^ReqExc]NodeList=" | \
        awk 'BEGIN {FS = "="} {print $2}'
}

main() {
    module_name=$1
    cmd=$2
    module load "${module_name}"
    node=$(get_node "${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}")

    if check_cmd "${cmd}"; then
        echo "SUCCESS on ${node}"
    else
        echo "ERROR on ${node}" 
    fi
}

if [[ $# -ne 2 || -z "${SLURM_ARRAY_TASK_ID}" ]]; then 
    usage
else
    move_logs
    main "$1" "$2"
fi
