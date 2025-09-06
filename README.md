# sw-hw-codesign-project
This repository contains **benchmarking, profiling, and optimization** work on two Python benchmarks from **pyperformance**:  

- **Pyflate** – DEFLATE decompression  
- **Crypto-PyAES** – AES encryption  

The project demonstrates how software-level optimizations (algorithmic and data-access changes) can reduce execution time and cache misses, and discusses possible **hardware acceleration strategies**.  

---

## Repository Structure  

```
.
├── benchmarks/
│   ├── pyflate/
│   │   ├── run_benchmark.py         # Original benchmark
│   │   ├── run_benchmark_opt.py     # Optimized version (read buffer)
│   │   ├── run_benchmark_opt2.py    # Further optimized (reverse_bits)
│   │   └── flamegraphs/             # Flamegraph SVGs
│   │
│   └── crypto_pyaes/
│       ├── run_benchmark.py         # Original benchmark
│       ├── run_benchmark_opt.py     # Optimized version (T-tables)
│       └── flamegraphs/             # Flamegraph SVGs
│
├── reports/
│   ├── pyflate_report.md            # Detailed Pyflate analysis
│   ├── crypto_pyaes_report.md       # Detailed PyAES analysis
│   └── final_report.md              # Combined project report
│
└── README.md                        # This file
```

---

## Requirements  

- **Python 3.10+**  
- [pyperformance](https://github.com/python/pyperformance)  
- [perf](https://perf.wiki.kernel.org/) (Linux profiling tool)  
- [py-spy](https://github.com/benfred/py-spy) (flamegraphs)  

Install dependencies:  

```bash
pip install pyperformance py-spy
sudo apt-get install linux-tools-common linux-tools-$(uname -r)
```

---

##  Running the Benchmarks  

### Pyflate  

Run original:  
```bash
cd benchmarks/pyflate
python3 run_benchmark.py
```

Run optimized versions:  
```bash
python3 run_benchmark_opt.py
python3 run_benchmark_opt2.py
```

Profile with `perf`:  
```bash
perf stat -e cache-references,cache-misses,cycles,instructions python3 run_benchmark_opt2.py
```

Generate a flamegraph:  
```bash
py-spy record -o flamegraphs/opt2.svg -- python3 run_benchmark_opt2.py
```

---

### Crypto-PyAES  

Run original:  
```bash
cd benchmarks/crypto_pyaes
python3 run_benchmark.py
```

Run optimized:  
```bash
python3 run_benchmark_opt.py
```

Profile with `perf`:  
```bash
perf stat -e cache-references,cache-misses,cycles,instructions python3 run_benchmark_opt.py
```

Generate a flamegraph:  
```bash
py-spy record -o flamegraphs/opt.svg -- python3 run_benchmark_opt.py
```

---

## Quick Results Summary  

| Benchmark      | Version       | Runtime Change | Cache Miss Change | Notes |
|----------------|--------------|----------------|-------------------|-------|
| **Pyflate**    | Optimized 1  | ~1.2% faster   | ↓ ~6% misses  | Buffered reads reduce I/O overhead |
| **Pyflate**    | Optimized 2  | +0.5% faster   | ↓ ~2% misses  | Bit reversal table optimization |
| **Crypto-AES** | Optimized    | ~0.6% faster   | ↓ ~84% misses | T-tables replace S-box lookups |

---

## Notes  

- Benchmarks were tested on **QEMU single-core** (to mimic limited hardware).  
- **Pyflate** showed modest improvements because Python interpreter overhead dominates.  
- **Crypto-PyAES** achieved large cache-miss reduction, showing where hardware acceleration (AES rounds using T-tables) would be highly effective.  
- Flamegraphs in `flamegraphs/` show hotspots before and after optimizations.

