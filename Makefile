
.SILENT:

# General rule is that CAPITAL variables are constants and can be used
# via $(VARNAME), while lowercase variables are dynamic and need to be
# used via $(call varname,$@) (note no space between comma and $@)

REL     := $(if $(REL),$(REL),2.5.0)
SUBREL  := $(if $(SUBREL),$(SUBREL),testing)
ARDUINO := $(if $(ARDUINO),$(ARDUINO),$(shell pwd)/arduino)
GCC     := $(if $(GCC),$(GCC),4.8)

# General constants
PWD      := $(shell pwd)
REPODIR  := $(PWD)/repo
PATCHDIR := $(PWD)/patches
STAMP    := $(shell date +%y%m%d)

# For uploading, the GH user and PAT
GHUSER := $(if $(GHUSER),$(GHUSER),$(shell cat .ghuser))
GHTOKEN := $(if $(GHTOKEN),$(GHTOKEN),$(shell cat .ghtoken))
ifeq ($(GHUSER),)
    $(error Need to specify GH username on the command line "GHUSER=xxxx" or in .ghuser)
else ifeq ($(GHTOKEN),)
    $(error Need to specify GH PAT on the command line "GHTOKEN=xxxx" or in .ghtoken)
endif

# Depending on the GCC version get proper branch and support libs
ifeq ($(GCC),4.8)
    ISL           := 0.12.2
    GCC_BRANCH    := call0-4.8.2
    GCC_PKGREL    := 40802
    GCC_REPO      := https://github.com/$(GHUSER)/gcc-xtensa.git
    GCC_DIR       := gcc
    BINUTILS_BRANCH := master
    BINUTILS_REPO := https://github.com/$(GHUSER)/binutils-gdb-xtensa.git
    BINUTILS_DIR  := binutils-gdb
else ifeq ($(GCC),4.9)
    ISL           := 0.12.2
    GCC_BRANCH    := call0-4.9.2
    GCC_PKGREL    := 40902
    GCC_REPO      := https://github.com/$(GHUSER)/gcc-xtensa.git
    GCC_DIR       := gcc
    BINUTILS_BRANCH := master
    BINUTILS_REPO := https://github.com/$(GHUSER)/binutils-gdb-xtensa.git
    BINUTILS_DIR  := binutils-gdb
else ifeq ($(GCC),5.2)
    ISL           := 0.12.2
    GCC_BRANCH    := xtensa-ctng-esp-5.2.0
    GCC_PKGREL    := 50200
    GCC_REPO      := https://github.com/$(GHUSER)/gcc-xtensa.git
    GCC_DIR       := gcc
    BINUTILS_BRANCH := master
    BINUTILS_REPO := https://github.com/$(GHUSER)/binutils-gdb-xtensa.git
    BINUTILS_DIR  := binutils-gdb
else ifeq ($(GCC),7.2)
    ISL           := 0.16.1
    GCC_BRANCH    := xtensa-ctng-7.2.0
    GCC_PKGREL    := 70200
    GCC_REPO      := https://github.com/$(GHUSER)/gcc-xtensa.git
    GCC_DIR       := gcc
    BINUTILS_BRANCH := master
    BINUTILS_REPO := https://github.com/$(GHUSER)/binutils-gdb-xtensa.git
    BINUTILS_DIR  := binutils-gdb
else ifeq ($(GCC), 9.1)
    ISL           := 0.18
    GCC_BRANCH    := gcc-9_1_0-release
    GCC_PKGREL    := 90100
    GCC_REPO      := https://gcc.gnu.org/git/gcc.git
    GCC_DIR       := gcc-gnu
    BINUTILS_BRANCH := binutils-2_32
    BINUTILS_REPO := https://sourceware.org/git/binutils-gdb.git
    BINUTILS_DIR  := binutils-gdb-gnu
else ifeq ($(GCC), 9.2)
    ISL           := 0.18
    GCC_BRANCH    := gcc-9_2_0-release
    GCC_PKGREL    := 90200
    GCC_REPO      := https://gcc.gnu.org/git/gcc.git
    GCC_DIR       := gcc-gnu
    BINUTILS_BRANCH := binutils-2_32
    BINUTILS_REPO := https://sourceware.org/git/binutils-gdb.git
    BINUTILS_DIR  := binutils-gdb-gnu
else ifeq ($(GCC), 9.3)
    ISL           := 0.18
    GCC_BRANCH    := releases/gcc-9.3.0
    GCC_PKGREL    := 90300
    GCC_REPO      := https://gcc.gnu.org/git/gcc.git
    GCC_DIR       := gcc-gnu
    BINUTILS_BRANCH := binutils-2_32
    BINUTILS_REPO := https://sourceware.org/git/binutils-gdb.git
    BINUTILS_DIR  := binutils-gdb-gnu
else ifeq ($(GCC), 10.1)
    ISL           := 0.18
    GCC_BRANCH    := releases/gcc-10.1.0
    GCC_PKGREL    := 100100
    GCC_REPO      := https://gcc.gnu.org/git/gcc.git
    GCC_DIR       := gcc-gnu
    BINUTILS_BRANCH := binutils-2_32
    BINUTILS_REPO := https://sourceware.org/git/binutils-gdb.git
    BINUTILS_DIR  := binutils-gdb-gnu
else ifeq ($(GCC), 10.2)
    ISL           := 0.18
    GCC_BRANCH    := releases/gcc-10.2.0
    GCC_PKGREL    := 100200
    GCC_REPO      := https://gcc.gnu.org/git/gcc.git
    GCC_DIR       := gcc-gnu
    BINUTILS_BRANCH := binutils-2_32
    BINUTILS_REPO := https://sourceware.org/git/binutils-gdb.git
    BINUTILS_DIR  := binutils-gdb-gnu
else ifeq ($(GCC), 10.3)
    ISL           := 0.18
    GCC_BRANCH    := releases/gcc-10.3.0
    GCC_PKGREL    := 100300
    GCC_REPO      := https://gcc.gnu.org/git/gcc.git
    GCC_DIR       := gcc-gnu
    BINUTILS_BRANCH := binutils-2_32
    BINUTILS_REPO := https://sourceware.org/git/binutils-gdb.git
    BINUTILS_DIR  := binutils-gdb-gnu
