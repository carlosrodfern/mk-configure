# Copyright (c) 2009-2014 by Aleksey Cheusov
#
# See LICENSE file in the distribution.
############################################################

# Given a list of files in INFILES or INSCRIPTS mkc.intexts.mk
# generates them from appropriate *.in files replacing @prefix@,
# @sysconfdir@, @libdir@, @bindir@, @sbindir@, @datadir@ etc. with
# real ${PREFIX}, ${SYSCONFDIR} etc. See examples/ projects.

.ifndef _MKC_IMP_INTEXTS_MK
_MKC_IMP_INTEXTS_MK := 1

MESSAGE.gen ?=	@${_MESSAGE} "GEN: ${.TARGET}"

INTEXTS_SED  +=	-e 's,@sysconfdir@,${SYSCONFDIR},g'
INTEXTS_SED  +=	-e 's,@libdir@,${LIBDIR},g'
INTEXTS_SED  +=	-e 's,@libexecdir@,${LIBEXECDIR},g'
INTEXTS_SED  +=	-e 's,@prefix@,${PREFIX},g'
INTEXTS_SED  +=	-e 's,@bindir@,${BINDIR},g'
INTEXTS_SED  +=	-e 's,@sbindir@,${SBINDIR},g'
INTEXTS_SED  +=	-e 's,@datadir@,${DATADIR},g'
INTEXTS_SED  +=	-e 's,@mandir@,${MANDIR},g'
INTEXTS_SED  +=	-e 's,@incsdir@,${INCSDIR},g'
INTEXTS_SED  +=	-e 's,@vardir@,${VARDIR},g'
INTEXTS_SED  +=	-e 's,@sharedstatedir@,${SHAREDSTATEDIR},g'

.if ${MKCHECKS} == "yes"
.  if !empty(INTEXTS_REPLS) && ${INTEXTS_REPLS:[\#]:M*[13579]} != ""
MKC_ERR_MSG +=	"ERROR: odd number of tokens in INTEXTS_REPLS"
.  else
.    for _pattern _repl in ${INTEXTS_REPLS}
INTEXTS_SED  +=	-e 's,@${_pattern}@,${_repl},g'
.    endfor
.  endif
.endif

.for i in ${INFILES}
.NOPATH: ${i:T}
${i:T} : ${i}.in
	${MESSAGE.gen}
	${_V} sed ${INTEXTS_SED} ${.ALLSRC} > ${.TARGET} && \
	chmod 0644 ${.TARGET}
.endfor

.for i in ${INSCRIPTS}
.NOPATH: ${i:T}
${i:T} : ${i}.in
	${MESSAGE.gen}
	${_V} sed ${INTEXTS_SED} ${.ALLSRC} > ${.TARGET} && \
	chmod 0755 ${.TARGET}
.endfor

CLEANFILES   +=	${INSCRIPTS:T} ${INFILES:T}

realdo_all: ${INSCRIPTS:T} ${INFILES:T}

######################################################################
.endif # _MKC_IMP_INTEXTS_MK
