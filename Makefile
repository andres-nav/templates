# Makefile for compiling LaTeX document with LuaTeX

# Set the name of your main .tex file (without the .tex extension)
MAIN ?= main
OUTPUT_PDF ?= report.pdf
DEV_OUTPUT_PDF ?= dev_$(OUTPUT_PDF)
MAIN_TEX = $(MAIN).tex
TEMP_TEX = temp.tex
MAIN_PDF = $(MAIN).pdf

VERSION ?= v0.0.0

# Directory
CURRENT_DIR = $(shell pwd)
BUILD_DIR = $(shell mkdir -p $(CURRENT_DIR)/build && cd $(CURRENT_DIR)/build && pwd)
BUILD_PDF_PATH = $(BUILD_DIR)/$(MAIN_PDF)
OUTPUT_PDF_PATH = $(CURRENT_DIR)/$(OUTPUT_PDF)
DEV_OUTPUT_PDF_PATH = $(CURRENT_DIR)/$(DEV_OUTPUT_PDF)

LATEX_CMD = latexmk
LATEX_ARGS = -pdflua -bibtex -use-make -outdir=$(BUILD_DIR) -jobname=$(MAIN) -interaction=nonstopmode --synctex=1 -file-line-error

.PHONY: all
all: dev
	# make open OPEN_PDF_PATH="$(BUILD_PDF_PATH)"

dev:
	@echo "Add dev version with verison {$(VERSION)}..."
	@echo "\def\\\\version{$(VERSION)}" > $(BUILD_DIR)/$(TEMP_TEX)
	make compile


prod:
	@echo "Creating production version without version info..."
	@echo "" > $(BUILD_DIR)/$(TEMP_TEX)
	make compile

open:
	@echo "Opening PDF..."
	@if [ -z "$(OPEN_PDF_PATH)" ]; then \
		echo "No file specified to open."; \
	elif command -v xdg-open >/dev/null 2>&1; then \
		xdg-open "$(OPEN_PDF_PATH)"; \
	elif command -v open >/dev/null 2>&1; then \
		open "$(OPEN_PDF_PATH)"; \
	else \
		echo "No PDF viewer found."; \
	fi

.PHONY: compile
compile:
	@echo "Compiling LaTeX document..."
	@cat $(MAIN_TEX) >> $(BUILD_DIR)/$(TEMP_TEX)
# Always return true, otherwise the warnings will make it error
	SOURCE_DATE_EPOCH=$(shell date +%s) $(LATEX_CMD) $(LATEX_ARGS) $(BUILD_DIR)/$(TEMP_TEX) || true

compress-dev:
	@echo "Compressing dev PDF..."
	$(GHOSTSCRIPT_CMD) $(GHOSTSCRIPT_COMPRESS_ARGS) -sOutputFile=$(DEV_OUTPUT_COMPRESSED_PDF) $(BUILD_PDF_PATH)

compress-prod:
	@echo "Compressing prod PDF..."
	$(GHOSTSCRIPT_CMD) $(GHOSTSCRIPT_COMPRESS_ARGS) -sOutputFile=$(OUTPUT_COMPRESSED_PDF) $(BUILD_PDF_PATH)
	@mv $(OUTPUT_COMPRESSED_PDF) $(OUTPUT_PDF_PATH)

.PHONY: publish
publish:
	@echo "Published both development and production versions."
	make dev
	@mv $(BUILD_PDF_PATH) $(DEV_OUTPUT_PDF_PATH)
	make prod
	@mv $(BUILD_PDF_PATH) $(OUTPUT_PDF_PATH)
	make open OPEN_PDF_PATH="$(OUTPUT_PDF_PATH)"

.PHONY: clean
clean:
	@echo "Cleaning up..."
	rm -rf $(BUILD_DIR) $(OUTPUT_PDF_PATH)

.PHONY: build-glossary
build-glossary:
	@echo "Building glossary..."
	makeglossaries -d $(BUILD_DIR) $(MAIN)

.PHONY: build-bibliography
build-bibliography:
	@echo "Building bibliography..."
	biber --output-directory $(BUILD_DIR) $(BUILD_DIR)/$(MAIN)

# Avoid interpreting the version as a target
%:
	@:
