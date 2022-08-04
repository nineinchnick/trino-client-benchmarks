TRINO_VERSION:=392

.PHONY: all benchmark bin run-java run-go run-python

all: benchmark

bin/trino: bin
	[ -f bin/trino ] || curl -fLsS -o bin/trino https://repo1.maven.org/maven2/io/trino/trino-cli/${TRINO_VERSION}/trino-cli-${TRINO_VERSION}-executable.jar
	chmod +x bin/trino

java/trino-jdbc-${TRINO_VERSION}.jar:
	curl -fLsS -o java/trino-jdbc-${TRINO_VERSION}.jar https://repo1.maven.org/maven2/io/trino/trino-jdbc/${TRINO_VERSION}/trino-jdbc-${TRINO_VERSION}.jar

%.class: java/trino-jdbc-${TRINO_VERSION}.jar
	javac -classpath trino-jdbc-${TRINO_VERSION}.jar java/Client.java

bin:
	mkdir -p bin

bin/%.jar: java/%.class bin
	cd java && jar cvfm ../bin/client.jar manifest.mf *.class

bin/%: go/%.go bin
	cd go && go build -o ../bin/client ./...

benchmark: bin/client.jar bin/client python/client.py bin/trino setup.sql
	# TODO start Trino in a container and pass the random port to test programs
	hyperfine --prepare './bin/trino < setup.sql' --warmup 1 'java -cp java/trino-jdbc-${TRINO_VERSION}.jar:bin/client.jar Client' 'bin/client' './python/client.py'

run-java: bin/client.jar
	time java -cp java/trino-jdbc-${TRINO_VERSION}.jar:bin/client.jar Client

run-go: bin/client
	time ./bin/client

run-python:
	time ./python/client.py

bench-go:
	cd go && go test -bench=. -benchtime=10s