else ifeq ($(GCC), 11.1)
    ISL           := 0.18
    GCC_BRANCH    := releases/gcc-11.1.0
    GCC_PKGREL    := 110100
    GCC_REPO      := https://gcc.gnu.org/git/gcc.git
    GCC_DIR       := gcc-gnu
    BINUTILS_BRANCH := binutils-2_32
    BINUTILS_REPO := https://sourceware.org/git/binutils-gdb.git
    BINUTILS_DIR  := binutils-gdb-gnu
else ifeq ($(GCC), 14.2)
    ISL           := 0.18
    GCC_BRANCH    := releases/gcc-14.2.0
    GCC_PKGREL    := 140200
    GCC_REPO      := https://gcc.gnu.org/git/gcc.git
    GCC_DIR       := gcc-gnu
    BINUTILS_BRANCH := binutils-2_44
    BINUTILS_REPO := https://sourceware.org/git/binutils-gdb.git
    BINUTILS_DIR  := binutils-gdb-gnu
else
    $(error Need to specify a supported GCC version "GCC={4.8, 4.9, 5.2, 7.2, 9.3, 10.1, 10.2, 10.3, 14.2}")
endif

TARGET_ARCH := xtensa-lx106-elf

# MKSPIFFS must stay at 0.2.0 until Arduino boards.txt.py fixes non-page-aligned sizes
MKSPIFFS_BRANCH := 0.2.0

# libelf shared by the repo here
LIBELF_VER = 0.8.13
LIBELF_BLOB = $(PWD)/blobs/libelf-$(LIBELF_VER).tar.gz

# GNU GDB & the rest of external dependencies
ISL_URL = https://libisl.sourceforge.io/isl-$(ISL).tar.xz

GMP_VER = 6.3.0
GMP_URL = https://gmplib.org/download/gmp/gmp-$(GMP_VER).tar.xz

MPFR_VER = 4.2.2
MPFR_URL = https://www.mpfr.org/mpfr-current/mpfr-$(MPFR_VER).tar.xz

MPC_VER = 1.3.1
MPC_URL = https://ftp.gnu.org/gnu/mpc/mpc-$(MPC_VER).tar.gz

CLOOG_VER = 0.18.1
CLOOG_URL = https://github.com/periscop/cloog/releases/download/cloog-$(CLOOG_VER)/cloog-$(CLOOG_VER).tar.gz

LIBEXPAT_VER = 2.7.1
LIBEXPAT_REV = R_$(subst .,_,$(LIBEXPAT_VER))
LIBEXPAT_URL = https://github.com/libexpat/libexpat/releases/download/$(LIBEXPAT_REV)/expat-$(LIBEXPAT_VER).tar.bz2

NCURSES_VER = 8d252361ceeb3db4f8dec861e0fb414352e88b13
NCURSES_URL = https://github.com/ThomasDickey/ncurses-snapshots/archive/$(NCURSES_VER).zip

URLS := \
	$(GMP_URL) \
	$(ISL_URL) \
	$(LIBEXPAT_URL) \
	$(MPC_URL) \
	$(MPFR_URL) \
	$(NCURSES_URL)

ifeq ($(GCC), 4.8)
	URLS += $(CLOOG_URL)
else ifeq ($(GCC), 4.9)
	URLS += $(CLOOG_URL)
endif

# LTO doesn't work on 4.8, may not be useful later
LTO := $(if $(lto),$(lto),false)

# Define the build and output naming, don't use directly (see below)
# currently not using ..._STATIC, but it would be called for tools builds
LINUX_HOST   := x86_64-linux-gnu
LINUX_AHOST  := x86_64-pc-linux-gnu
LINUX_EXT    := .x86_64
LINUX_EXE    := 
LINUX_MKTGT  := linux
LINUX_TARCMD := tar
LINUX_TAROPT := zcf
LINUX_TAREXT := tar.gz
LINUX_ASYS   := linux_x86_64

LINUX32_HOST   := i686-linux-gnu
LINUX32_AHOST  := i686-pc-linux-gnu
LINUX32_EXT    := .i686
LINUX32_EXE    := 
LINUX32_MKTGT  := linux
LINUX32_TARCMD := tar
LINUX32_TAROPT := zcf
LINUX32_TAREXT := tar.gz
LINUX32_ASYS   := linux_i686

WIN32_HOST   := i686-w64-mingw32
WIN32_AHOST  := i686-mingw32
WIN32_EXT    := .win32
WIN32_EXE    := .exe
WIN32_MKTGT  := windows
WIN32_TARCMD := zip
WIN32_TAROPT := -rq
WIN32_TAREXT := zip
WIN32_ASYS   := windows_x86

WIN64_HOST   := x86_64-w64-mingw32
WIN64_AHOST  := x86_64-mingw32
WIN64_EXT    := .win64
WIN64_EXE    := .exe
WIN64_MKTGT  := windows
WIN64_TARCMD := zip
WIN64_TAROPT := -rq
WIN64_TAREXT := zip
WIN64_ASYS   := windows_amd64

MACOSX86_HOST   := x86_64-apple-darwin20.4
MACOSX86_AHOST  := x86_64-apple-darwin
MACOSX86_EXT    := .macosx86
MACOSX86_EXE    :=
MACOSX86_MKTGT  := macosx86
MACOSX86_TARCMD := tar
MACOSX86_TAROPT := zcf
MACOSX86_TAREXT := tar.gz
MACOSX86_ASYS   := darwin_x86_64

MACOSARM_HOST   := aarch64-apple-darwin20.4
MACOSARM_AHOST  := arm64-apple-darwin
MACOSARM_EXT    := .macosarm
MACOSARM_EXE    :=
MACOSARM_MKTGT  := macosarm
MACOSARM_TARCMD := tar
MACOSARM_TAROPT := zcf
MACOSARM_TAREXT := tar.gz
MACOSARM_ASYS   := darwin_arm64

# 1. --disable-lto , per immediately broken mpfr builds
#    also disabled in pico toolchain, which uses the same osxcross dist
# 2. macOS cross tools have to be explicitly stated when configuring build env
#    host & target arch autodetection does not work for some reason and uses local gcc instead
MACOSARM_CONFIGURE_VARS := \
	--disable-lto \
	CC=$(MACOSARM_HOST)-cc \
	CXX=$(MACOSARM_HOST)-c++ \
	STRIP=touch

ARM64_HOST   := aarch64-linux-gnu
ARM64_AHOST  := aarch64-linux-gnu
ARM64_EXT    := .arm64
ARM64_EXE    := 
ARM64_MKTGT  := linux
ARM64_TARCMD := tar
ARM64_TAROPT := zcf
ARM64_TAREXT := tar.gz
ARM64_ASYS   := linux_aarch64

