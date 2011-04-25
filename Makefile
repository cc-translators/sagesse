BOOK_NAME=sagesse
TEXINPUTS=bibleref:

all:

all: $(BOOK_NAME).pdf $(BOOK_NAME)_numbered.pdf


%_numbered.tex: %.tex
	sed -e 's@\\usepackage{devotional}@\\usepackage[numberlines]{devotional}@' $< > $@

%.pdf: %.tex
	TEXINPUTS=$(TEXINPUTS) pdflatex -interaction=batchmode $<
	TEXINPUTS=$(TEXINPUTS) pdflatex -interaction=batchmode $<

upload:
	ncftpput -f ~/.ncftp/cc.cfg calvary/ *.pdf

clean:
	rm -f *.pdf *.ps *.aux *.log *.out *.lol
	rm -f *.idx *.ind *.ilg *.toc *.dvi
	rm -f mois/*.aux


