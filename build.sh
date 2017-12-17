#!/bin/bash
# Change an internal script to use sed rather than ed
cp "${SHED_PATCHDIR}/fix-libmath_h" "${SHED_SRCDIR}/bc/"
./configure --prefix=/usr           \
            --with-readline         \
            --mandir=/usr/share/man \
            --infodir=/usr/share/info
make -j $SHED_NUMJOBS
make "DESTDIR=$SHED_FAKEROOT" install