RPI_HOST   := arm-linux-gnueabihf
RPI_AHOST  := arm-linux-gnueabihf
RPI_EXT    := .rpi
RPI_EXE    := 
RPI_MKTGT  := linux
RPI_TARCMD := tar
RPI_TAROPT := zcf
RPI_TAREXT := tar.gz
RPI_ASYS   := linux_armv6l\",\ \"linux_armv7l

# Call with $@ to get the appropriate variable for this architecture
host   = $($(call arch,$(1))_HOST)
ahost  = $($(call arch,$(1))_AHOST)
ext    = $($(call arch,$(1))_EXT)
exe    = $($(call arch,$(1))_EXE)
mktgt  = $($(call arch,$(1))_MKTGT)
tarcmd = $($(call arch,$(1))_TARCMD)
taropt = $($(call arch,$(1))_TAROPT)
tarext = $($(call arch,$(1))_TAREXT)
log    = log$(1)

# For package.json
asys   = $($(call arch,$(1))_ASYS)

# sometimes called for ./configure
configure_vars = $($(call arch,$(1))_CONFIGURE_VARS)

# The build directory per architecture
arena = $(PWD)/arena$(call ext,$(1))
# The architecture for this recipe
arch = $(subst .,,$(suffix $(basename $(1))))
# This installation directory for this architecture
install = $(PWD)/xtensa-lx106-elf$($(call arch,$(1))_EXT)
# Shared libraries build prefix
cross = $(call arena,$(1))/cross
ldflags = -L$(call cross,$(1))/lib
cflags = -I$(call cross,$(1))/include

# GCC et. al configure options
configure  = --prefix=$(call install,$(1))
configure += --build=$(shell gcc -dumpmachine)
configure += --host=$(call host,$(1))
configure += --target=$(TARGET_ARCH)
configure += --disable-shared
configure += --with-newlib
configure += --enable-threads=no
configure += --disable-__cxa_atexit
configure += --disable-libgomp
configure += --disable-libmudflap
configure += --disable-nls
configure += --disable-multilib
configure += --disable-bootstrap
configure += --enable-languages=c,c++
configure += --enable-lto
configure += --enable-static=yes
configure += --disable-libstdcxx-verbose
configure += $(call configure_vars,$(1))

ifeq ($(GCC), 14.2)
configure += --enable-libstdcxx-static-eh-pool
configure += --with-libstdcxx-eh-pool-obj-count=4
endif

# Shared dependencies
configure_gmp_mpfr = \
	--with-gmp=$(call arena,$(1))/cross \
	--with-mpfr=$(call arena,$(1))/cross

configure_ncurses = \
	--disable-widec \
	--without-manpages \
	--without-progs \
	--without-shared \
	--without-tack \
	--without-tests \
	--with-termlib \
	--with-versioned-syms

configure_expat = \
	--without-examples \
	--without-tests

# Newlib configuration common
CONFIGURENEWLIBCOM  = --with-newlib
CONFIGURENEWLIBCOM += --enable-multilib
CONFIGURENEWLIBCOM += --disable-newlib-io-c99-formats
CONFIGURENEWLIBCOM += --disable-newlib-supplied-syscalls
CONFIGURENEWLIBCOM += --enable-newlib-nano-formatted-io
CONFIGURENEWLIBCOM += --enable-newlib-reent-small
CONFIGURENEWLIBCOM += --enable-target-optspace
CONFIGURENEWLIBCOM += --disable-option-checking
CONFIGURENEWLIBCOM += --target=$(TARGET_ARCH)
CONFIGURENEWLIBCOM += --disable-shared

# Configuration for newlib normal build
configurenewlib  = --prefix=$(call install,$(1))
configurenewlib += $(CONFIGURENEWLIBCOM)

# Configuration for newlib install-to-arduino target
CONFIGURENEWLIBINSTALL  = --prefix=$(ARDUINO)/tools/sdk/libc
CONFIGURENEWLIBINSTALL += --with-target-subdir=xtensa-lx106-elf
CONFIGURENEWLIBINSTALL += $(CONFIGURENEWLIBCOM)

# Configuration specific to macOS

# GMP tries to test .s, which breaks on ./configure stage
CONFIGURE_GMP_MACOSARM := --disable-assembly
CONFIGURE_GMP_MACOSX86 := $(CONFIGURE_GMP_MACOSARM)

# The branch in which to store the new toolchain
INSTALLBRANCH ?= master

# Environment variables for configure and building targets.  Only use $(call setenv,$@)
ifeq ($(LTO),true)
    CFFT := "-mlongcalls -flto -Wl,-flto -Os -g -free -fipa-pta"
else ifeq ($(LTO),false)
    CFFT := "-mlongcalls -Os -g -free -fipa-pta"
else
    $(error Need to specify LTO={true,false} on the command line)
endif

# Generic opts passed to both CC and CXX
SHARED_OPT_FLAGS := -pipe -g -O2

# Sets the environment variables for a subshell while building
setenv = export CFLAGS_FOR_TARGET=$(CFFT); \
		 export CXXFLAGS_FOR_TARGET=$(CFFT); \
		 export CFLAGS="$(call cflags,$(1)) $(SHARED_OPT_FLAGS)"; \
		 export CXXFLAGS="$(SHARED_OPT_FLAGS)"; \
		 export LDFLAGS="$(call ldflags,$(1))"; \
		 export PATH="$(call cross,$(1))/bin:$(call install,.stage.LINUX.stage)/bin:$${PATH}"; \
		 export LD_LIBRARY_PATH="$(call cross,$(1))/lib:$${LD_LIBRARY_PATH}"

# Creates a package.json file for PlatformIO
# Package version **must** conform with Semantic Versioning specicfication:
# - https://github.com/platformio/platformio-core/issues/3612
# - https://semver.org/
makepackagejson = ( echo '{' && \
                    echo '   "description": "'$${pkgdesc}'",' && \
                    echo '   "name": "'$${pkgname}'",' && \
                    echo '   "system": [ "'$(call asys,$(1))'" ],' && \
                    echo '   "url": "https://github.com/'$(GHUSER)'/esp-quick-toolchain",' && \
                    echo '   "version": "5.'$(GCC_PKGREL)'.'$(STAMP)'"' && \
                    echo '}' ) > package.json

