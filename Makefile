PYTHON := python3

PROJECT_NAME := secure-http-server
VERSION := $(shell $(PYTHON) -c "import secure_server; print(secure_server.__version__)")

SRC_DIR := secure_server
BUILD_DIR := build

REQUIREMENTS := requirements.txt
SETUP_PY := setup.py

.PHONY: all help build install clean

help:
	@echo "Secure HTTP Server - Makefile"
	@echo "=================================="
	@echo ""
	@echo "Available targets:"
	@echo "  - all"
	@echo "  - build"
	@echo "  - install"
	@echo "  - clean"
	@echo "  - help"
	@echo ""

build: clean-build
	@echo "✓ Distribution packages built"
	$(PYTHON) $(SETUP_PY) build

install:
	@echo "✓ Distribution packages install"
	$(PYTHON) $(SETUP_PY) install

all: build install

clean-build:
	rm -rf $(BUILD_DIR)
	rm -rf .eggs
	find . -name '*.egg' -exec rm -f {} +

clean: clean-build

