#!/bin/bash

# Script: profile_pyflate.sh
# Purpose: Run profiling and benchmarking tools for Pyflate

# Step 1: perf record with debug Python
echo "Running perf record with Python debug..."
perf record -F 999 -g -- python3-dbg -m pyperformance run --bench pyflate

# Step 2: Python cProfile
echo "Running Python cProfile..."
python3 -m cProfile -s time -m pyperformance run --bench pyflate

# Step 3: perf stat on original benchmark
echo "Running perf stat on original benchmark..."
python3 run_benchmark.py &
perf stat -e cache-references,cache-misses,cycles,instructions python3 run_benchmark.py

# Step 4: py-spy flamegraph for optimized benchmark
echo "Generating flamegraph for optimized benchmark..."
py-spy record -o opt.svg -- python3 run_benchmark_opt.py
py-spy record -o opt.svg -- python3 run_benchmark_opt.py


echo "All profiling commands completed."