# Generates a JSON fragment for an uploaded release artifact
makejson = tarballsize=$$(stat -c%s $${tarball}); \
	   tarballsha256=$$(sha256sum $${tarball} | cut -f1 -d" "); \
	   ( echo '{' && \
	     echo ' "host": "'$(call ahost,$(1))'",' && \
	     echo ' "url": "https://github.com/$(GHUSER)/esp-quick-toolchain/releases/download/'$(REL)-$(SUBREL)'/'$${tarball}'",' && \
	     echo ' "archiveFileName": "'$${tarball}'",' && \
	     echo ' "checksum": "SHA-256:'$${tarballsha256}'",' && \
	     echo ' "size": "'$${tarballsize}'"' && \
	     echo '}') > $${tarball}.json

# The recpies begin here.

linux default: .stage.LINUX.done

.PRECIOUS: .stage.% .stage.%.% .stage.%.deps .stage.%.gdb-deps

.PHONY: .stage.gits .stage.blobs

# Build all toolchain versions
all: .stage.LINUX.done .stage.LINUX32.done .stage.WIN32.done .stage.WIN64.done .stage.MACOSX86.done .stage.MACOSARM.done .stage.ARM64.done .stage.RPI.done
	echo STAGE: $@
	echo All complete


download: .stage.gits .stage.blobs

# Other cross-compile cannot start until Linux is built
.stage.LINUX32.gcc1-make .stage.WIN32.gcc1-make .stage.WIN64.gcc1-make .stage.MACOSX86.gcc1-make .stage.MACOSARM.gcc1-make .stage.ARM64.gcc1-make .stage.RPI.gcc1-make: .stage.LINUX.done


# Clean all temporary outputs
clean: .cleaninst.LINUX.clean .cleaninst.LINUX32.clean .cleaninst.WIN32.clean .cleaninst.WIN64.clean .cleaninst.MACOSX86.clean .cleaninst.MACOSARM.clean .cleaninst.ARM64.clean .cleaninst.RPI.clean
	echo STAGE: $@
	rm -rf .stage* *.json *.tar.gz *.zip venv $(ARDUINO) pkg.* log.* > /dev/null 2>&1

# Clean an individual architecture and arena dir
.cleaninst.%.clean:
	echo STAGE: $@
	rm -rf $(call install,$@) > /dev/null 2>&1
	rm -rf $(call arena,$@) > /dev/null 2>&1

