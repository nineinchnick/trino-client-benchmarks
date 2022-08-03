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

	var numRows int
	var allCommentsLength int
	var orderKey int64
	var custKey int64
	var orderStatus string
	var totalPrice float64
	var orderDate string
	var orderPriority string
	var clerk string
	var shipPriority int
	var comment string
	var now string
	for rows.Next() {
		err = rows.Scan(&orderKey, &custKey, &orderStatus, &totalPrice, &orderDate, &orderPriority, &clerk, &shipPriority, &comment, &now)
		if err != nil {
			return err
		}
		numRows++
		allCommentsLength += len(comment)
	}
	err = rows.Err()
	if err != nil {
		return err
	}
	fmt.Printf("Average comment length: %.2f\n", float64(allCommentsLength)/float64(numRows))
	if numRows != 100000 {
		return fmt.Errorf("Expected 100000 rows but got %d", numRows)
	}
	return nil
}
