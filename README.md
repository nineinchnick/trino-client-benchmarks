# trino-client-benchmarks
Simple Trino client programs in different languages that can be benchmarked

## Usage

There's a [Makefile](Makefile) that:
* pulls all dependencies,
* builds what's necessary
* runs [hyperfine](https://github.com/sharkdp/hyperfine)

To get Python dependencies, run this manually:

```bash
python -mvenv venv
source venv/bin/activate
python -mpip install -r requirements.txt
```
