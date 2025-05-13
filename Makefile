
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
REV      := $(shell git rev-parse --short HEAD)

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

NEWLIB_BRANCH := gcc14/string-h
LX106_HAL_BRANCH := e4bcc63c9c016e4f8848e7e8f512438ca857531d

# MKSPIFFS must stay at 0.2.0 until Arduino boards.txt.py fixes non-page-aligned sizes
MKSPIFFS_BRANCH := 0.2.0

# MKLITTLEFS must be in sync with the Arduino littlefs version
# 4.x.x pins littlefs==2.9.3, which cannot be read by littlefs<2.6.0
MKLITTLEFS_BRANCH := 4.0.2-littlefs251

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

# 1. --disable-lto , per immediately broken mpfr & lto-plugin builds
#    also disabled in pico toolchain, which uses the same osxcross dist
# 2. macOS cross tools have to be explicitly stated when configuring build env
#    host & target arch autodetection does not work for some reason and uses local gcc instead
MACOSX86_CONFIGURE_VARS := \
	--disable-lto \
	CC=$(MACOSX86_HOST)-cc \
	CXX=$(MACOSX86_HOST)-c++

MACOSARM_HOST   := aarch64-apple-darwin20.4
MACOSARM_AHOST  := arm64-apple-darwin
MACOSARM_EXT    := .macosarm
MACOSARM_EXE    :=
MACOSARM_MKTGT  := macosarm
MACOSARM_TARCMD := tar
MACOSARM_TAROPT := zcf
MACOSARM_TAREXT := tar.gz
MACOSARM_ASYS   := darwin_arm64

# 3. strip cannot happen
# > aarch64-apple-darwin20.4-strip: warning: changes being made to the file will invalidate the code signature in ...
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

# For package.json and arduino build
asys    = $($(call arch,$(1))_ASYS)
tarball = $(call host,$(1)).$(TARGET_ARCH)-$(REV).$(STAMP).$(call tarext,$(1))

# sometimes called for ./configure
configure_vars = $($(call arch,$(1))_CONFIGURE_VARS)

# The build directory per architecture
arena = $(PWD)/arena$(call ext,$(1))
# The architecture for this recipe
arch = $(subst .,,$(suffix $(basename $(1))))
# This installation directory for this architecture
install = $(PWD)/$(TARGET_ARCH)$($(call arch,$(1))_EXT)
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

CONFIGURE_NCURSES := \
	--disable-widec \
	--without-manpages \
	--without-progs \
	--without-shared \
	--without-tack \
	--without-tests \
	--with-termlib \
	--with-versioned-syms

CONFIGURE_EXPAT := \
	--without-docbook \
	--without-xmlwf \
	--without-examples \
	--without-tests

configure_binutils = \
	--disable-sim \
	$(call configure_gmp_mpfr,$(1)) \
	$(call configure,$(1))

# Newlib configuration common
CONFIGURE_NEWLIB := --with-newlib
CONFIGURE_NEWLIB += --enable-multilib
CONFIGURE_NEWLIB += --disable-newlib-io-c99-formats
CONFIGURE_NEWLIB += --disable-newlib-supplied-syscalls
CONFIGURE_NEWLIB += --enable-newlib-nano-formatted-io
CONFIGURE_NEWLIB += --enable-newlib-reent-small
CONFIGURE_NEWLIB += --enable-target-optspace
CONFIGURE_NEWLIB += --disable-option-checking
CONFIGURE_NEWLIB += --target=$(TARGET_ARCH)
CONFIGURE_NEWLIB += --disable-shared

# Configuration for newlib normal build
configure_newlib  = --prefix=$(call install,$(1))
configure_newlib += $(CONFIGURE_NEWLIB)

# For macOS targets, GMP tries to test .s on ./configure stage
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

# The recipes begin here.

linux default: .stage.LINUX.done

.PRECIOUS: .stage.% .stage.%.%

