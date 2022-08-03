#!/usr/bin/env python3

"""Example Trino client."""
import sys

from trino.dbapi import connect


def main():
    """Run a query."""
    with open("query.sql") as f:
        query = f.read()

    conn = connect(
        host="localhost",
        port=8080,
        user="python",
    )
    cur = conn.cursor()
    cur.execute(query)
    rows = cur.fetchall()
    if len(rows) != 100000:
        sys.exit(f"Expected 100000 rows but got {len(rows)}")


if __name__ == "__main__":
    main()
