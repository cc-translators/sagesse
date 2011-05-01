BOOK_NAME=sagesse
TEXINPUTS=bibleref:
TODAY=$(shell date --iso)

all:

all: $(BOOK_NAME).pdf $(BOOK_NAME)_numbered.pdf


%_numbered.tex: %.tex
	sed -e 's@\\usepackage{devotional}@\\usepackage[numberlines]{devotional}@' $< > $@

%.pdf: %.tex
	TEXINPUTS=$(TEXINPUTS) pdflatex -interaction=batchmode $<
	TEXINPUTS=$(TEXINPUTS) pdflatex -interaction=batchmode $<

upload:
	ncftpput -f ~/.ncftp/cc.cfg calvary/ *.pdf

crocupload: $(BOOK_NAME).pdf
	cp $(BOOK_NAME).pdf $(BOOK_NAME)_$(TODAY).pdf
	./crocupload.sh "$(BOOK_NAME)_$(TODAY).pdf" "$(BOOK_NAME) $(TODAY)"

clean:
	rm -f *.pdf *.ps *.aux *.log *.out *.lol
	rm -f *.idx *.ind *.ilg *.toc *.dvi
	rm -f mois/*.aux


