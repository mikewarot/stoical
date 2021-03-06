
# Makefile for Stoical.	
#
# See src/config.h for build options.

VERS= 0.1.9
META= Makefile
OBJS= kernel.o term.o mem.o hash.o dict.o debug.o string.o signal.o
SRCS= kernel.c term.c dict.c string.c hash.c debug.c mem.c signal.c
PREFIX= /usr/local
NAME = stoical-$(VERS)
LIBROOT= $(PREFIX)/lib/stoical
CFLAGS= -c -DVERSION=\"$(VERS)\" -DLIBROOT=\"$(LIBROOT)\" -Wall -w -O0 -g
LIBS= -lm 

all: src/.depend 
	cd src && $(MAKE)

src/.depend:
	@echo Generating dependencies
	@cd src && $(CC) -MM $(SRCS) > .depend

doc:
	@echo Generating documentation
	@./stoical -l lib util/docex src/words.c lib/def doc/words.d
	@echo Generating Vim syntax
	@mkdir -p vim/syntax
	@./stoical -l lib util/genvim doc/words.d >vim/syntax/stoical.vim
	@cat doc/words.d/* >doc/words; rm -rf doc/words.d

test:
	cd $@ && $(MAKE)

install: all doc
	install -s stoical $(PREFIX)/bin
	mkdir -p $(LIBROOT); cp -R lib/* $(LIBROOT)
	mkdir -p $(PREFIX)/share/doc/stoical
	cp -R COPYING README doc/Stoical doc/words $(PREFIX)/share/doc/stoical
	cp doc/stoical.1 $(PREFIX)/share/man/man1

clean:
	rm -f stoical
	cd src && $(MAKE) $@

distclean: clean
	rm -f Makefile src/Makefile config.cache config.h config.log
	echo -e 'all:\n%:\n\t./configure && $(MAKE) $$@' > Makefile

pkg: distclean
	rm -f $(NAME)
	ln -sf . $(NAME)
	cat MANIFEST | sed 's/^/$(NAME)\//' | xargs tar czvf $(NAME).tar.gz
	rm -f $(NAME)

.PHONY: doc test clean
.EXPORT_ALL_VARIABLES:

