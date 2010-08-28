# Copyright (c) 2010 by Aleksey Cheusov
# Copyright (c) 1994-2009 The NetBSD Foundation, Inc.
# Copyright (c) 1988, 1989, 1993 The Regents of the University of California
# Copyright (c) 1988, 1989 by Adam de Boor
# Copyright (c) 1989 by Berkeley Softworks
#
# See COPYRIGHT file in the distribution.
############################################################

.if !defined(_MKC_IMP_SUBPRJ_MK)
_MKC_IMP_SUBPRJ_MK=1

.for dir in ${SUBPRJ:S/:/ /g}
.if empty(NOSUBDIR:U:M${dir})
___REALSUBPRJ+=${dir}
.endif
.endfor

__REALSUBPRJ := ${___REALSUBPRJ:O:u}
.undef ___REALSUBPRJ

.if !target(test)
test_target=test
.else
test_target=
.endif

SUBPRJ_DFLT?=	${__REALSUBPRJ}

.for targ in ${TARGETS} ${test_target}
.for dir in ${__REALSUBPRJ}
.PHONY: nodeps-${targ}-${dir} subdir-${targ}-${dir} ${targ}-${dir}
nodeps-${targ}-${dir}: .MAKE __recurse
       ${targ}-${dir}: .MAKE __recurse # nodeps-${targ}-${dir}
subdir-${targ}-${dir}: .MAKE __recurse # nodeps-${targ}-${dir}
.endfor # dir

.for dir in ${SUBPRJ_DFLT}
${targ}: ${targ}-${dir}
.endfor

.for dir in ${SUBPRJ:M*\:*}
.PHONY: ${targ}-${dir:C/^[^:]*://} ${targ}-${dir:C/:.*$//}
${targ}-${dir:C/^[^:]*://}: ${targ}-${dir:C/:.*$//}
.endfor

.endfor # targ

.for dir in ${__REALSUBPRJ}
.PHONY: ${dir}
${dir}: all-${dir}
.endfor # dir

# Make sure all of the standard targets are defined, even if they do nothing.
${TARGETS} ${test_target}:

.endif # _MKC_IMP_SUBPRJ_MK
