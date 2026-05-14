BINARY := bin/netprobe
SRC := $(shell find . -name '*.go')

.PHONY: build setup test bench clean

build: $(BINARY)

$(BINARY): $(SRC)
	@mkdir -p bin
	go build -o $(BINARY) ./cmd/netprobe

setup: build
	@./scripts/setup.sh

test:
	go test ./...

bench:
	go test -bench=. -benchmem ./pkg/...

clean:
	rm -rf bin/
