.PHONY: setup build test clean

setup:
	@echo "Installing dependencies..."
	@go mod tidy
	@echo "Installing golangci-lint..."
	@go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	@echo "Probing network interfaces for build flags..."
	@ifconfig | head -5
	@echo "Setup complete."

build:
	@echo "Building netprobe..."
	@go build -o bin/netprobe ./cmd/netprobe/...
	@echo "Build complete: bin/netprobe"

test:
	@echo "Running tests (requires raw socket access)..."
	@go test -race -v ./...

clean:
	@rm -rf bin/
