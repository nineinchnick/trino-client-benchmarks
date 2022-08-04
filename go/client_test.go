package main

import (
	"database/sql"
	"testing"
)

func BenchmarkQuery(b *testing.B) {
	db, err := sql.Open("trino", "http://go@localhost:8080")
	if err != nil {
		b.Fatal(err)
	}
	defer db.Close()

	for n := 0; n < b.N; n++ {
		err := query(db)
		if err != nil {
			b.Fatal(err)
		}
	}
}
