# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := flint
$(PKG)_WEBSITE  := https://www.flintlib.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.3-p1
$(PKG)_CHECKSUM := 5763d4b68be20360da5f5ab41f2b3c481208fe3356fbbbe65bcf168b17acd96f
$(PKG)_GH_CONF  := flintlib/flint/releases,v
$(PKG)_DEPS     := cc gmp mpfr pthreads cblas

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && ./bootstrap.sh
    cd '$(SOURCE_DIR)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-pthread \
        --with-gmp-include='$(PREFIX)/$(TARGET)/include' \
        --with-gmp-lib='$(PREFIX)/$(TARGET)/lib' \
        --with-mpfr-include='$(PREFIX)/$(TARGET)/include' \
        --with-mpfr-lib='$(PREFIX)/$(TARGET)/lib' \
        --with-blas-include='$(PREFIX)/$(TARGET)/include' \
        --with-blas-lib='$(PREFIX)/$(TARGET)/lib' \
        --without-ntl \
        LIBS="`'$(TARGET)-pkg-config' cblas --libs`"
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(SOURCE_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)

    # fix pkg-config file
    $(SED) -i 's!^\(Requires:.*\)!\1 cblas!g' \
        '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    '$(TARGET)-gcc' \
        -Wall -Werror -std=c99 -pedantic \
        '$(PWD)/src/$(PKG)-test.c' \
        -o \
        '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
