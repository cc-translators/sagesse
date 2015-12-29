BOOK_NAME=sagesse
TEXINPUTS=microtype:
FONTSDIR=fonts
TODAY=$(shell date --iso)
TARGETS=$(BOOK_NAME) $(BOOK_NAME)_numbered $(BOOK_NAME)_annotated
LATEX_INTERACTION=batchmode
FTP_TOPDIR=calvary
FTP_PDFDIR=$(FTP_TOPDIR)/pdf
FTP_JSONDIR=$(FTP_TOPDIR)/json
FTP_EBOOKDIR=$(FTP_TOPDIR)/ebooks

MONTHS=$(shell find $(CURDIR)/mois -type f -name '*.tex')

# Ebook settings
KINDLE_PATH=/documents/raphael
AUTHOR=Chuck Smith
LANGUAGE=fr
PUBDATE=$(shell date +'%Y-%m-%d')
COVER=sagesse_lulu_cover_front.png
TITLE=Sagesse pour Aujourd'hui

EBOOK_CONVERT_OPTS=--authors "$(AUTHOR)" --title "$(TITLE)" --language "$(LANGUAGE)" --pubdate "$(PUBDATE)" --page-breaks-before "//*[name()='h1' or name()='h2' or name()='h3' or @class='pagebreak']" --cover "$(COVER)" --use-auto-toc  --level1-toc "//*[name()='h2']" --level2-toc "//*[name()='h3']" --minimum-line-height=0.4 --font-size-mapping "10,12,14,16,18,20,26,48"

all: pdf

pdf: $(addsuffix .pdf,$(TARGETS))

ebooks: mobi epub

mobi: $(BOOK_NAME).mobi

epub: $(BOOK_NAME).epub

json: pdf $(addsuffix .json,$(TARGETS))


%_numbered.tex: %.tex
	sed -e 's@\\usepackage{devotional}@\\usepackage[numberlines]{devotional}@' $< > $@

%_annotated.tex: %.tex
	sed -e 's@\\usepackage\[disable\]{review}@\\usepackage\[dateinlist\]{review}@' $< > $@

%.pdf: %.tex $(MONTHS)
	OSFONTDIR=$(FONTSDIR) TEXINPUTS=$(TEXINPUTS) lualatex -shell-escape -interaction=$(LATEX_INTERACTION) $<
	OSFONTDIR=$(FONTSDIR) TEXINPUTS=$(TEXINPUTS) lualatex -shell-escape -interaction=$(LATEX_INTERACTION) $<

%.html: %.tex
	OSFONTDIR=$(FONTSDIR) TEXINPUTS=$(TEXINPUTS) htlatex $< \
	   'ebook.cfg,xhtml,charset=utf-8' ' -cunihtf -utf8 -cvalidate'
	bash cleanuphtml.sh $@

%_embedded.epub: %.epub
	rm -rf $*
	unzip  -d $* $<
	cp -r $(FONTSDIR) $*/
	# Add fonts to stylesheet.css
	cat fonts.css >> $*/stylesheet.css
	# Insert fonts into content.opf
	sed -i '/<manifest>/ r fonts.content' $*/content.opf
	# Regenerate zip
	cd $* && zip -Xr9D $(CURDIR)/$@ mimetype *

%.epub: %.html
	ebook-convert $< $@ $(EBOOK_CONVERT_OPTS) --preserve-cover-aspect-ratio

%.mobi: %.epub
	#ebook-convert $< $@ $(EBOOK_CONVERT_OPTS) --mobi-file-type both
	kindlegen $<

%_nolig.mobi: %.html
	ebook-convert $< $@ $(EBOOK_CONVERT_OPTS)

%-to-kindle: %.mobi
	# cp -f doesn't work, we need to remove
	ebook-device rm "$(KINDLE_PATH)/$<"
	-ebook-device mkdir "$(KINDLE_PATH)"
	ebook-device cp $< "prs500:$(KINDLE_PATH)/$<"

%.json: %.pdf
ifeq ($(strip $(TOKEN)),)
	$(error No crocodoc token found in ~/.crocodoc.conf)
endif
	curl -F "file=@$<" -F "token=$(TOKEN)" -F "title=$* $(TODAY)" \
	   https://crocodoc.com/api/v1/document/upload > $@

spellcheck:
	find mois -name "*.tex" -exec aspell -l fr -c {} \;

upload:
	ncftpput -f ~/.ncftp/cc.cfg $(FTP_PDFDIR)/ *.pdf
	ncftpput -f ~/.ncftp/cc.cfg $(FTP_JSONDIR)/ *.json

crocupload: $(BOOK_NAME).json

clean:
	rm -f *.pdf *.ps *.aux *.log *.out *.lol
	rm -f *.idx *.ind *.ilg *.toc *.dvi
	rm -f *.tdo
	rm -f mois/*.aux
	rm -f crocupload
	rm -f *.json
	rm -f *.html *.png *.css *.4tc *.tmp *.xref *.4ct
	rm -f *.idv *.lg
	rm -f *.epub *.mobi

microtype.tar.xz:
	wget http://tlcontrib.metatex.org/2010/archive/microtype.tar.xz

upgrade-microtype: microtype.tar.xz
	rm -rf microtype
	tar xf $< --strip-components=2

gh-pages:
	@tmpdir=`mktemp --tmpdir -d` ; \
	    trap 'rm -rf "$$tmpdir"' EXIT ; \
	    pdf2htmlEX sagesse_lulu.pdf $$tmpdir/index.html ; \
	    git checkout gh-pages ; \
	    mv $$tmpdir/index.html index.html ; \
	    git commit index.html

