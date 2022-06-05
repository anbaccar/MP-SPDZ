#!/bin/bash

# declare -a batch_sizes=("1" "10" "100" "1000" "10000" "100000" "1000000")
declare -a batch_sizes=("1" "10")
declare -a ring_sizes=("32" "64")

 for batch in "${batch_sizes[@]}"
    do
        for ring in "${ring_sizes[@]}"
        do
