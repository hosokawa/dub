HTDOCS=../htdocs
PRIVATE=../private

DC=/opt/dmd/bin/dmd
CC=/usr/bin/gcc
LD=/usr/bin/gcc

DSTDLIB=tango
DFLAGS_DEBUG=-gc
DFLAGS_RELEASE=-O -inline -release
DFLAGS_BASE=-I/opt/dmd/include/c -I/opt/dmd/include/${DSTDLIB} -I/opt/dmd/include/tango/tango/core -I/opt/dmd/include/tango/tango/core/rt/compiler/dmd -I`pwd`/site -J.
ifeq (${RELEASE},)
DFLAGS=${DFLAGS_BASE} ${DFLAGS_DEBUG}
else
DFLAGS=${DFLAGS_BASE} ${DFLAGS_RELEASE}
endif
LDFLAGS=-g -m32 -L/opt/dmd/lib -l${DSTDLIB} -lfcgi -lpthread -lm

include objs.mak

.SUFFIXES: .d .dt

.d.o:
	${DC} ${DFLAGS} -c $< -of$@

.dt.o: site/dab/dtcompiler.d
	./dt2o $< $@ ${DC} ${DFLAGS}

all: index.fcgi

index.fcgi: ${OBJS}

clean:
	rm -f objs.mak
	find . -type f \( -name '*.o' -or -name '*.so' -or -name '*.so.*' -or -name '*.di' -or -name '*.fcgi' \) -exec rm -f {} \;

install: all
	install -s -m755 index.fcgi ${HTDOCS}
	mkdir -p ${HTDOCS}/conf
	sed -e 's@<htdocs>.*@<htdocs>'`pwd`/${HTDOCS}'</htdocs>@;s@<private>.*@<private>'`pwd`/${PRIVATE}'</private>@' conf/site.conf > ${HTDOCS}/conf/site.conf
	chmod 644 ${HTDOCS}/conf/site.conf
	install -m444 conf/.htaccess ${HTDOCS}/conf/.htaccess
	install -m444 .htaccess ${HTDOCS}/.htaccess

index.fcgi: ${OBJS}
	${LD} ${OBJS} -o index.fcgi ${LDFLAGS}
