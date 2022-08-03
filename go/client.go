package main

import (
	"database/sql"
	"fmt"
	"os"

	_ "github.com/trinodb/trino-go-client/trino"
)

func main() {
	err := query()
	if err != nil {
		panic(err)
	}
}

func query() error {
	query, err := os.ReadFile("query.sql")
	if err != nil {
		return err
	}

	db, err := sql.Open("trino", "http://go@localhost:8080")
	if err != nil {
		return err
	}
	defer db.Close()

	rows, err := db.Query(string(query))
	if err != nil {
		return err
	}
	defer rows.Close()

	var count int
	for rows.Next() {
		count++
	}
	err = rows.Err()
	if err != nil {
		return err
	}
	if count != 100000 {
		return fmt.Errorf("Expected 100000 rows but got %d", count)
	}
	return nil
}
