# Note: If the ROSE header and library files are not in standard places,
# define ROSEINSTALL in your environment:

include rules.mk

all: real-all

CXXFLAGS += -I. -Wno-deprecated -IprocessPragmas -ansi -Wall -O2 -ggdb3

EXES     := extractMPISkeleton generateSignatures summarizeSignatures
CCFILES  := $(wildcard *.cc)
CCFILES  += $(filter-out processPragmas/pragmas_main.cc,$(wildcard processPragmas/*.cc))
HFILES   := $(filter-out APIDepAttrib.h,$(wildcard *.h))
DEPENDS  := $(foreach var,$(CCFILES),$(call src2depend,$(var)))
OFILES   := $(patsubst %.cc,%.o,${CCFILES})

LIBS := -lrose

CXX ?= g++
CC  ?= gcc

ROSE_SUB  := projects/extractMPISkeleton
DISTFILES := mpi_api.spec stdio_input.spec apis.coll tests ../mpi-fakeheader

include $(wildcard .depend.*.P)
include $(wildcard processPragmas/.depend.*.P)

real-all: $(EXES)

.PHONY: main
main: $(EXES)

# All the things common to all the executables:
$(EXES): LDFLAGS += $(LIBS)
# having all exes depend on all the .depend.* files means that we
# relink more often than necessary, but this is easier than making the
# dependencies even more precise
$(EXES): $(DEPENDS)
$(EXES): APIDepFinder.o APIReader.o APISpec.o \
         Outline.o ssexpr.o Utils.o SignatureReader.o GenericDepAttrib.o \
         processPragmas/annotatePragmas.o processPragmas/processPragmas.o
$(EXES):
	$(call cmd,o_to_bin)

# Things specific to each exe:
extractMPISkeleton: extractMPISkeleton.o
generateSignatures: generateSignatures.o
summarizeSignatures: summarizeSignatures.o

.PHONY: testclean
testclean:
	(cd tests && ${MAKE} -f Makefile.manual clean)

.PHONY: mostlyclean
mostlyclean: testclean
	rm -rf ${OFILES} *.pdf *.ti .depend.*

.PHONY: clean
clean: mostlyclean
	rm -f $(EXES)

test: extractMPISkeleton
	(cd tests && ${MAKE} -f Makefile.manual test)

TAGS: ${CCFILES} ${HFILES}
	etags $^

rose_git_dir:
	@echo "Please create a file called 'rose_git_dir' containing the path to a clone of the ROSE git repository"

stage: rose_git_dir clean
	cp -f ${CCFILES} ${HFILES} `cat rose_git_dir`/${ROSE_SUB}/src
	cp -f Makefile.am `cat rose_git_dir`/${ROSE_SUB}/src
	cp -fR ${DISTFILES} `cat rose_git_dir`/${ROSE_SUB}
	mkdir -p `cat rose_git_dir`/${ROSE_SUB}/doc
	cp -f doc/user-manual.txt `cat rose_git_dir`/${ROSE_SUB}/doc

show:
	@echo $($(VALUE))              # note: this expands!
