#!/usr/bin/env python3

"""Example Trino client."""
import sys
import pytest

from trino.dbapi import connect


def main():
    """Connect to a DB and run a single query."""
    conn = connect(
        host="localhost",
        port=8080,
        user="python",
    )
    query(conn)


def query(conn):
    """Run a query given a connection."""
    num_rows = 0
    all_comments_length = 0
    cur = conn.cursor()
    q = """SELECT
  orderkey
  , custkey
  , orderstatus
  , totalprice
  , orderdate
  , orderpriority
  , clerk
  , shippriority
  , comment
  , now
FROM memory.default.orders"""
    for row in cur.execute(q):
        num_rows += 1
        all_comments_length += len(row[8])
    print(f"Average comment length: {all_comments_length / float(num_rows)}")
    if num_rows != 100000:
        sys.exit(f"Expected 100000 rows but got {num_rows}")


if __name__ == "__main__":
    main()


@pytest.mark.benchmark(
    min_time=5.0,
)
def test_query(benchmark):
    """Benchmark the query function."""
    conn = connect(
        host="localhost",
        port=8080,
        user="python",
    )
    benchmark(query, conn)
