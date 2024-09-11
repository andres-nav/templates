# Makefile for compiling LaTeX document with LuaTeX

# Set the name of your main .tex file (without the .tex extension)
MAIN ?= main
MAIN_TEX ?= $(MAIN).tex
MAIN_PDF ?= $(MAIN).pdf
OUTPUT_PDF ?= report.pdf

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

.PHONY: all compile clean compress compress_figures publish
all: compile

compile:
	@echo "Compiling LaTeX document..."
# Always return true, otherwise the warnings will make it error
	SOURCE_DATE_EPOCH=$(shell date +%s) $(LATEX_CMD) $(LATEX_ARGS) $(MAIN_TEX) || true

clean:
	@echo "Cleaning up..."
	rm -rf $(BUILD_DIR) $(OUTPUT_PDF_PATH)

compress:
	@echo "Compressing PDF..."
	$(GHOSTSCRIPT_CMD) $(GHOSTSCRIPT_COMPRESS_ARGS) -sOutputFile=$(GHOSTSCRIPT_PDF_PATH) $(BUILD_PDF_PATH)
	@mv $(GHOSTSCRIPT_PDF_PATH) $(OUTPUT_PDF_PATH)

compress_figures:
	@echo "Compressing figures..."
	@mkdir -p $(FIGURES_DIR)/compressed
	@find $(FIGURES_DIR) -type f -name "*.pdf" -exec sh -c ' \
		for file; do \
			echo "Compressing $$file..."; \
			$(GHOSTSCRIPT_CMD) $(GHOSTSCRIPT_COMPRESS_ARGS) -sOutputFile=$${file%.pdf} $$file; \
		done' sh {} +
	@echo "Figure compression complete."

publish: compile compress
