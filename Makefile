# Minimal Makefile for sequential-image-analyzer
PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
SRC ?= bin/sequential-image-analyzer.sh
TARGET ?= $(BINDIR)/sequential-image-analyzer

.PHONY: install verify uninstall

install:
	@echo "[INFO] Installing sequential-image-analyzer to $(BINDIR)..."
	@sudo cp "$(SRC)" "$(TARGET)"
	@sudo chmod 755 "$(TARGET)"
	@echo "[INFO] Installed to $(TARGET)"

verify:
	@echo "[INFO] Verifying sequential-image-analyzer..."
	@if command -v sequential-image-analyzer >/dev/null 2>&1; then \
	  echo "OK: found in PATH: $$(command -v sequential-image-analyzer)"; \
	elif [ -x "./$(SRC)" ]; then \
	  echo "OK: local $(SRC) is executable"; \
	else \
	  echo "NOT FOUND: run 'make install' or place the script in your PATH"; exit 1; \
	fi

uninstall:
	@echo "[INFO] Removing sequential-image-analyzer from $(BINDIR)..."
	@sudo rm -f "$(TARGET)"
	@echo "[INFO] Uninstalled"
