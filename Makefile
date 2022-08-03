TRINO_VERSION:=392

.PHONY: all benchmark bin

all: benchmark

trino:
	curl -fLOsS https://repo1.maven.org/maven2/io/trino/trino-cli/${TRINO_VERSION}/trino-cli-${TRINO_VERSION}-executable.jar
	mv trino-cli-${TRINO_VERSION}-executable.jar trino
	chmod +x trino

trino-jdbc-${TRINO_VERSION}.jar:
	curl -fLOsS https://repo1.maven.org/maven2/io/trino/trino-jdbc/${TRINO_VERSION}/trino-jdbc-${TRINO_VERSION}.jar

%.class: trino-jdbc-${TRINO_VERSION}.jar
	javac -classpath trino-jdbc-${TRINO_VERSION}.jar Client.java

bin:
	mkdir -p bin

bin/%.jar: %.class bin
	jar cvfm bin/client.jar manifest.mf *.class

bin/%: %.go bin
	go build -o bin/client ./...

benchmark: bin/client.jar bin/client client.py trino setup.sql
	# TODO start Trino in a container and pass the random port to test programs
	hyperfine --prepare './trino < setup.sql' 'java -cp trino-jdbc-${TRINO_VERSION}.jar:bin/client.jar Client' 'bin/client' './client.py'
