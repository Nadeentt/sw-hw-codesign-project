import run_benchmark

# Run only the benchmark function directly, without pyperf overhead
run_benchmark.bench_pyaes(2000)   # Adjust loop count to make it run ~10s
