#!/bin/bash
# Fixes a configure issue due to missing files early in bootstrapping
sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure
# Change an internal script to use sed rather than ed
cp $SHED_PATCHDIR/fix-libmath_h $SHED_SRCDIR/bc/
./configure --prefix=/usr           \
            --with-readline         \
            --mandir=/usr/share/man \
            --infodir=/usr/share/info
make -j $SHED_NUMJOBS
make DESTDIR=$SHED_FAKEROOT install