# Download the needed GIT and tarballs
.stage.gitclone:
	echo STAGE: $@
	mkdir -p $(REPODIR) > $(call log,$@) 2>&1
	(test -d $(REPODIR)/$(BINUTILS_DIR) || git clone $(BINUTILS_REPO)                               $(REPODIR)/$(BINUTILS_DIR) ) >> $(call log,$@) 2>&1
	(test -d $(REPODIR)/$(GCC_DIR)      || git clone $(GCC_REPO)                                    $(REPODIR)/$(GCC_DIR) ) >> $(call log,$@) 2>&1
	(test -d $(REPODIR)/newlib          || git clone https://github.com/$(GHUSER)/newlib-xtensa.git $(REPODIR)/newlib      ) >> $(call log,$@) 2>&1
	(test -d $(REPODIR)/lx106-hal       || git clone https://github.com/$(GHUSER)/lx106-hal.git     $(REPODIR)/lx106-hal   ) >> $(call log,$@) 2>&1
	(test -d $(REPODIR)/mkspiffs        || git clone https://github.com/$(GHUSER)/mkspiffs.git      $(REPODIR)/mkspiffs    ) >> $(call log,$@) 2>&1
	(test -d $(REPODIR)/mklittlefs      || git clone https://github.com/$(GHUSER)/mklittlefs.git    $(REPODIR)/mklittlefs  ) >> $(call log,$@) 2>&1
	(test -d $(REPODIR)/esptool         || git clone https://github.com/$(GHUSER)/esptool-ck.git    $(REPODIR)/esptool     ) >> $(call log,$@) 2>&1
	touch $@

# Completely clean out a git directory, removing any untracked files
.clean.%.git:
	echo STAGE: $@
	cd $(REPODIR)/$(call arch,$@) && git reset --hard HEAD && git clean -f -d

.clean.%.deps:
	echo STAGE: $@
	rm -rf $(call arena,$@)/cross

.clean.gits: .clean.$(BINUTILS_DIR).git .clean.$(GCC_DIR).git .clean.newlib.git .clean.newlib.git .clean.lx106-hal.git .clean.mkspiffs.git .clean.esptool.git .clean.mklittlefs.git

# Prep externally fetched urls & local archives
.stage.blobs:
	echo STAGE: $@
	for url in $(URLS) ; do \
	    archive=$${url##*/}; name=$${archive%.t*}; base=$${name%-*}; ext=$${archive##*.} ; \
	    echo "-------- getting $${url}" ; \
	    cd $(REPODIR) && ( test -r $${archive} || wget -o ${{archive}} $${url} ) ; \
	    case "$${ext}" in \
	        bz2) (cd $(REPODIR); tar -x --bzip2 -f $${archive};);; \
	        gz)  (cd $(REPODIR); tar -x --gzip -f $${archive};);; \
	        lz)  (cd $(REPODIR); tar -x --lzip -f $${archive};);; \
	        xz)  (cd $(REPODIR); tar -x --lzma -f $${archive};);; \
	        zip) (cd $(REPODIR); unzip -u $${archive};);; \
	    esac ; \
	done >> $(call log,$@) 2>&1
	(cd $(REPODIR)/$(GCC_DIR); \
		echo "-------- unpacking $(LIBELF_BLOB)" ; \
		tar xfz $(LIBELF_BLOB); \
		rm -rf libelf; \
		ln -s libelf-$(LIBELF_VER) libelf) >> $(call log,$@) 2>&1
	touch $@

# Prep the git repos with no patches and any required libraries for gcc & binutils-gdb
.stage.prepgit: .stage.gits .clean.gits .stage.blobs
	echo STAGE: $@
	for i in binutils-gdb gcc newlib lx106-hal mkspiffs mklittlefs esptool; do \
		cd $(REPODIR)/$$i \
		&& git reset --hard HEAD \
		&& git submodule init \
		&& git submodule update \
		&& git clean -f -d ; \
	done > $(call log,$@) 2>&1
	touch $@

# Checkout any required branches
.stage.checkout: .stage.prepgit
	echo STAGE: $@
	(cd $(REPODIR)/$(GCC_DIR) && git reset --hard && git checkout $(GCC_BRANCH)) > $(call log,$@) 2>&1
	(cd $(REPODIR)/$(BINUTILS_DIR) && git reset --hard && git checkout $(BINUTILS_BRANCH)) > $(call log,$@) 2>&1
	(cd $(REPODIR)/mkspiffs && git reset --hard && git submodule deinit --all && git clean -f -d && git checkout $(MKSPIFFS_BRANCH) && git submodule init && git submodule update) >> $(call log,$@) 2>&1
	touch $@

# Apply our patches
.stage.patch: .stage.checkout
	echo STAGE: $@
	for p in $(PATCHDIR)/gcc-*.patch $(PATCHDIR)/gcc$(GCC)/gcc-*.patch; do \
	    test -r "$$p" || continue ; \
	    (cd $(REPODIR)/$(GCC_DIR); echo "---- $$p:"; patch -s -p1 < $$p) ; \
	done > $(call log,$@) 2>&1
	for p in $(PATCHDIR)/bin-*.patch $(PATCHDIR)/gcc$(GCC)/bin-*.patch; do \
	    test -r "$$p" || continue ; \
	    (cd $(REPODIR)/$(BINUTILS_DIR); echo "---- $$p:"; patch -s -p1 < $$p) ; \
	done >> $(call log,$@) 2>&1
	for p in $(PATCHDIR)/lib-*.patch $(PATCHDIR)/gcc$(GCC)/lib-*.patch; do \
	    test -r "$$p" || continue ; \
	    (cd $(REPODIR)/newlib; echo "---- $$p: "; patch -s -p1 < $$p) ; \
	done >> $(call log,$@) 2>&1
	for p in $(PATCHDIR)/mkspiffs/$(MKSPIFFS_BRANCH)*.patch; do \
	    test -r "$$p" || continue ; \
	    (cd $(REPODIR)/mkspiffs; echo "---- $$p: "; patch -s -p1 < $$p) ; \
	done >> $(call log,$@) 2>&1
	# Dirty-force HAL definition to binutils and gcc
	for ow in $(REPODIR)/$(GCC_DIR)/include/xtensa-config.h $(REPODIR)/$(BINUTILS_DIR)/include/xtensa-config.h; do \
	    ( cat $(REPODIR)/lx106-hal/include/xtensa/config/core-isa.h; \
	      cat $(REPODIR)/lx106-hal/include/xtensa/config/system.h ; \
	      echo '#define XCHAL_HAVE_MMU      0' ; \
              echo '#define XCHAL_HAVE_FP_DIV   0' ; \
              echo '#define XCHAL_HAVE_FP_RECIP 0' ; \
              echo '#define XCHAL_HAVE_FP_SQRT  0' ; \
              echo '#define XCHAL_HAVE_FP_RSQRT 0' ) > $${ow} ; \
        done >> $(call log,$@) 2>&1
	cd $(REPODIR)/lx106-hal && autoreconf -i >> $(call log,$@) 2>&1
	./libstd_flash_string_decls.py --root $(REPODIR)/$(GCC_DIR)/libstdc++-v3/include >> $(call log,$@) 2>&1
	touch $@

.stage.%.start: .stage.patch .clean.%.deps
	echo STAGE: $@
	mkdir -p $(call arena,$@) > $(call log,$@) 2>&1

# Shared dependency for binutils and gcc
.stage.%.gmp: .stage.%.start
	echo STAGE: $@
	(cd $(call arena,$@); \
        rm -rf gmp-$(GMP_VER) mpfr-$(MPFR_VER)) > $(call log,$@) 2>&1
	(cd $(call arena,$@); \
		mkdir gmp-$(GMP_VER) mpfr-$(MPFR_VER)) >> $(call log,$@) 2>&1
	(cd $(call arena,$@)/gmp-$(GMP_VER); $(call setenv,$@); \
		$(REPODIR)/gmp-$(GMP_VER)/configure $(CONFIGURE_GMP) $(call configure,$@) --target=$(call host,$@) --prefix=$(call arena,$@)/cross \
			&& $(MAKE) \
			&& $(MAKE) install) >> $(call log,$@) 2>&1
	(cd $(call arena,$@)/mpfr-$(MPFR_VER); $(call setenv,$@); \
		$(REPODIR)/mpfr-$(MPFR_VER)/configure $(call configure,$@) $(call configure_gmp_mpfr,$@) --target=$(call host,$@) --prefix=$(call arena,$@)/cross \
			&& $(MAKE) \
			&& $(MAKE) install) >> $(call log,$@) 2>&1
	touch $@

# ./configure cannot comprehend cross-toolchain output
.stage.MACOSARM.gmp .stage.MACOSX86.gmp: CONFIGURE_GMP=--disable-assembly

# GDB static build has to have up-to-date libs
.stage.%.libexpat: .stage.%.start
	echo STAGE: $@
	rm -rf $(call arena,$@)/libexpat > $(call log,$@) 2>&1
	mkdir $(call arena,$@)/libexpat >> $(call log,$@) 2>&1
	(cd $(call arena,$@)/libexpat; \
		cp -r $(REPODIR)/expat-$(LIBEXPAT_VER)/* ./ ; \
		bash buildconf.sh ;\
		./configure $(call configure,$@) $(configure_expat) --prefix=$(call arena,$@)/cross ; \
		$(MAKE) && $(MAKE) install) >> $(call log,$@) 2>&1
	touch $@

# But only linux has to have ncurses.
# Note libtermcap.a <-> libtinfo.a has to happen b/c gdb later links with the system one
.stage.%.ncurses: .stage.%.start
	echo STAGE: $@
	touch $@

.stage.LINUX.ncurses: .stage.LINUX.start
	echo STAGE: $@
	rm -rf $(call arena,$@)/ncurses > $(call log,$@) 2>&1
	mkdir $(call arena,$@)/ncurses >> $(call log,$@) 2>&1
	(cd $(call arena,$@)/ncurses ; \
		$(REPODIR)/ncurses-snapshots-$(NCURSES_VER)/configure $(call configure,$@) $(configure_ncurses) --prefix=$(call arena,$@)/cross ; \
		$(MAKE) && $(MAKE) install) >> $(call log,$@) 2>&1
	(cd $(call cross,$@)/lib ; \
		ln -s libtinfo.a libtermcap.a) >> $(call log,$@) 2>&1
	touch $@

.stage.%.gdb-deps: .stage.%.ncurses .stage.%.libexpat
	echo STAGE: $@
	touch $@

.stage.%.deps: .stage.%.gmp .stage.%.gdb-deps
	echo STAGE: $@
	touch $@

.NOTPARALLEL: .stage.%.ncurses .stage.%.libexpat .stage.%.gmp

# Build binutils & gdb
.stage.%.binutils-config: .stage.%.deps
	echo STAGE: $@
	rm -rf $(call arena,$@)/$(BINUTILS_DIR) > $(call log,$@) 2>&1
	mkdir -p $(call arena,$@)/$(BINUTILS_DIR) >> $(call log,$@) 2>&1
	(cd $(call arena,$@)/$(BINUTILS_DIR); \
		$(call setenv,$@); \
		$(REPODIR)/$(BINUTILS_DIR)/configure --disable-sim $(call configure_gmp_mpfr,$@) $(call configure,$@)) >> $(call log,$@) 2>&1
	touch $@

.stage.%.binutils-make: .stage.%.binutils-config
	echo STAGE: $@
	(cd $(call arena,$@)/$(BINUTILS_DIR); \
		$(call setenv,$@); \
		$(MAKE) LDFLAGS="$(BINUTILS_MAKE_LDFLAGS) $$LDFLAGS" \
		&& $(MAKE) install) > $(call log,$@) 2>&1
	(cd $(call install,$@)/bin; \
		ln -sf xtensa-lx106-elf-gcc$(call exe,$@) xtensa-lx106-elf-cc$(call exe,$@)) >> $(call log,$@) 2>&1
	touch $@

# statically link w/ the expat & ncurses & gmp & mpfr that were built locally
# (nb. original code shadowed 'export LDFLAGS=...' via 'make LDFLAGS=...')
.stage.%.binutils-make: BINUTILS_MAKE_LDFLAGS=-static
.stage.MACOSARM.binutils-make .stage.MACOSX86.binutils-make: BINUTILS_MAKE_LDFLAGS = 

# statically link w/ build host stdlib .dlls
.stage.WIN32.binutils-make: BINUTILS_MAKE_LDFLAGS=-static -static-libgcc -static-libstdc++
.stage.WIN64.binutils-make: BINUTILS_MAKE_LDFLAGS=-static -static-libgcc -static-libstdc++

.stage.%.gcc1-config: .stage.%.binutils-make
	echo STAGE: $@
	rm -rf $(call arena,$@)/$(GCC_DIR) > $(call log,$@) 2>&1
	mkdir -p $(call arena,$@)/$(GCC_DIR) >> $(call log,$@) 2>&1
	(cd $(call arena,$@)/$(GCC_DIR); \
		$(call setenv,$@); \
		$(REPODIR)/$(GCC_DIR)/configure $(call configure_gmp_mpfr,$@) $(call configure,$@)) >> $(call log,$@) 2>&1
	touch $@

.stage.%.gcc1-make: .stage.%.gcc1-config
	echo STAGE: $@
	(cd $(call arena,$@)/$(GCC_DIR); $(call setenv,$@); $(MAKE) all-gcc; $(MAKE) install-gcc) > $(call log,$@) 2>&1
	touch $@

.stage.%.newlib-config: .stage.%.gcc1-make
	echo STAGE: $@
	rm -rf $(call arena,$@)/newlib > $(call log,$@) 2>&1
	mkdir -p $(call arena,$@)/newlib >> $(call log,$@) 2>&1
	(cd $(call arena,$@)/newlib; $(call setenv,$@); $(REPODIR)/newlib/configure $(call configurenewlib,$@)) >> $(call log,$@) 2>&1
	touch $@

.stage.%.newlib-make: .stage.%.newlib-config
	echo STAGE: $@
	(cd $(call arena,$@)/newlib; $(call setenv,$@); $(MAKE)) > $(call log,$@) 2>&1
	(cd $(call arena,$@)/newlib; $(call setenv,$@); $(MAKE) install) >> $(call log,$@) 2>&1
	touch $@

.stage.%.libstdcpp: .stage.%.newlib-make
	echo STAGE: $@
	# stage 2 (build libstdc++)
	(cd $(call arena,$@)/$(GCC_DIR); $(call setenv,$@); $(MAKE)) > $(call log,$@) 2>&1
	(cd $(call arena,$@)/$(GCC_DIR); $(call setenv,$@); $(MAKE) install) >> $(call log,$@) 2>&1
	touch $@

.stage.%.libstdcpp-nox: .stage.%.libstdcpp
	echo STAGE: $@
	# We copy existing stdc, adjust the makefile, and build a single .a to save much time
	rm -rf $(call arena,$@)/$(GCC_DIR)/xtensa-lx106-elf/libstdc++-v3-nox > $(call log,$@) 2>&1
	cp -a $(call arena,$@)/$(GCC_DIR)/xtensa-lx106-elf/libstdc++-v3 $(call arena,$@)/$(GCC_DIR)/xtensa-lx106-elf/libstdc++-v3-nox >> $(call log,$@) 2>&1
	(cd $(call arena,$@)/$(GCC_DIR)/xtensa-lx106-elf/libstdc++-v3-nox; $(call setenv,$@); $(MAKE) clean; find . -name Makefile -exec sed -i 's/mlongcalls/mlongcalls -fno-exceptions/' \{\} \; ; $(MAKE)) >> $(call log,$@) 2>&1
	cp xtensa-lx106-elf$(call ext,$@)/xtensa-lx106-elf/lib/libstdc++.a xtensa-lx106-elf$(call ext,$@)/xtensa-lx106-elf/lib/libstdc++-exc.a >> $(call log,$@) 2>&1
	cp $(call arena,$@)/$(GCC_DIR)/xtensa-lx106-elf/libstdc++-v3-nox/src/.libs/libstdc++.a xtensa-lx106-elf$(call ext,$@)/xtensa-lx106-elf/lib/libstdc++.a >> $(call log,$@) 2>&1
	touch $@

.stage.%.hal-config: .stage.%.libstdcpp-nox
	echo STAGE: $@
	rm -rf $(call arena,$@)/hal > $(call log,$@) 2>&1
	mkdir -p $(call arena,$@)/hal >> $(call log,$@) 2>&1
	(cd $(call arena,$@)/hal; \
		$(call setenv,$@); \
		$(REPODIR)/lx106-hal/configure $(call configure,$@) --host=$(TARGET_ARCH) CC=$(TARGET_ARCH)-cc) >> $(call log,$@) 2>&1
	touch $@

.stage.%.hal-make: .stage.%.hal-config
	echo STAGE: $@
	(cd $(call arena,$@)/hal; \
		$(call setenv,$@); \
		$(MAKE) && $(MAKE) install) > $(call log,$@) 2>&1
	touch $@

.stage.%.strip: .stage.%.hal-make
	echo STAGE: $@
	($(call setenv,$@); \
		$(call host,$@)-strip \
		$(call install,$@)/bin/*$(call exe,$@) \
		$(call install,$@)/libexec/gcc/xtensa-lx106-elf/*/c*$(call exe,$@) \
		$(call install,$@)/libexec/gcc/xtensa-lx106-elf/*/lto1$(call exe,$@) || true ) > $(call log,$@) 2>&1
	touch $@

# > aarch64-apple-darwin20.4-strip: warning: changes being made to the file will invalidate the code signature in ...
.stage.MACOSARM.strip: .stage.MACOSARM.hal-make
	echo STAGE: $@
	touch $@

.stage.%.post: .stage.%.strip
	echo STAGE: $@
	for sh in post/$(GCC)*.sh; do \
	    [ -x "$${sh}" ] && $${sh} $(call ext,$@) ; \
	done > $(call log,$@) 2>&1
	touch $@

.stage.%.package: .stage.%.post
	echo STAGE: $@
	rm -rf pkg.$(call arch,$@) > $(call log,$@) 2>&1
	mkdir -p pkg.$(call arch,$@) >> $(call log,$@) 2>&1
	cp -a $(call install,$@) pkg.$(call arch,$@)/xtensa-lx106-elf >> $(call log,$@) 2>&1
	(cd pkg.$(call arch,$@)/xtensa-lx106-elf; $(call setenv,$@); pkgdesc="xtensa-gcc"; pkgname="toolchain-xtensa"; $(call makepackagejson,$@)) >> $(call log,$@) 2>&1
	(tarball=$(call host,$@).xtensa-lx106-elf-$$(git rev-parse --short HEAD).$(STAMP).$(call tarext,$@) ; \
	    cd pkg.$(call arch,$@) && $(call tarcmd,$@) $(call taropt,$@) ../$${tarball} xtensa-lx106-elf/ ; cd ..; $(call makejson,$@)) >> $(call log,$@) 2>&1
	rm -rf pkg.$(call arch,$@) >> $(call log,$@) 2>&1
	touch $@

.stage.%.mkspiffs: .stage.%.start
	echo STAGE: $@
	rm -rf $(call arena,$@)/mkspiffs > $(call log,$@) 2>&1
	cp -a $(REPODIR)/mkspiffs $(call arena,$@)/mkspiffs >> $(call log,$@) 2>&1
	# Dependencies borked in mkspiffs makefile, so don't use parallel make
	(cd $(call arena,$@)/mkspiffs;\
	    $(call setenv,$@); \
	    $(MAKE) -j1 TARGET_OS=$(call mktgt,$@) \
			CC=$(call host,$@)-cc CXX=$(call host,$@)-c++ STRIP=$(STRIP) \
			BUILD_CONFIG_NAME="-arduino-esp8266" \
			CPPFLAGS="-DSPIFFS_USE_MAGIC_LENGTH=0 -DSPIFFS_ALIGNED_OBJECT_INDEX_TABLES=1" \
            mkspiffs$(call exe,$@)) >> $(call log,$@) 2>&1
	rm -rf pkg.mkspiffs.$(call arch,$@) >> $(call log,$@) 2>&1
	mkdir -p pkg.mkspiffs.$(call arch,$@)/mkspiffs >> $(call log,$@) 2>&1
	(cd pkg.mkspiffs.$(call arch,$@)/mkspiffs; \
		$(call setenv,$@); pkgdesc="mkspiffs-utility"; pkgname="mkspiffs"; \
		$(call makepackagejson,$@)) >> $(call log,$@) 2>&1
	cp $(call arena,$@)/mkspiffs/mkspiffs$(call exe,$@) pkg.mkspiffs.$(call arch,$@)/mkspiffs/. >> $(call log,$@) 2>&1
	(tarball=$(call host,$@).mkspiffs-$$(cd $(REPODIR)/mkspiffs \
		&& git rev-parse --short HEAD).$(STAMP).$(call tarext,$@) ; \
	    cd pkg.mkspiffs.$(call arch,$@) && $(call tarcmd,$@) $(call taropt,$@) ../$${tarball} mkspiffs; \
		cd ..; $(call makejson,$@)) >> $(call log,$@) 2>&1
	rm -rf pkg.mkspiffs.$(call arch,$@) >> $(call log,$@) 2>&1
	touch $@

.stage.%.mkspiffs: STRIP=$(call host,$@)-strip
.stage.MACOSARM.mkspiffs: STRIP=touch

.stage.%.mklittlefs: .stage.%.start
	echo STAGE: $@
	rm -rf $(call arena,$@)/mklittlefs > $(call log,$@) 2>&1
	cp -a $(REPODIR)/mklittlefs $(call arena,$@)/mklittlefs >> $(call log,$@) 2>&1
	# Dependencies borked in mklittlefs makefile, so don't use parallel make
	(cd $(call arena,$@)/mklittlefs;\
	    $(call setenv,$@); \
	    $(MAKE) -j1 TARGET_OS=$(call mktgt,$@) \
			CC=$(call host,$@)-cc CXX=$(call host,$@)-c++ STRIP=$(STRIP) \
			BUILD_CONFIG_NAME="-arduino-esp8266" \
            mklittlefs$(call exe,$@)) >> $(call log,$@) 2>&1
	rm -rf pkg.mklittlefs.$(call arch,$@) >> $(call log,$@) 2>&1
	mkdir -p pkg.mklittlefs.$(call arch,$@)/mklittlefs >> $(call log,$@) 2>&1
	(cd pkg.mklittlefs.$(call arch,$@)/mklittlefs; \
		$(call setenv,$@); pkgdesc="littlefs-utility"; pkgname="mklittlefs"; \
		$(call makepackagejson,$@)) >> $(call log,$@) 2>&1
	cp $(call arena,$@)/mklittlefs/mklittlefs$(call exe,$@) pkg.mklittlefs.$(call arch,$@)/mklittlefs/. >> $(call log,$@) 2>&1
	(tarball=$(call host,$@).mklittlefs-$$(cd $(REPODIR)/mklittlefs \
		&& git rev-parse --short HEAD).$(STAMP).$(call tarext,$@) ; \
	    cd pkg.mklittlefs.$(call arch,$@) && $(call tarcmd,$@) $(call taropt,$@) ../$${tarball} mklittlefs; \
		cd ..; $(call makejson,$@)) >> $(call log,$@) 2>&1
	rm -rf pkg.mklittlefs.$(call arch,$@) >> $(call log,$@) 2>&1
	touch $@

.stage.%.mklittlefs: STRIP=$(call host,$@)-strip
.stage.MACOSARM.mklittlefs: STRIP=touch

.stage.%.esptool: .stage.%.start
	echo STAGE: $@
	rm -rf $(call arena,$@)/esptool > $(call log,$@) 2>&1
	cp -a $(REPODIR)/esptool $(call arena,$@)/esptool >> $(call log,$@) 2>&1
	# Dependencies borked in esptool makefile, so don't use parallel make
	(cd $(call arena,$@)/esptool;\
	    $(call setenv,$@); \
	    $(MAKE) -j1 TARGET_OS=$(call mktgt,$@) \
			CC=$(call host,$@)-cc CXX=$(call host,$@)-c++ STRIP=$(STRIP) \
			BUILD_CONFIG_NAME="-arduino-esp8266" \
            esptool$(call exe,$@)) >> $(call log,$@) 2>&1
	rm -rf pkg.esptool.$(call arch,$@) >> $(call log,$@) 2>&1
	mkdir -p pkg.esptool.$(call arch,$@)/esptool >> $(call log,$@) 2>&1
	cp $(call arena,$@)/esptool/esptool$(call exe,$@) pkg.esptool.$(call arch,$@)/esptool/. >> $(call log,$@) 2>&1
	(tarball=$(call host,$@).esptool-$$(cd $(REPODIR)/esptool \
		&& git rev-parse --short HEAD).$(STAMP).$(call tarext,$@) ; \
	    cd pkg.esptool.$(call arch,$@) && $(call tarcmd,$@) $(call taropt,$@) ../$${tarball} esptool; \
		cd ..; $(call makejson,$@)) >> $(call log,$@) 2>&1
	rm -rf pkg.esptool.$(call arch,$@) >> $(call log,$@) 2>&1
	touch $@

.stage.%.esptool: STRIP=$(call host,$@)-strip
.stage.MACOSARM.esptool: STRIP=touch

.stage.%.done: .stage.%.package .stage.%.mkspiffs .stage.%.esptool .stage.%.mklittlefs
	echo STAGE: $@
	echo Done building $(call arch,$@)
	touch $@

# Only the native version has to be done to install libs to GIT
install: .stage.LINUX.install
.stage.LINUX.install:
	echo STAGE: $@
	rm -rf $(ARDUINO)
	git clone https://github.com/$(GHUSER)/Arduino $(ARDUINO)
	(cd $(ARDUINO) && git checkout $(INSTALLBRANCH) && git submodule init && git submodule update)
	echo "-------- Building installable hal"
	rm -rf arena/hal-install; mkdir -p arena/hal-install
	cd arena/hal-install; $(call setenv,$@); $(REPODIR)/lx106-hal/configure --prefix=$(ARDUINO)/tools/sdk/libc --libdir=$(ARDUINO)/tools/sdk/lib --host=xtensa-lx106-elf $$(echo $(call configure,$@) | sed 's/--host=.*\s//' | sed 's/--prefix=.*\s//' | sed 's/--disable-libstdcxx-verbose//' )
	cd arena/hal-install; $(call setenv,$@); $(MAKE) ; $(MAKE) install
	echo "-------- Copying GCC libs"
	#cp $(call install,$@)/lib/gcc/xtensa-lx106-elf/*/libgcc.a  $(ARDUINO)/tools/sdk/lib/.
	cp $(call install,$@)/xtensa-lx106-elf/lib/libstdc++-exc.a $(ARDUINO)/tools/sdk/lib/.
	cp $(call install,$@)/xtensa-lx106-elf/lib/libstdc++.a     $(ARDUINO)/tools/sdk/lib/.
	echo "-------- Copying toolchain directory"
	rm -rf $(ARDUINO)/tools/sdk/xtensa-lx106-elf
	cp -a $(call install,$@)/xtensa-lx106-elf $(ARDUINO)/tools/sdk/xtensa-lx106-elf
	echo "-------- Updating package.json"
	ver=$(REL)-$(SUBREL)-$(shell git rev-parse --short HEAD); pkgfile=$(ARDUINO)/package/package_esp8266com_index.template.json; \
	./patch_json.py --pkgfile "$${pkgfile}" --tool xtensa-lx106-elf-gcc --ver "$${ver}" --glob '*xtensa-lx106-elf*.json' ; \
	./patch_json.py --pkgfile "$${pkgfile}" --tool esptool --ver "$${ver}" --glob '*esptool*json' ; \
	./patch_json.py --pkgfile "$${pkgfile}" --tool mkspiffs --ver "$${ver}" --glob '*mkspiffs*json'; \
	./patch_json.py --pkgfile "$${pkgfile}" --tool mklittlefs --ver "$${ver}" --glob '*mklittlefs*json'
	echo "-------- Installing toolchain"
	(cd $(ARDUINO)/tools && tar xf ../../x86_64-linux-gnu.xtensa-lx106-elf-*.tar.gz )
	echo "-------- Building and installing BearSSL"
	(cd $(ARDUINO)/tools/sdk/ssl && make clean && make all && make install)
	echo "-------- Building and installing LWIP2"
	(cd $(ARDUINO)/tools/sdk/lwip2 && make clean && make install)
	echo "-------- Building eboot.elf"
	(cd $(ARDUINO)/bootloaders/eboot && make clean && make)
	echo "Install done"

# Upload a draft toolchain release
upload: .stage.LINUX.upload
.stage.LINUX.upload:
	echo STAGE: $@
	cp -f blobs/* .
	rm -rf ./venv
	python3 -m venv ./venv
	cd ./venv; . bin/activate; \
	    pip3 install -q pygithub ; \
	    python3 ../upload_release.py --user "$(GHUSER)" --token "$(GHTOKEN)" --tag $(REL)-$(SUBREL) --msg 'See https://github.com/esp8266/Arduino for more info'  --name "ESP8266 Quick Toolchain for $(REL)-$(SUBREL)" `find ../ -maxdepth 1 -name "*.tar.gz" -o -name "*.zip"` ;
	rm -rf ./venv

dumpvars:
	echo SETENV:    '$(call setenv,.stage.LINUX.stage)'
	echo CONFIGURE: '$(call configure,.stage.LINUX.stage)'
	echo NEWLIBCFG: '$(call configurenewlib,.stage.LINUX.stage)'
