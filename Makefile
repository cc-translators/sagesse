BOOK_NAME=sagesse
TEXINPUTS=bibleref:
TODAY=$(shell date --iso)
TARGETS=$(BOOK_NAME) $(BOOK_NAME)_numbered
FTP_TOPDIR=calvary
FTP_PDFDIR=$(FTP_TOPDIR)/pdf
FTP_JSONDIR=$(FTP_TOPDIR)/json

# Include crocodoc conf
include ~/.crocodoc.conf

all: pdf

pdf: $(addsuffix .pdf,$(TARGETS))

json: pdf $(addsuffix .json,$(TARGETS))


%_numbered.tex: %.tex
	sed -e 's@\\usepackage{devotional}@\\usepackage[numberlines]{devotional}@' $< > $@

%.pdf: %.tex
	TEXINPUTS=$(TEXINPUTS) pdflatex -interaction=batchmode $<
	TEXINPUTS=$(TEXINPUTS) pdflatex -interaction=batchmode $<

%.json: %.pdf
ifeq ($(strip $(TOKEN)),)
	$(error No crocodoc token found in ~/.crocodoc.conf)
endif
	curl -F "file=@$<" -F "token=$(TOKEN)" -F "title=$* $(TODAY)" \
	   https://crocodoc.com/api/v1/document/upload > $@

upload:
	ncftpput -f ~/.ncftp/cc.cfg $(FTP_PDFDIR)/ *.pdf
	ncftpput -f ~/.ncftp/cc.cfg $(FTP_JSONDIR)/ *.json

crocupload: $(BOOK_NAME).json

clean:
	rm -f *.pdf *.ps *.aux *.log *.out *.lol
	rm -f *.idx *.ind *.ilg *.toc *.dvi
	rm -f mois/*.aux
	rm -f crocupload
	rm -f *.json


