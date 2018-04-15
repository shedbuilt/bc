#!/bin/bash
# Change an internal script to use sed rather than ed
cp "${SHED_PKG_PATCH_DIR}/fix-libmath_h" "${SHED_PKG_SOURCE_DIR}/bc/"
if [ "$SHED_BUILD_MODE" == 'bootstrap' ]; then
    # Establish temporary symlinks so bc will see ncurses during configuration
    ln -sv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
    ln -sfv libncurses.so.6 /usr/lib/libncurses.so
    sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure
fi
./configure --prefix=/usr           \
            --with-readline         \
            --mandir=/usr/share/man \
            --infodir=/usr/share/info || exit 1
make -j $SHED_NUM_JOBS || exit 1
make "DESTDIR=$SHED_FAKE_ROOT" install || exit 1
if [ "$SHED_BUILD_MODE" == 'bootstrap' ]; then
    # Remove temporary symlinks
    rm -v /usr/lib/libncurses.so
    rm -v /usr/lib/libncursesw.so.6
fi
