#!/bin/bash
# Change an internal script to use sed rather than ed
cp "${SHED_PATCHDIR}/fix-libmath_h" "${SHED_SRCDIR}/bc/"
if [ "$SHED_BUILDMODE" == 'bootstrap' ]; then
    # Establish temporary symlinks so bc will see ncurses during configuration
    ln -sv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
    ln -sfv libncurses.so.6 /usr/lib/libncurses.so
    sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure
fi
./configure --prefix=/usr           \
            --with-readline         \
            --mandir=/usr/share/man \
            --infodir=/usr/share/info || exit 1
make -j $SHED_NUMJOBS || exit 1
make "DESTDIR=$SHED_FAKEROOT" install || exit 1
if [ "$SHED_BUILDMODE" == 'bootstrap' ]; then
    # Remove temporary symlinks
    rm -v /usr/lib/libncurses.so
    rm -v /usr/lib/libncursesw.so.6
fi
