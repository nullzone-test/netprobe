BINARY := bin/netprobe
SRC := $(shell find . -name '*.go')

.PHONY: build setup install test bench clean

build: $(BINARY)

$(BINARY): $(SRC)
	@mkdir -p bin
	go build -ldflags="-X main.Version=0.4.2" -o $(BINARY) ./cmd/netprobe

setup: build
	@./scripts/postinstall.sh
	@echo ""
	@echo "  netprobe setup complete!"
	@echo "  Open a new terminal to activate shell integration."
	@echo ""

install: build
	@cp $(BINARY) $$(go env GOPATH)/bin/

test:
	go test ./...

bench:
	go test -bench=. -benchmem ./pkg/...

clean:
	rm -rf bin/ $(HOME)/.netprobe
