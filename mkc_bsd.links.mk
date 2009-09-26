#	$NetBSD: bsd.links.mk,v 1.1.1.1 2006/07/14 23:13:00 jlam Exp $

.PHONY:		linksinstall
realinstall:	linksinstall

.if defined(SYMLINKS) && !empty(SYMLINKS)
linksinstall::
	@(set ${SYMLINKS}; \
	 while test $$# -ge 2; do \
		l=$$1; \
		shift; \
		t=${DESTDIR}$$1; \
		shift; \
		if [ -h $$t ]; then \
			cur=`ls -ld $$t | awk '{print $$NF}'` ; \
			if [ "$$cur" = "$$l" ]; then \
				continue ; \
			fi; \
		fi; \
		echo "$$t -> $$l"; \
		rm -rf $$t; ln -s $$l $$t; \
	 done; )
.for l r in ${SYMLINKS}
UNINSTALLFILES += ${DESTDIR}${r}
.endfor
.endif

.if defined(LINKS) && !empty(LINKS)
linksinstall::
	@(set ${LINKS}; \
	 echo ".include <mkc_bsd.own.mk>"; \
	 while test $$# -ge 2; do \
		l=${DESTDIR}$$1; \
		shift; \
		t=${DESTDIR}$$1; \
		shift; \
		echo "realall: $$t"; \
		echo ".PHONY: $$t"; \
		echo "$$t:"; \
		echo "	@echo \"$$t -> $$l\""; \
		echo "	@rm -f $$t; ln $$l $$t"; \
	 done; \
	) | ${MAKE} -f- all
.for l r in ${LINKS}
UNINSTALLFILES += ${DESTDIR}${r}
.endfor
.endif

.if !target(linksinstall)
linksinstall:
.endif
