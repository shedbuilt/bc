#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
# Change an internal script to use sed rather than ed
if [ -n "${SHED_PKG_LOCAL_OPTIONS[bootstrap]}" ]; then
    # Establish temporary symlinks so bc will see ncurses during configuration
    ln -sv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6 &&
    ln -sfv libncurses.so.6 /usr/lib/libncurses.so &&
    sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure || exit 1
fi
cp "${SHED_PKG_CONTRIB_DIR}/fix-libmath_h" "${SHED_PKG_SOURCE_DIR}/bc/" &&
./configure --prefix=/usr           \
            --with-readline         \
            --mandir=/usr/share/man \
            --infodir=/usr/share/info &&
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install || exit 1

if [ -n "${SHED_PKG_LOCAL_OPTIONS[bootstrap]}" ]; then
    # Remove temporary symlinks
    rm -v /usr/lib/libncurses.so
    rm -v /usr/lib/libncursesw.so.6
fi
