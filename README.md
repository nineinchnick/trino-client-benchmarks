# trino-client-benchmarks
Simple Trino client programs in different languages that can be benchmarked

## Usage

There's a [Makefile](Makefile), where the default target:
* pulls all dependencies,
* builds what's necessary
* tests all clients using [hyperfine](https://github.com/sharkdp/hyperfine)

To run/time a single client, run:
* `make run-java`
* `make run-go`
* `make run-python`

To get Python dependencies, run this manually:

```bash
python -mvenv venv
source venv/bin/activate
python -mpip install -r requirements.txt
```

To start a Trino container, run:
```bash
docker run -d --name trino -p8080:8080 trinodb/trino:latest
```

## Benchmark

The [setup.sql](setup.sql) file creates a table in the `memory` catalog with 100k records from the `tpch.sf100.orders` table.

The [query.sql](query.sql) files selects all columns from `memory.default.orders` created by the setup query.
