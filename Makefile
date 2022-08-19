TRINO_VERSION:=392

.PHONY: all benchmark bin run-java run-go run-python

all: benchmark

bin/trino: bin
	[ -f bin/trino ] || curl -fLsS -o bin/trino https://repo1.maven.org/maven2/io/trino/trino-cli/${TRINO_VERSION}/trino-cli-${TRINO_VERSION}-executable.jar
	chmod +x bin/trino

bin:
	mkdir -p bin

bin/client.jar: java/src/main/java/pl/net/was/Client.java bin
	cd java && mvn package
	cp java/target/trino-client-benchmarks-1.0-SNAPSHOT.jar bin/client.jar

bin/%: go/%.go bin
	cd go && go build -o ../bin/client ./...

benchmark: bin/client.jar bin/client python/client.py bin/trino setup.sql
	# TODO start Trino in a container and pass the random port to test programs
	hyperfine --prepare './bin/trino < setup.sql' --warmup 1 'java -cp $$HOME/.m2/repository/io/trino/trino-jdbc/${TRINO_VERSION}/trino-jdbc-${TRINO_VERSION}.jar:bin/client.jar pl.net.was.Client' 'bin/client' './python/client.py'

run-java: bin/client.jar
	time java -cp $$HOME/.m2/repository/io/trino/trino-jdbc/${TRINO_VERSION}/trino-jdbc-${TRINO_VERSION}.jar:bin/client.jar pl.net.was.Client

run-go: bin/client
	time ./bin/client

run-python:
	time ./python/client.py

bench-java:
	cd java && mvn clean test-compile exec:java -Dexec.mainClass="pl.net.was.BenchmarkRunner" -Dexec.classpathScope=test

bench-go:
	cd go && go test -bench=. -benchtime=10s

bench-python:
	venv/bin/pytest python/client.py
