.PHONY : test
test:
	${MAKE} distclean; \
	${MAKE} all 2>&1 | \
	    sed -e 's|for program .*[.][.][.]*|for program FOOBAR...|' \
	        -e 's|[.][.][.] /[^ ]*|... /path/to/FOOBAR|' \
	        -e 's/for C compiler type.*$$/for compiler type... known ;-)/' | \
	    awk '/Error code/ {exit 0} {print}' >${.OBJDIR}/_output.tmp; \
	diff ${.CURDIR}/expect.out ${.OBJDIR}/_output.tmp; \
	${MAKE} distclean

CLEANFILES+=	_output.tmp
