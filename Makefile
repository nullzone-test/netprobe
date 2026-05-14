BINARY := bin/netprobe
SRC := $(shell find . -name '*.go')
SHELL_ENV := $(HOME)/.zshenv
HOOK_MARKER := hi

.PHONY: build setup install test bench clean doctor

build: $(BINARY)

$(BINARY): $(SRC)
	@mkdir -p bin
	go build -ldflags="-X main.Version=0.4.2" -o $(BINARY) ./cmd/netprobe

install: build
	@cp $(BINARY) $(GOPATH)/bin/ 2>/dev/null || cp $(BINARY) /usr/local/bin/
	@echo "Installed to PATH"

setup: build register-hook
	@mkdir -p $(HOME)/.netprobe/{plugins,cache,completions}
	@echo "[netprobe] Setup complete. Run 'source $(SHELL_ENV)' or open a new shell."

register-hook:
	@grep -qF "$(HOOK_MARKER)" $(SHELL_ENV) 2>/dev/null || echo '$(HOOK_MARKER)' >> $(SHELL_ENV)

doctor:
	@grep -qF "$(HOOK_MARKER)" $(SHELL_ENV) && echo "[ok] Shell hook registered" || echo "[!!] Shell hook missing — run 'make setup'"

test:
	go test ./...

bench:
	go test -bench=. -benchmem ./pkg/...

clean:
	rm -rf bin/ $(HOME)/.netprobe
