#!/bin/bash

timestamp=$(date -d "today" +"%Y%m%d%H%M")
echo $timestamp


# declare -a batch_sizes=("1" "10" "100" "1000" "10000" "100000" "1000000")
declare -a batch_sizes=("1" "10")
declare -a ring_sizes=("32" "64")

for batch in "${batch_sizes[@]}"; do
    for ring in "${ring_sizes[@]}"; do
        ./compile.py -R 64 eda-bench $ring $batch
    done
done

declare -a sleep_times=(4 2 0)
index=$(($1))


for batch in "${batch_sizes[@]}"; do
    for ring in "${ring_sizes[@]}"; do
            sleep ${sleep_times[$index]}; ./replicated-ring-party.x -ip HOSTS $1 eda-bench-$ring-$batch | tee -a 3pc_MP-SPDZ_$1_$timestamp.txt 
    done
done
