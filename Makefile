## config file
MKRC ?= latexmkrc

## source *.tex file
SOURCE ?= dissertation

## LaTeX compiler output *.pdf file
TARGET ?= $(SOURCE)

## LaTeX version
# -pdf		= pdflatex
# -xelatex	= xelatex without dvi
# -lualatex	= lualatex without dvi
BACKEND ?= -lualatex

LATEXFLAGS ?= -synctex=1 -shell-escape -halt-on-error -file-line-error
LATEXMKFLAGS ?= -silent
BIBERFLAGS ?= # --fixinits
REGEXDIRS ?= . dissertation presentation # distclean dirs
TIMERON ?= # show CPU usage

## Makefile options
MAKEFLAGS := -s
.DEFAULT_GOAL := all
.NOTPARALLEL:


export LATEXFLAGS
export BIBERFLAGS
export REGEXDIRS
export TIMERON


all: dissertation presentation


define compile
	latexmk -norc -r $(MKRC) $(LATEXMKFLAGS) $(BACKEND) -latexoption="$(LATEXFLAGS)" -jobname=$(TARGET) $(SOURCE)
endef


dissertation: TARGET=dissertation
dissertation: SOURCE=dissertation
dissertation:
	$(compile)

presentation: TARGET=presentation
presentation: SOURCE=presentation
presentation:
	$(compile)


## to overcome temporary problems with removing directories
clean-fix:
	rm -rf pythontex-files-$(SOURCE) __pycache__
	rm -rf _minted-$(SOURCE) $(SOURCE).minted*

clean-target:
	latexmk -norc -r $(MKRC) -f $(LATEXMKFLAGS) $(BACKEND) -jobname=$(TARGET) -c $(SOURCE)

distclean-target: clean-fix
	latexmk -norc -r $(MKRC) -f $(LATEXMKFLAGS) $(BACKEND) -jobname=$(TARGET) -C $(SOURCE)

clean:
	"$(MAKE)" SOURCE=dissertation TARGET=dissertation clean-target
	"$(MAKE)" SOURCE=presentation TARGET=presentation clean-target

distclean:
	"$(MAKE)" SOURCE=dissertation TARGET=dissertation distclean-target
	"$(MAKE)" SOURCE=presentation TARGET=presentation distclean-target


.PHONY: all dissertation presentation clean-fix clean-target distclean-target clean distclean

