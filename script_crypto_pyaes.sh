#!/bin/bash

# Script: profile_crypto_pyaes.sh
# Purpose: Run profiling and benchmarking tools for Crypto-PyAES

# Step 1: perf record with debug Python
echo "Running perf record with Python debug for crypto_pyaes..."
perf record -F 999 -g -- python3-dbg -m pyperformance run --bench crypto_pyaes

# Step 2: Python profiling using pyaes_profile.py
echo "Running Python cProfile using pyaes_profile.py..."
python3 pyaes_profile.py

# Step 3: perf stat on original benchmark
echo "Running perf stat on original benchmark..."
perf stat -e cache-references,cache-misses,cycles,instructions python3 run_benchmark.py

#Step 4: flamegraphs
# Run py-spy to record raw profiling data
py-spy record --rate 100 --duration 10 --format=raw -o unoptimized.raw -- python3 profile_wrapper.py

# Collapse stack traces into folded format for flamegraph
./stackcollapse-py-spy.pl unoptimized.raw > unoptimized.folded

echo "All profiling commands for Crypto-PyAES completed."

