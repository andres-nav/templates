# Makefile for compiling LaTeX document with LuaTeX

# Set the name of your main .tex file (without the .tex extension)
MAIN ?= main
OUTPUT_PDF ?= report.pdf
MAIN_TEX = $(MAIN).tex
TEMP_TEX = temp.tex
MAIN_PDF = $(MAIN).pdf

VERSION ?= v0.0.0
VERSION_REGEX = ^v[0-9]+\.[0-9]+\.[0-9]+$

# Directory
CURRENT_DIR = $(shell pwd)
BUILD_DIR = $(shell mkdir -p $(CURRENT_DIR)/build && cd $(CURRENT_DIR)/build && pwd)
FIGURES_DIR = $(CURRENT_DIR)/figures
BUILD_PDF_PATH = $(BUILD_DIR)/$(MAIN_PDF)
OUTPUT_PDF_PATH = $(CURRENT_DIR)/$(OUTPUT_PDF)
GHOSTSCRIPT_PDF_PATH = $(OUTPUT_PDF).compressed

LATEX_CMD = latexmk
LATEX_ARGS = -pdflua -bibtex -outdir=$(BUILD_DIR) -jobname=$(MAIN) -interaction=nonstopmode --synctex=1 -file-line-error
GHOSTSCRIPT_CMD = nix run nixpkgs\#ghostscript \--
GHOSTSCRIPT_COMPRESS_ARGS = -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPrinted=true

.PHONY: all
all: compile

.PHONY: compile
compile:
	@echo "Compiling LaTeX document version $(VERSION)..."
	@echo "\def\version{$(VERSION)}" > $(BUILD_DIR)/$(TEMP_TEX)
	@cat $(MAIN_TEX) >> $(BUILD_DIR)/$(TEMP_TEX)
# Always return true, otherwise the warnings will make it error
	SOURCE_DATE_EPOCH=$(shell date +%s) $(LATEX_CMD) $(LATEX_ARGS) $(BUILD_DIR)/$(TEMP_TEX) || true

.PHONY: compress
compress:
	@echo "Compressing PDF..."
	$(GHOSTSCRIPT_CMD) $(GHOSTSCRIPT_COMPRESS_ARGS) -sOutputFile=$(GHOSTSCRIPT_PDF_PATH) $(BUILD_PDF_PATH)
	@mv $(GHOSTSCRIPT_PDF_PATH) $(OUTPUT_PDF_PATH)

.PHONY: publish
publish: compile compress

.PHONY: start
start:
	@if [ -z "$(filter v%,$(firstword $(MAKECMDGOALS)))" ]; then \
		echo "Error: Please provide a valid version (e.g., make start v1.2.3)"; \
		exit 1; \
	fi; \
	VERSION=$(firstword $(MAKECMDGOALS)); \
	if echo "$$VERSION" | grep -Eq "$(VERSION_REGEX)"; then \
		MOB_BRANCH=$(MOB_BRANCH_TITLE)_$$VERSION; \
		echo "Starting mob session with branch $$MOB_BRANCH ..."; \
		mob start --create -i -b $$MOB_BRANCH; \
	else \
		echo "Error: VERSION should be in the format vX.X.X"; \
		exit 1; \
	fi

.PHONY: next
next: publish
	mob next

.PHONY: done
done: publish
	mob done
	git commit

.PHONY: clean
clean:
	@echo "Cleaning up..."
	rm -rf $(BUILD_DIR) $(OUTPUT_PDF_PATH)

# Avoid interpreting the version as a target
%:
	@:
