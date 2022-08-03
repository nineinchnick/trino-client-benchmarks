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
    num_rows = 0
    all_comments_length = 0
    for row in cur.execute(query):
        num_rows += 1
        all_comments_length += len(row[8])
    print(f"Average comment length: {all_comments_length / float(num_rows)}")
    if num_rows != 100000:
        sys.exit(f"Expected 100000 rows but got {num_rows}")


if __name__ == "__main__":
    main()
