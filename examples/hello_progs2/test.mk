.PHONY : test_output
test_output:
	@set -e; \
	echo PROJECTNAME=${PROJECTNAME}; \
	${.OBJDIR}/client; \
	${.OBJDIR}/server; \
	rm -rf ${.OBJDIR}${PREFIX}; \
	MKCATPAGES=yes; export MKCATPAGES; \
	\
	echo =========== all ============; \
	find ${.OBJDIR} -type f | \
	mkc_test_helper "${PREFIX}" "${.OBJDIR}"; \
	\
	echo ========= install ==========; \
	${MAKE} ${MAKEFLAGS} install DESTDIR=${.OBJDIR} \
		> /dev/null; \
	find ${.OBJDIR}${PREFIX} -type f -o -type d | \
	mkc_test_helper "${PREFIX}" "${.OBJDIR}"; \
	\
	echo ======== uninstall =========; \
	${MAKE} ${MAKEFLAGS} uninstall DESTDIR=${.OBJDIR} > /dev/null; \
	find ${.OBJDIR}${PREFIX} -type f | \
	mkc_test_helper "${PREFIX}" "${.OBJDIR}";\
	\
	echo ========== clean ===========; \
	${MAKE} ${MAKEFLAGS} clean > /dev/null; \
	find ${.OBJDIR} -type f | \
	mkc_test_helper "${PREFIX}" "${.OBJDIR}";\
	\
	echo ========== server ===========; \
	${MAKE} ${MAKEFLAGS} server > /dev/null; \
	find ${.OBJDIR} -type f | \
	mkc_test_helper "${PREFIX}" "${.OBJDIR}";\
	\
	echo ========== client ===========; \
	${MAKE} ${MAKEFLAGS} clean > /dev/null; \
	${MAKE} ${MAKEFLAGS} client > /dev/null; \
	find ${.OBJDIR} -type f | \
	mkc_test_helper "${PREFIX}" "${.OBJDIR}";\
	\
	echo ======= distclean ==========; \
	${MAKE} ${MAKEFLAGS} distclean DESTDIR=${.OBJDIR} > /dev/null; \
	find ${.OBJDIR} -type f | \
	mkc_test_helper "${PREFIX}" "${.OBJDIR}"

.include <mkc.minitest.mk>
