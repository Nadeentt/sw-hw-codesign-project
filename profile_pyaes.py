import cProfile
import run_benchmark  

# This will create the profiling file
cProfile.run('run_benchmark.bench_pyaes(10)', 'pyaes_profile.prof')

import pstats

p = pstats.Stats('pyaes_profile.prof')
p.strip_dirs().sort_stats('tottime').print_stats(20)