.PHONY: .clean.% .clean.%.%

.PHONY: .stage.patch .stage.gitclone .stage.blobs .stage.checkout

.PHONY: .stage.%.start

# Build all toolchain versions
all: .stage.LINUX.done .stage.LINUX32.done .stage.WIN32.done .stage.WIN64.done .stage.MACOSX86.done .stage.MACOSARM.done .stage.ARM64.done .stage.RPI.done
	echo STAGE: $@
	echo All complete

$(REPODIR):
	mkdir -p $@

download: .stage.gitclone .stage.blobs

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
.stage.gitclone: .clean.gitclone | $(REPODIR)
	echo STAGE: $@
	(test -d $(REPODIR)/$(BINUTILS_DIR) || git clone $(BINUTILS_REPO)                               $(REPODIR)/$(BINUTILS_DIR) ) > $(call log,$@) 2>&1
	(test -d $(REPODIR)/$(GCC_DIR)      || git clone $(GCC_REPO)                                    $(REPODIR)/$(GCC_DIR) ) >> $(call log,$@) 2>&1
	(test -d $(REPODIR)/newlib          || git clone https://github.com/$(GHUSER)/newlib-xtensa.git $(REPODIR)/newlib      ) >> $(call log,$@) 2>&1
	(test -d $(REPODIR)/lx106-hal       || git clone https://github.com/$(GHUSER)/lx106-hal.git     $(REPODIR)/lx106-hal   ) >> $(call log,$@) 2>&1
	(test -d $(REPODIR)/mkspiffs        || git clone https://github.com/$(GHUSER)/mkspiffs.git      $(REPODIR)/mkspiffs    ) >> $(call log,$@) 2>&1
	(test -d $(REPODIR)/mklittlefs      || git clone https://github.com/$(GHUSER)/mklittlefs.git    $(REPODIR)/mklittlefs  ) >> $(call log,$@) 2>&1
	(test -d $(REPODIR)/esptool         || git clone https://github.com/$(GHUSER)/esptool-ck.git    $(REPODIR)/esptool     ) >> $(call log,$@) 2>&1

# Completely clean out a git directory, removing any untracked files
.clean.%.git: | $(REPODIR)
	(test -d $(REPODIR)/$(call arch,$@) \
		&& cd $(REPODIR)/$(call arch,$@) \
		&& git reset --hard \
		&& git clean -f -d) \
	&& echo "CLEAN: $@" \
	|| echo "SKIP: $@"

.clean.%.deps:
	echo STAGE: $@
	rm -rf $(call arena,$@)/cross

.clean.gitclone: .clean.$(BINUTILS_DIR).git .clean.$(GCC_DIR).git .clean.newlib.git .clean.lx106-hal.git .clean.mkspiffs.git .clean.mklittlefs.git .clean.esptool.git

# Checkout any required branches
.stage.checkout: .stage.gitclone | $(REPODIR)
	echo STAGE: $@
	(cd $(REPODIR)/$(BINUTILS_DIR) && git checkout $(BINUTILS_BRANCH)) > $(call log,$@) 2>&1
	(cd $(REPODIR)/$(GCC_DIR) && git checkout $(GCC_BRANCH)) >> $(call log,$@) 2>&1
	(cd $(REPODIR)/newlib && git checkout $(NEWLIB_BRANCH)) >> $(call log,$@) 2>&1
	(cd $(REPODIR)/lx106-hal && git checkout $(LX106_HAL_BRANCH)) >> $(call log,$@) 2>&1
	(cd $(REPODIR)/mkspiffs && git checkout $(MKSPIFFS_BRANCH)) >> $(call log,$@) 2>&1
	(cd $(REPODIR)/mklittlefs && git checkout $(MKLITTLEFS_BRANCH) && git submodule deinit --all && git submodule init && git submodule update) >> $(call log,$@) 2>&1

# Prep externally fetched urls & local archives
.stage.blobs: .stage.checkout | $(REPODIR)
	echo STAGE: $@
	(for url in $(URLS) ; do \
	    archive=$${url##*/}; name=$${archive%.t*}; base=$${name%-*}; ext=$${archive##*.} ; \
		test -r $(REPODIR)/$${archive} || wget -v -O $(REPODIR)/$${archive} $${url} ; \
		(cd $(REPODIR); \
			case "$${ext}" in \
				(bz2|gz|lz|xz) tar xf $${archive} ;; \
				(zip) unzip -qu $${archive} ;; \
				(*) echo "Unknown archive type $${ext}" ; exit 1 ;; \
			esac && echo "-------- unpacked $${archive}") ; \
	done) > $(call log,$@) 2>&1
	(cd $(REPODIR)/$(GCC_DIR); \
		tar xfz $(LIBELF_BLOB) \
		&& echo "-------- unpacked $(LIBELF_BLOB)" \
		&& rm -rf libelf \
		&& ln -s libelf-$(LIBELF_VER) libelf) >> $(call log,$@) 2>&1

# Apply our patches
.stage.patch: .stage.blobs .stage.checkout
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
	(set -x; cd $(REPODIR)/lx106-hal \
		&& patch -s -p1 src/Makefile.am $(PATCHDIR)/hal-mawk.patch \
		&& autoreconf -i) >> $(call log,$@) 2>&1
	(set -x; ./libstd_flash_string_decls.py \
		$(REPODIR)/$(GCC_DIR)/libstdc++-v3/include \
		$(REPODIR)/$(GCC_DIR)/libstdc++-v3/libsupc++ \
		$(REPODIR)/$(GCC_DIR)/libstdc++-v3/src/c++11 \
		$(REPODIR)/$(GCC_DIR)/libstdc++-v3/src/c++17) >> $(call log,$@) 2>&1

.stage.%.start: .clean.%.deps .stage.patch
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
		$(REPODIR)/gmp-$(GMP_VER)/configure $(GMP_CONFIGURE_FLAGS) $(call configure,$@) --target=$(call host,$@) --prefix=$(call arena,$@)/cross \
			&& $(MAKE) \
			&& $(MAKE) install) >> $(call log,$@) 2>&1
	(cd $(call arena,$@)/mpfr-$(MPFR_VER); $(call setenv,$@); \
		$(REPODIR)/mpfr-$(MPFR_VER)/configure $(call configure,$@) $(call configure_gmp_mpfr,$@) --target=$(call host,$@) --prefix=$(call arena,$@)/cross \
			&& $(MAKE) \
			&& $(MAKE) install) >> $(call log,$@) 2>&1
	touch $@

# ./configure cannot comprehend cross-toolchain output
.stage.MACOSARM.gmp .stage.MACOSX86.gmp: GMP_CONFIGURE_FLAGS=--disable-assembly

# GDB static build has to have up-to-date libs
.stage.%.libexpat: .stage.%.start
	echo STAGE: $@
	rm -rf $(call arena,$@)/libexpat > $(call log,$@) 2>&1
	mkdir $(call arena,$@)/libexpat >> $(call log,$@) 2>&1
	(cd $(call arena,$@)/libexpat; \
		cp -r $(REPODIR)/expat-$(LIBEXPAT_VER)/* ./ ; \
		bash buildconf.sh ;\
		./configure $(call configure,$@) $(CONFIGURE_EXPAT) --prefix=$(call arena,$@)/cross ; \
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
		$(REPODIR)/ncurses-snapshots-$(NCURSES_VER)/configure $(call configure,$@) $(CONFIGURE_NCURSES) --prefix=$(call arena,$@)/cross ; \
		$(MAKE) && $(MAKE) install) >> $(call log,$@) 2>&1
	(cd $(call cross,$@)/lib ; \
		ln -s libtinfo.a libtermcap.a) >> $(call log,$@) 2>&1
	(cd $(call cross,$@)/lib ; \
		ln -s libncurses.a libcurses.a) >> $(call log,$@) 2>&1
	touch $@

.NOTPARALLEL: .stage.%.gmp .stage.%.ncurses .stage.%.libexpat

# Build binutils & gdb
.stage.%.binutils-config: .stage.%.gmp .stage.%.ncurses .stage.%.libexpat
	echo STAGE: $@
	rm -rf $(call arena,$@)/$(BINUTILS_DIR) > $(call log,$@) 2>&1
	mkdir -p $(call arena,$@)/$(BINUTILS_DIR) >> $(call log,$@) 2>&1
	(cd $(call arena,$@)/$(BINUTILS_DIR); \
		$(call setenv,$@); \
		$(REPODIR)/$(BINUTILS_DIR)/configure $(call configure_binutils,$@)) >> $(call log,$@) 2>&1
	touch $@

.stage.%.binutils-make: .stage.%.binutils-config
	echo STAGE: $@
	(cd $(call arena,$@)/$(BINUTILS_DIR); \
		$(call setenv,$@); \
		$(MAKE) LDFLAGS="$(BINUTILS_MAKE_LDFLAGS) $$LDFLAGS" \
		&& $(MAKE) install) > $(call log,$@) 2>&1
	touch $@

.stage.%.binutils-make: BINUTILS_MAKE_LDFLAGS=

# statically link w/ build host standard libraries
# TODO: c1a5d03a89a455d79f025c66dce83342de4d26ce introduces --with-static-standard-libraries
.stage.WIN32.binutils-make: BINUTILS_MAKE_LDFLAGS=-static-libgcc -static-libstdc++
.stage.WIN64.binutils-make: BINUTILS_MAKE_LDFLAGS=-static-libgcc -static-libstdc++

# attempt to fix dynamic plugins loader
# https://github.com/msys2/MINGW-packages/issues/7890
# https://github.com/msys2/MINGW-packages/blob/68f7d4665c396a464536871b1de7b680a47a8fa7/mingw-w64-binutils/PKGBUILD#L150-L151
.stage.%.binutils-post: .stage.%.binutils-make
	echo STAGE: $@
	rm -rf $(call arena,$@)/$(BINUTILS_DIR)/ld > $(call log,$@) 2>&1
	mkdir -p $(call arena,$@)/$(BINUTILS_DIR)/ld >> $(call log,$@) 2>&1
	(cd $(call arena,$@)/$(BINUTILS_DIR)/ld; \
		$(call setenv,$@); \
		$(REPODIR)/$(BINUTILS_DIR)/ld/configure \
			$(call configure_binutils,$@) \
			--enable-static=no \
			--enable-shared \
		&& $(MAKE) \
		&& cp -v .libs/$(BINUTILS_PLUGINS) $(call install,$@)/lib/bfd-plugins/) >> $(call log,$@) 2>&1
	touch $@

.stage.%.binutils-post: BINUTILS_PLUGINS=libdep.so
.stage.WIN32.binutils-post .stage.WIN64.binutils-post: BINUTILS_PLUGINS=libdep.dll

.stage.%.gcc1-config: .stage.%.binutils-post
	echo STAGE: $@
	rm -rf $(call arena,$@)/$(GCC_DIR) > $(call log,$@) 2>&1
	mkdir -p $(call arena,$@)/$(GCC_DIR) >> $(call log,$@) 2>&1
	(cd $(call arena,$@)/$(GCC_DIR); \
		$(call setenv,$@); \
		$(REPODIR)/$(GCC_DIR)/configure $(call configure_gmp_mpfr,$@) $(call configure,$@)) >> $(call log,$@) 2>&1
	touch $@

.stage.%.gcc1-make: .stage.%.gcc1-config
	echo STAGE: $@
	(cd $(call arena,$@)/$(GCC_DIR) && $(call setenv,$@) && $(MAKE) all-gcc && $(MAKE) install-gcc) > $(call log,$@) 2>&1
	(cd $(call install,$@)/bin; \
		ln -sf $(TARGET_ARCH)-gcc$(call exe,$@) $(TARGET_ARCH)-cc$(call exe,$@)) >> $(call log,$@) 2>&1
	touch $@

.stage.%.newlib-config: .stage.%.gcc1-make
	echo STAGE: $@
	rm -rf $(call arena,$@)/newlib > $(call log,$@) 2>&1
	mkdir -p $(call arena,$@)/newlib >> $(call log,$@) 2>&1
	(cd $(call arena,$@)/newlib; $(call setenv,$@); $(REPODIR)/newlib/configure $(call configure_newlib,$@)) >> $(call log,$@) 2>&1
	touch $@

.stage.%.newlib-make: .stage.%.newlib-config
	echo STAGE: $@
	(cd $(call arena,$@)/newlib; $(call setenv,$@); $(MAKE)) > $(call log,$@) 2>&1
	(cd $(call arena,$@)/newlib; $(call setenv,$@); $(MAKE) install) >> $(call log,$@) 2>&1
	touch $@

.stage.%.libstdcpp: .stage.%.newlib-make
	echo STAGE: $@
	# stage 2 (build libstdc++)
	(cd $(call arena,$@)/$(GCC_DIR); \
		$(call setenv,$@); \
		$(MAKE) && $(MAKE) install) > $(call log,$@) 2>&1
	touch $@

.stage.%.libstdcpp-nox: .stage.%.libstdcpp
	echo STAGE: $@
	# We copy existing stdc, adjust the makefile, and build a single .a to save much time
	rm -rf $(call arena,$@)/$(GCC_DIR)/$(TARGET_ARCH)/libstdc++-v3-nox > $(call log,$@) 2>&1
	(cd $(call arena,$@)/$(GCC_DIR)/$(TARGET_ARCH); \
		cp -a libstdc++-v3 libstdc++-v3-nox) >> $(call log,$@) 2>&1
	(cd $(call arena,$@)/$(GCC_DIR)/$(TARGET_ARCH)/libstdc++-v3-nox; \
		$(call setenv,$@); \
		$(MAKE) clean; \
		find . -name Makefile -exec sed -i 's/mlongcalls/mlongcalls -fno-exceptions/' \{\} \; ; \
		$(MAKE)) >> $(call log,$@) 2>&1
	(cd $(TARGET_ARCH)$(call ext,$@)/$(TARGET_ARCH)/lib/; \
		cp libstdc++.a libstdc++-exc.a; \
		cp $(call arena,$@)/$(GCC_DIR)/$(TARGET_ARCH)/libstdc++-v3-nox/src/.libs/libstdc++.a ./) >> $(call log,$@) 2>&1
	touch $@

.stage.%.hal-config: .stage.%.libstdcpp-nox
	echo STAGE: $@
	rm -rf $(call arena,$@)/lx106-hal > $(call log,$@) 2>&1
	mkdir -p $(call arena,$@)/lx106-hal >> $(call log,$@) 2>&1
	# note the CC=... to override possibly injected variable after calling 'configure'
	(cd $(call arena,$@)/lx106-hal; \
		$(call setenv,$@); \
		$(REPODIR)/lx106-hal/configure $(call configure,$@) \
			CC=$(TARGET_ARCH)-gcc \
			--target=$(TARGET_ARCH) \
			--host=$(TARGET_ARCH) \
			--exec-prefix=$(call install,$@)/$(TARGET_ARCH)) >> $(call log,$@) 2>&1
	touch $@

.stage.%.hal-make: .stage.%.hal-config
	echo STAGE: $@
	(cd $(call arena,$@)/lx106-hal; \
		$(call setenv,$@); \
		$(MAKE) && $(MAKE) install) > $(call log,$@) 2>&1
	touch $@

.stage.%.strip: .stage.%.hal-make
	echo STAGE: $@
	($(call setenv,$@); \
		$(call host,$@)-strip \
		$(call install,$@)/bin/*$(call exe,$@) \
		$(call install,$@)/lib/bfd-plugins/* \
		$(call install,$@)/libexec/gcc/$(TARGET_ARCH)/*/c*$(call exe,$@) \
		$(call install,$@)/libexec/gcc/$(TARGET_ARCH)/*/lto1$(call exe,$@) || true ) > $(call log,$@) 2>&1
	touch $@

# see MACOSARM_CONFIGURE_VARS
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
	cp -a $(call install,$@) pkg.$(call arch,$@)/$(TARGET_ARCH) >> $(call log,$@) 2>&1
	(cd pkg.$(call arch,$@)/$(TARGET_ARCH); $(call setenv,$@); pkgdesc="xtensa-gcc"; pkgname="toolchain-xtensa"; $(call makepackagejson,$@)) >> $(call log,$@) 2>&1
	(tarball=$(call tarball,$@) ; \
	    cd pkg.$(call arch,$@) && $(call tarcmd,$@) $(call taropt,$@) ../$${tarball} $(TARGET_ARCH)/ ; cd ..; $(call makejson,$@)) >> $(call log,$@) 2>&1
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
			CC=$(CC) CXX=$(CXX) STRIP=$(STRIP) \
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

.stage.%.mklittlefs: .stage.%.start
	echo STAGE: $@
	rm -rf $(call arena,$@)/mklittlefs > $(call log,$@) 2>&1
	cp -a $(REPODIR)/mklittlefs $(call arena,$@)/mklittlefs >> $(call log,$@) 2>&1
	# Dependencies borked in mklittlefs makefile, so don't use parallel make
	(cd $(call arena,$@)/mklittlefs;\
	    $(call setenv,$@); \
	    $(MAKE) -j1 TARGET_OS=$(call mktgt,$@) \
			CC=$(CC) CXX=$(CXX) STRIP=$(STRIP) \
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

.stage.%.esptool: .stage.%.start
	echo STAGE: $@
	rm -rf $(call arena,$@)/esptool > $(call log,$@) 2>&1
	cp -a $(REPODIR)/esptool $(call arena,$@)/esptool >> $(call log,$@) 2>&1
	# Dependencies borked in esptool makefile, so don't use parallel make
	(cd $(call arena,$@)/esptool;\
	    $(call setenv,$@); \
	    $(MAKE) -j1 TARGET_OS=$(call mktgt,$@) \
			CC=$(CC) CXX=$(CXX) STRIP=$(STRIP) \
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

# local tools configure cannot figure out the arch triplet correctly
# also note that locally configured toolchain lacks -cc & -c++ links to gcc
.stage.%.mkspiffs .stage.%.mklittlefs .stage.%.esptool: CC=$(call host,$@)-gcc
.stage.%.mkspiffs .stage.%.mklittlefs .stage.%.esptool: CXX=$(call host,$@)-g++
.stage.%.mkspiffs .stage.%.mklittlefs .stage.%.esptool: STRIP=$(call host,$@)-strip

# arm builds using clang, not gcc.
# same as .stage.%.strip - simply stamp the target, never change it
.stage.MACOSARM.mkspiffs .stage.MACOSARM.mklittlefs .stage.MACOSARM.esptool: CC=$(call host,$@)-cc
.stage.MACOSARM.mkspiffs .stage.MACOSARM.mklittlefs .stage.MACOSARM.esptool: CXX=$(call host,$@)-c++
.stage.MACOSARM.mkspiffs .stage.MACOSARM.mklittlefs .stage.MACOSARM.esptool: STRIP=touch

.stage.%.done: .stage.%.package .stage.%.mkspiffs .stage.%.esptool .stage.%.mklittlefs
	echo STAGE: $@
	echo Done building $(call arch,$@)
	touch $@

.stage.LINUX.arduino-checkout:
	echo "-------- Preparing Arduino repo at $(ARDUINO)"
	test -d $(ARDUINO) || git clone https://github.com/$(GHUSER)/Arduino $(ARDUINO)
	(cd $(ARDUINO) \
		&& git clean -f -d \
		&& git fetch origin $(INSTALLBRANCH) \
		&& git checkout $(INSTALLBRANCH) \
		&& git submodule init \
		&& git submodule update)

.stage.LINUX.arduino-toolchain:
	echo "-------- Copying GCC and LIBSTDC++ libs"
	cp -vu $(call install,$@)/$(TARGET_ARCH)/lib/libstdc++-exc.a $(ARDUINO)/tools/sdk/lib/.
	cp -vu $(call install,$@)/$(TARGET_ARCH)/lib/libstdc++.a     $(ARDUINO)/tools/sdk/lib/.
	echo "-------- Copying toolchain directory"
	rm -rf $(ARDUINO)/tools/sdk/$(TARGET_ARCH)
	cp -va $(call install,$@)/$(TARGET_ARCH) $(ARDUINO)/tools/sdk/$(TARGET_ARCH)

.stage.LINUX.arduino-hal:
	echo "-------- Copying HAL lib"
	cp -vu $(call install,$@)/$(TARGET_ARCH)/lib/libhal.a $(ARDUINO)/tools/sdk/lib/.

.stage.LINUX.arduino-package-json:
	echo "-------- Updating package.json"
	ver=$(REL)-$(SUBREL)-$(REV); pkgfile=$(ARDUINO)/package/package_esp8266com_index.template.json; \
	./patch_json.py --pkgfile "$${pkgfile}" --tool $(TARGET_ARCH)-gcc --ver "$${ver}" --glob '*$(TARGET_ARCH)*.json' ; \
	./patch_json.py --pkgfile "$${pkgfile}" --tool esptool --ver "$${ver}" --glob '*esptool*json' ; \
	./patch_json.py --pkgfile "$${pkgfile}" --tool mkspiffs --ver "$${ver}" --glob '*mkspiffs*json'; \
	./patch_json.py --pkgfile "$${pkgfile}" --tool mklittlefs --ver "$${ver}" --glob '*mklittlefs*json'

.stage.LINUX.arduino-build:
	echo "-------- Installing toolchain"
	(cd $(ARDUINO)/tools && tar xf $(REPODIR)/$(call tarball,$@))
	echo "-------- Building and installing BearSSL"
	(cd $(ARDUINO)/tools/sdk/ssl && make clean && make all && make install)
	echo "-------- Building and installing LWIP2"
	(cd $(ARDUINO)/tools/sdk/lwip2 && make clean && make install)
	echo "-------- Building eboot.elf"
	(cd $(ARDUINO)/bootloaders/eboot && make clean && make)

# Only the native version has to be done to install libs to GIT
install: .stage.LINUX.install
.stage.LINUX.install:
	echo STAGE: $@
	$(MAKE) .stage.LINUX.arduino-checkout
	$(MAKE) .stage.LINUX.arduino-toolchain
	$(MAKE) .stage.LINUX.arduino-hal
	$(MAKE) .stage.LINUX.arduino-package-json
	$(MAKE) .stage.LINUX.arduino-build
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

.stage.%.dumpvars:
	echo SETENV:    '$(call setenv,$@)'
	echo CONFIGURE: '$(call configure,$@)'
	echo NEWLIBCFG: '$(call configure_newlib,$@)'
	echo BINUTILSCFG: '$(call configure_binutils,$@)'
	echo NCURSESCFG: '$(CONFIGURE_NCURSES)'
	echo EXPATCFG: '$(CONFIGURE_EXPAT)'
