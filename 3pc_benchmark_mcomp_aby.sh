#!/bin/bash

timestamp=$(date -d "today" +"%Y%m%d%H%M")
echo $timestamp

declare -a batch_sizes=("1" "10" "100" "1000" "10000" "100000" "1000000")
# declare -a batch_sizes=("1" "10")
declare -a ring_sizes=("31" "63")
declare -a sleep_times=(1 0.5 0)
index=$(($1))

num_iterations=10

for ring in "${ring_sizes[@]}"; do
    for batch in "${batch_sizes[@]}"; do
        ./compile.py -R 64 -Z 2 mcomp_v1_$ring 2 1 $batch 2>&1

        (echo "($ring, $batch, $num_iterations)") | tee -a $(($ring))_MP-SPDZ_mcomp_aby_$1_$2_$timestamp.txt

        sleep ${sleep_times[$index]}

        for iter in $(seq 1 $num_iterations); do
            echo $iter
            sleep ${sleep_times[$index]}
            ./replicated-ring-party.x -ip HOSTS $1 mcomp_v1_$ring-2-1-$batch -b $batch 2>&1 | (grep 'Data sent\|Time') | tee -a $(($ring))_MP-SPDZ_mcomp_aby_$1_$2_$timestamp.txt
        done
    done
done
