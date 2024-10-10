# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := flint
$(PKG)_WEBSITE  := https://www.flintlib.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.3-p1
$(PKG)_CHECKSUM := 8d75df8f2347534bd3245ef6f43cb91e43abd152572c6fe0bfffda55ec014920
$(PKG)_GH_CONF  := flintlib/flint/releases,v,,,,tar.xz
$(PKG)_DEPS     := cc gmp mpfr pthreads cblas gc

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-pthread \
        --with-gmp-include='$(PREFIX)/$(TARGET)/include' \
        --with-gmp-lib='$(PREFIX)/$(TARGET)/lib' \
        --with-mpfr-include='$(PREFIX)/$(TARGET)/include' \
        --with-mpfr-lib='$(PREFIX)/$(TARGET)/lib' \
        --with-blas-include='$(PREFIX)/$(TARGET)/include' \
        --with-blas-lib='$(PREFIX)/$(TARGET)/lib' \
        --with-gc-include='$(PREFIX)/$(TARGET)/include' \
        --with-gc-lib='$(PREFIX)/$(TARGET)/include' \
        --without-ntl
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(SOURCE_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)

    '$(TARGET)-gcc' \
        -Wall -Werror -ansi -pedantic \
        '$(PWD)/src/$(PKG)-test.c' \
        -o \
        '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
