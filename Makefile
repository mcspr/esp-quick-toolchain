# DO NOT hide make output w/ NOSILENT=1
ifneq ($(NOSILENT),1)
.SILENT:
endif

# General rule is that CAPITAL variables are constants and can be used
# via $(VARNAME), while lowercase variables are dynamic and need to be
# used via $(call varname,$@) (note no space between comma and $@)

REL     := $(if $(REL),$(REL),3.2.0)
SUBREL  := $(if $(SUBREL),$(SUBREL),testing)
ARDUINO := $(if $(ARDUINO),$(ARDUINO),$(shell pwd)/arduino)
GCC     := $(if $(GCC),$(GCC),14.4)

# General constants
PWD      := $(shell pwd)
REPODIR  := $(PWD)/repo
PATCHDIR := $(PWD)/patches
STAMP    := $(shell date +%y%m%d)
REV      := $(shell git rev-parse --short HEAD)

# For downloading FROM Github, only GHUSER must be set
# For uploading TO Github, both GHUSER and GHTOKEN must be set
# Guard for both to avoid duplicating errors down below
GHUSER := $(if $(GHUSER),$(GHUSER),$(shell cat .ghuser))
GHTOKEN := $(if $(GHTOKEN),$(GHTOKEN),$(shell cat .ghtoken))
ifeq ($(GHUSER),)
    $(error Need to specify GH username on the command line "GHUSER=xxxx" or in .ghuser)
else ifeq ($(GHTOKEN),)
    $(error Need to specify GH PAT on the command line "GHTOKEN=xxxx" or in .ghtoken)
endif

# Depending on the GCC version get proper branch and support libs
ifeq ($(GCC), 4.8)
    ISL_VER       := 0.12.2
    GCC_BRANCH    := call0-4.8.2
    GCC_PKGREL    := 40802
    GCC_REPO      := https://github.com/$(GHUSER)/gcc-xtensa.git
    GCC_DIR       := gcc
    BINUTILS_BRANCH := master
    BINUTILS_REPO := https://github.com/$(GHUSER)/binutils-gdb-xtensa.git
    BINUTILS_DIR  := binutils-gdb
else ifeq ($(GCC), 4.9)
    ISL_VER       := 0.12.2
    GCC_BRANCH    := call0-4.9.2
    GCC_PKGREL    := 40902
    GCC_REPO      := https://github.com/$(GHUSER)/gcc-xtensa.git
    GCC_DIR       := gcc
    BINUTILS_BRANCH := master
    BINUTILS_REPO := https://github.com/$(GHUSER)/binutils-gdb-xtensa.git
    BINUTILS_DIR  := binutils-gdb
else ifeq ($(GCC), 5.2)
    ISL_VER       := 0.12.2
    GCC_BRANCH    := xtensa-ctng-esp-5.2.0
    GCC_PKGREL    := 50200
    GCC_REPO      := https://github.com/$(GHUSER)/gcc-xtensa.git
    GCC_DIR       := gcc
    BINUTILS_BRANCH := master
    BINUTILS_REPO := https://github.com/$(GHUSER)/binutils-gdb-xtensa.git
    BINUTILS_DIR  := binutils-gdb
else ifeq ($(GCC), 7.2)
    ISL_VER       := 0.16.1
    GCC_BRANCH    := xtensa-ctng-7.2.0
    GCC_PKGREL    := 70200
    GCC_REPO      := https://github.com/$(GHUSER)/gcc-xtensa.git
    GCC_DIR       := gcc
    BINUTILS_BRANCH := master
    BINUTILS_REPO := https://github.com/$(GHUSER)/binutils-gdb-xtensa.git
    BINUTILS_DIR  := binutils-gdb
else ifeq ($(GCC), 9.1)
    ISL_VER       := 0.18
    GCC_BRANCH    := gcc-9_1_0-release
    GCC_PKGREL    := 90100
    GCC_REPO      := https://gcc.gnu.org/git/gcc.git
    GCC_DIR       := gcc-gnu
    BINUTILS_BRANCH := binutils-2_32
    BINUTILS_REPO := https://sourceware.org/git/binutils-gdb.git
    BINUTILS_DIR  := binutils-gdb-gnu
else ifeq ($(GCC), 9.2)
    ISL_VER       := 0.18
    GCC_BRANCH    := gcc-9_2_0-release
    GCC_PKGREL    := 90200
    GCC_REPO      := https://gcc.gnu.org/git/gcc.git
    GCC_DIR       := gcc-gnu
    BINUTILS_BRANCH := binutils-2_32
    BINUTILS_REPO := https://sourceware.org/git/binutils-gdb.git
    BINUTILS_DIR  := binutils-gdb-gnu
else ifeq ($(GCC), 9.3)
    ISL_VER       := 0.18
    GCC_BRANCH    := releases/gcc-9.3.0
    GCC_PKGREL    := 90300
    GCC_REPO      := https://gcc.gnu.org/git/gcc.git
    GCC_DIR       := gcc-gnu
    BINUTILS_BRANCH := binutils-2_32
    BINUTILS_REPO := https://sourceware.org/git/binutils-gdb.git
    BINUTILS_DIR  := binutils-gdb-gnu
else ifeq ($(GCC), 10.1)
    ISL_VER       := 0.18
    GCC_BRANCH    := releases/gcc-10.1.0
    GCC_PKGREL    := 100100
    GCC_REPO      := https://gcc.gnu.org/git/gcc.git
    GCC_DIR       := gcc-gnu
    BINUTILS_BRANCH := binutils-2_32
    BINUTILS_REPO := https://sourceware.org/git/binutils-gdb.git
    BINUTILS_DIR  := binutils-gdb-gnu
else ifeq ($(GCC), 10.2)
    ISL_VER       := 0.18
    GCC_BRANCH    := releases/gcc-10.2.0
    GCC_PKGREL    := 100200
    GCC_REPO      := https://gcc.gnu.org/git/gcc.git
    GCC_DIR       := gcc-gnu
    BINUTILS_BRANCH := binutils-2_32
    BINUTILS_REPO := https://sourceware.org/git/binutils-gdb.git
    BINUTILS_DIR  := binutils-gdb-gnu
else ifeq ($(GCC), 10.3)
    ISL_VER       := 0.18
    GCC_BRANCH    := releases/gcc-10.3.0
    GCC_PKGREL    := 100300
    GCC_REPO      := https://gcc.gnu.org/git/gcc.git
    GCC_DIR       := gcc-gnu
    BINUTILS_BRANCH := binutils-2_32
    BINUTILS_REPO := https://sourceware.org/git/binutils-gdb.git
    BINUTILS_DIR  := binutils-gdb-gnu
else ifeq ($(GCC), 11.1)
    ISL_VER       := 0.18
    GCC_BRANCH    := releases/gcc-11.1.0
    GCC_PKGREL    := 110100
    GCC_REPO      := https://gcc.gnu.org/git/gcc.git
    GCC_DIR       := gcc-gnu
    BINUTILS_BRANCH := binutils-2_32
    BINUTILS_REPO := https://sourceware.org/git/binutils-gdb.git
    BINUTILS_DIR  := binutils-gdb-gnu
else ifeq ($(GCC), 14.4)
    ISL_VER       := 0.24
    GCC_BRANCH    := releases/gcc-14.4.0
    GCC_PKGREL    := 140400
    GCC_REPO      := https://gcc.gnu.org/git/gcc.git
    GCC_DIR       := gcc-gnu
    BINUTILS_BRANCH := binutils-2_44
    BINUTILS_REPO := https://sourceware.org/git/binutils-gdb.git
    BINUTILS_DIR  := binutils-gdb-gnu
else
    $(error Need to specify a supported GCC version "GCC={4.8, 4.9, 5.2, 7.2, 9.3, 10.1, 10.2, 10.3, 14.4}")
endif

# cross-compilation triple
TARGET_ARCH := xtensa-lx106-elf

# external dependencies based on git, helpfully named for variable extraction

gcc_DIR := $(GCC_DIR)
gcc_REPO = $(GCC_REPO)
gcc_BRANCH := $(GCC_BRANCH)

binutils_DIR := $(BINUTILS_DIR)
binutils_REPO := $(BINUTILS_REPO)
binutils_BRANCH := $(BINUTILS_BRANCH)

# shared newlib package, expected to be built once after linux toolchain is ready
newlib_DIR := newlib
newlib_REPO := https://github.com/$(GHUSER)/newlib-xtensa.git
newlib_BRANCH := xtensa-4_5_0-lock-arduino

# shared hal package, expected to be built once after linux toolchain is ready
lx106-hal_DIR := lx106-hal
lx106-hal_REPO := https://github.com/$(GHUSER)/lx106-hal.git
lx106-hal_BRANCH := e4bcc63c9c016e4f8848e7e8f512438ca857531d

# extra packages intended for the target system, no need for cross-toolchain
# TODO: split into a separate mkfile and build both lfs versions, let arduino repo handle seamless migration
# MKSPIFFS must stay at 0.2.0 until Arduino boards.txt.py fixes non-page-aligned sizes
mkspiffs_DIR := mkspiffs
mkspiffs_REPO := https://github.com/$(GHUSER)/mkspiffs.git
mkspiffs_BRANCH := 0.2.0

# MKLITTLEFS must be in sync with the Arduino littlefs version
# 4.x.x pins littlefs==2.9.3, which cannot be read by littlefs<2.6.0
mklittlefs_DIR := mklittlefs
mklittlefs_REPO := https://github.com/$(GHUSER)/mklittlefs.git
mklittlefs_BRANCH := 4.0.2-littlefs251

esptool_DIR := esptool
esptool_REPO := https://github.com/$(GHUSER)/esptool.git
esptool_BRANCH := f80ae31d3b99eee41bd6a7fe6fdf4f889c1dc59b

# external dependencies fetched as release blobs

# vendored libelf kept within repo
LIBELF_VER := 0.8.13
LIBELF_BLOB := $(PWD)/blobs/libelf-$(LIBELF_VER).tar.gz

# GNU GDB & the rest of external dependencies which are used for binutils and gcc builds
ISL_URL := https://gcc.gnu.org/pub/gcc/infrastructure/isl-$(ISL_VER).tar.bz2

GMP_VER := 6.3.0
GMP_URL := https://gcc.gnu.org/pub/gcc/infrastructure/gmp-$(GMP_VER).tar.bz2

MPFR_VER := 4.2.2
MPFR_URL := https://gcc.gnu.org/pub/gcc/infrastructure/mpfr-$(MPFR_VER).tar.bz2

MPC_VER := 1.3.1
MPC_URL := https://gcc.gnu.org/pub/gcc/infrastructure/mpc-$(MPC_VER).tar.gz

# TODO: only used for gcc4.x builds
CLOOG_VER := 0.18.1
CLOOG_URL := https://gcc.gnu.org/pub/gcc/infrastructure/cloog-$(CLOOG_VER).tar.gz

# libexpat release tagging works a bit weird
LIBEXPAT_VER := 2.7.1
LIBEXPAT_REV := R_$(subst .,_,$(LIBEXPAT_VER))
LIBEXPAT_URL := https://github.com/libexpat/libexpat/releases/download/$(LIBEXPAT_REV)/expat-$(LIBEXPAT_VER).tar.bz2

# ncurses releases are sometimes just periodic snapshots
NCURSES_VER := 8d252361ceeb3db4f8dec861e0fb414352e88b13
NCURSES_URL := https://github.com/ThomasDickey/ncurses-snapshots/archive/$(NCURSES_VER).zip

URLS := \
	$(GMP_URL) \
	$(ISL_URL) \
	$(LIBEXPAT_URL) \
	$(MPC_URL) \
	$(MPFR_URL) \
	$(NCURSES_URL)

GCC_MAJOR := $(word 1,$(subst ., ,$(GCC)))

ifeq ($(GCC_MAJOR), 4)
	URLS += $(CLOOG_URL)
endif

# LTO doesn't work on 4.8, may not be useful later
LTO := $(if $(lto),$(lto),false)

# Currently supported targets
BUILD_TARGETS := LINUX LINUX32 ARM64 RPI WIN64 WIN32 MACOSARM MACOSX86

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

WIN64_HOST   := x86_64-w64-mingw32
WIN64_AHOST  := x86_64-mingw32
WIN64_EXT    := .win64
WIN64_EXE    := .exe
WIN64_MKTGT  := windows
WIN64_TARCMD := zip
WIN64_TAROPT := -rq
WIN64_TAREXT := zip
WIN64_ASYS   := windows_amd64

WIN32_HOST   := i686-w64-mingw32
WIN32_AHOST  := i686-mingw32
WIN32_EXT    := .win32
WIN32_EXE    := .exe
WIN32_MKTGT  := windows
WIN32_TARCMD := zip
WIN32_TAROPT := -rq
WIN32_TAREXT := zip
WIN32_ASYS   := windows_x86

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
MACOSX86_CONFIGURE_FLAGS := \
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
MACOSARM_CONFIGURE_FLAGS := \
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
RPI_ASYS   := linux_armv6l linux_armv7l

# Call with $@ to get the appropriate variable for this architecture
host   = $($(call arch,$(1))_HOST)
ahost  = $($(call arch,$(1))_AHOST)
ext    = $($(call arch,$(1))_EXT)
exe    = $($(call arch,$(1))_EXE)
mktgt  = $($(call arch,$(1))_MKTGT)
tarcmd = $($(call arch,$(1))_TARCMD)
taropt = $($(call arch,$(1))_TAROPT)
tarext = $($(call arch,$(1))_TAREXT)

# DO NOT generate log files w/ NOLOG=1
# expected to be at the end of *some* command printing to stdout/stderr
ifeq ($(NOLOG),1)
	log_stage :=
	log :=
else
	log_stage = > log$(1) 2>&1
	log = >> log$(1) 2>&1
endif

# For package.json and arduino build
asys    = $($(call arch,$(1))_ASYS)
tarball = $(call host,$(1)).$(TARGET_ARCH)-$(REV).$(STAMP).$(call tarext,$(1))

# sometimes called for ./configure
configure_flags = $($(call arch,$(1))_CONFIGURE_FLAGS)

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
CONFIGURE := \
	--disable-__cxa_atexit \
	--disable-bootstrap \
	--disable-libgomp \
	--disable-libmudflap \
	--disable-libstdcxx-verbose \
	--disable-multilib \
	--disable-nls \
	--disable-shared \
	--enable-languages=c,c++ \
	--enable-lto \
	--enable-static=yes \
	--enable-threads=no \
	--with-newlib

DUMPMACHINE := $(shell gcc -dumpmachine)
configure = \
	--prefix=$(call install,$(1)) \
	--build=$(DUMPMACHINE) \
	--host=$(call host,$(1)) \
	--target=$(TARGET_ARCH) \
	$(CONFIGURE) \
	$(call configure_flags,$(1))

# previously applied through patches/gcc$(GCC)/gcc-eh-alloc.patch
ifeq ($(GCC), 14.4)
CONFIGURE_EH_POOL := \
	--enable-libstdcxx-static-eh-pool \
	--with-libstdcxx-eh-pool-obj-count=4
else
CONFIGURE_EH_POOL :=
endif

# shared gmp stack dependency
configure_with_gmp = \
	--with-gmp=$(call arena,$(1))/cross \
	--with-mpfr=$(call arena,$(1))/cross \
	--with-mpc=$(call arena,$(1))/cross

# graphite support for binutils & gcc
configure_with_isl = \
	--with-isl=$(call arena,$(1))/cross

# --disable-widec
#   enabled by default since ncurses-6.5, but target does not really need wide chars
#   (todo: possibly even attempt to disable wide chars everywhere else)
#
# --without-termlib
#   merge tinfo.a and ncurses.a, since there is no pkgconfig to hint the linker about the 2nd one,
#   binutils would break when attempting to test it w/o linking *both* tinfo.a and ncurses.a
#   (...but even then, host ncursesw.a might precedence if not careful)
#
# --enable-termcap
#   fallback support so we don't depend on tinfo database
#
CONFIGURE_NCURSES := \
	--disable-database \
	--disable-db-install \
	--disable-home-terminfo \
	--disable-overwrite \
	--disable-widec \
	--enable-pc-files \
	--enable-symlinks \
	--enable-termcap \
	--with-build-cppflags=-D_GNU_SOURCE \
	--with-fallbacks=xterm,xterm-256color,screen-256color,linux,vt100 \
	--with-normal \
	--without-ada \
	--without-big-core \
	--without-debug \
	--without-manpages \
	--without-profile \
	--without-progs \
	--without-shared \
	--without-tack \
	--without-termlib \
	--without-tests

NCURSES_CONFIGURE_FLAGS =

configure_ncurses = \
	$(call configure,$(1)) \
	$(CONFIGURE_NCURSES) \
	$(NCURSES_CONFIGURE_FLAGS)

CONFIGURE_LIBEXPAT := \
	--without-docbook \
	--without-xmlwf \
	--without-examples \
	--without-tests

CONFIGURE_BINUTILS := \
	--disable-gdb \
	--disable-libquadmath \
	--disable-nls \
	--disable-sim \
	--enable-serial-configure \
	--without-curses \
	--without-python

configure_binutils = \
	$(call configure,$(1)) \
	$(call configure_with_gmp,$(1)) \
	$(call configure_with_isl,$(1)) \
	$(CONFIGURE_BINUTILS)

# fully static builds broken w/ glibc as libc, just embed up-to-date ncurses & libexpat for the time being
# using something similar to crosstools-ng approach at linking libc & libstdcxx, but just for `ncurses'
CONFIGURE_GDB := \
	--disable-binutils \
	--disable-gas \
	--disable-ld \
	--disable-libquadmath \
	--disable-nls \
	--disable-sim \
	--disable-source-highlight \
	--enable-gdb \
	--enable-serial-configure \
	--enable-tui \
	--with-curses \
	--without-develop \
	--without-included-gettext \
	--without-python \
	--without-x

# circa July 2020, ncurses separates symbol names for static and dynamic library versions
# neither ./configure --with-build-cppflags=... nor make CPPFLAGS=... work as expected
# ensure this is exported before ./configure (aka toplevel) and make (nested ./configure dispatch)
GDB_CPPFLAGS := -DNCURSES_STATIC

setenv_gdb = \
	export CPPFLAGS="$(GDB_CPPFLAGS)"

GDB_CONFIGURE_FLAGS =

configure_gdb = \
	$(call configure,$(1)) \
	$(call configure_with_gmp,$(1)) \
	$(CONFIGURE_GDB) \
	$(GDB_CONFIGURE_FLAGS)

# Newlib configuration common flags
CONFIGURE_NEWLIB := \
	--disable-newlib-supplied-syscalls \
	--disable-newlib-wide-orient \
	--disable-option-checking \
	--disable-shared \
	--enable-multilib \
	--enable-newlib-io-c99-formats \
	--enable-newlib-nano-formatted-io \
	--enable-newlib-reent-small \
	--enable-target-optspace \
	--target=$(TARGET_ARCH) \
	--with-newlib \
	--without-libgloss

# Configuration for newlib normal build
configure_newlib = \
	--prefix=$(call install,$(1)) \
	$(CONFIGURE_NEWLIB)

# The branch in which to store the new toolchain
INSTALLBRANCH ?= master

# Environment variables for configure and building targets.  Only use $(call setenv,$@)
ifeq ($(LTO),true)
	CFFT_LTO := -flto -Wl,-flto
else ifeq ($(LTO),false)
	CFFT_LTO :=
else
    $(error Need to specify LTO={true,false} on the command line)
endif

CFFT := -mlongcalls $(CFFT_LTO) -Os -g -free -fipa-pta

# Generic opts passed to both CC and CXX
SHARED_OPT_FLAGS := -pipe -g -O2

# Sets the environment variables for a subshell while building
# arenaX/cross used as system root for building host tools
# PATH allows both target cross/ tools and host tools built within the context of cross/
# PKG_CONFIG_... should prevent host system pollution while building & installing packages for cross/
setenv = \
	export CFLAGS_FOR_TARGET="$(CFFT)"; \
	export CXXFLAGS_FOR_TARGET="$(CFFT)"; \
	export CFLAGS="$(call cflags,$(1)) $(SHARED_OPT_FLAGS)"; \
	export CXXFLAGS="$(SHARED_OPT_FLAGS)"; \
	export LDFLAGS="$(call ldflags,$(1))"; \
	export PATH="$(call cross,$(1))/bin:$(call install,.stage.LINUX.stage)/bin:$${PATH}"; \
	export PKG_CONFIG_PATH=""; \
	export PKG_CONFIG_LIBDIR="$(call cross,$(1))/lib/pkgconfig"; \
	export PKG_CONFIG_SYSROOT_DIR="$(call cross,$(1))/"; \
	export LD_LIBRARY_PATH="$(call cross,$(1))/lib:$${LD_LIBRARY_PATH}"

# Creates a package.json file for PlatformIO
# Package version **must** conform with Semantic Versioning specicfication:
# - https://github.com/platformio/platformio-core/issues/3612
# - https://semver.org/
PACKAGE_JSON_VERSION := 0.$(GCC_PKGREL).$(STAMP)

# 1) package name 2) package desc 3) package architecture(s)
# multiple architectures expected to be passed as a simple words list
__json_space:=$(subst ,, )
__json_comma:=$(subst ,,,)
define make_package_json
echo '{ \
    "name": "$(1)", \
    "description": "$(2)", \
    "system": [ $(subst $(__json_space),$(__json_comma),$(patsubst %,"%",$(3))) ], \
    "url": "https://github.com/$(GHUSER)/esp-quick-toolchain", \
    "version": "$(PACKAGE_JSON_VERSION)" \
}' > package.json
endef

# Generates a JSON fragment for an uploaded release artifact
RELEASES_JSON_SHORTVER := $(REL)-$(SUBREL)
RELEASES_JSON_FULLVER := $(RELEASES_JSON_SHORTVER)-$(REV)

# 1) tarball name 2) tarball architecture (aka host aka system)
define make_releases_json
tarballsize=$$(stat -c%s $(1)); \
tarballsha256=$$(sha256sum $(1) | cut -f1 -d" "); \
echo '{ \
	"host": "'$(2)'", \
	"url": "https://github.com/$(GHUSER)/esp-quick-toolchain/releases/download/$(RELEASES_JSON_SHORTVER)/'$(1)'", \
	"archiveFileName": "'$(1)'", \
	"checksum": "SHA-256:'$${tarballsha256}'", \
	"size": "'$${tarballsize}'" \
}' > $(1).json
endef

# The recipes begin here.

linux default: .stage.LINUX.done

.PRECIOUS: .stage.% .stage.%.%

.PHONY: .clean.% .clean.%.%

.PHONY: .git.% .git.%.%

.PHONY: .stage.patch .stage.blobs .stage.checkout

.PHONY: .stage.%.start

# Build all toolchain versions
BUILD_DONE = $(patsubst %,.stage.%.done,$(BUILD_TARGETS))
all: $(BUILD_DONE)
	echo STAGE: $@
	echo All complete

$(REPODIR):
	mkdir -p $@

download: .stage.gitclone .stage.blobs

# Other cross-compile cannot start until base toolchain is built
BUILD_GCC1_MAKE = $(patsubst %,.stage.%.gcc1-make,$(filter-out LINUX,$(BUILD_TARGETS)))
$(BUILD_GCC1_MAKE): .stage.LINUX.done

# Clean all temporary build and arena directories
.clean.%.install-and-arena:
	echo STAGE: $@
	rm -rf $(call install,$@) > /dev/null 2>&1
	rm -rf $(call arena,$@) > /dev/null 2>&1

BUILD_CLEAN = $(patsubst %,.clean.%.install-and-arena,$(BUILD_TARGETS))
clean: $(BUILD_CLEAN)
	echo STAGE: $@
	rm -rf .stage* *.json *.tar.gz *.zip pkg.* log.* > /dev/null 2>&1

gitdir = $($(1)_DIR)
gitrepo = $($(1)_REPO)
gitbranch = $($(1)_BRANCH)

# Download the needed GIT repos
REPOS := gcc binutils newlib lx106-hal mkspiffs mklittlefs esptool

CLONE_REPOS = $(patsubst %,.git.%.clone,$(REPOS))
.stage.gitclone: $(CLONE_REPOS)

.git.%.clone: .git.%.reset-and-clean | $(REPODIR)
	echo STAGE: $@
	(test -d $(REPODIR)/$(call gitdir,$*) \
		|| git clone --recurse-submodules \
			--branch $(call gitbranch,$*) \
			$(call gitrepo,$*) \
			$(REPODIR)/$(call gitdir,$*) ) $(call log_stage,$@)

# Completely clean out a git directory, removing any untracked files
.git.%.reset-and-clean: | $(REPODIR)
	echo STAGE: $@
	(test -d $(REPODIR)/$(call gitdir,$(*))/.git \
		&& cd $(REPODIR)/$(call gitdir,$(*)) \
		&& git reset --hard --recurse-submodules \
		&& git clean -x -f -d ) \
	&& echo " GIT CLEAN $(call gitdir,$*)" \
	|| echo " GIT NOCLEAN $@"

CLEAN_REPOS = $(patsubst %,.git.%.reset-and-clean,$(REPOS))
.clean.gitclone: $(CLEAN_REPOS)

.git.%.checkout: .git.%.clone | $(REPODIR)
	echo STAGE: $@
	(test -d $(REPODIR)/$(call gitdir,$(*))/.git \
		&& cd $(REPODIR)/$(call gitdir,$*) \
		&& git checkout $(call gitbranch,$*) ) \
	&& echo " GIT CHECKOUT $(call gitdir,$*)" \
	|| echo " GIT NOCHECKOUT $@"

# Checkout any required branches
CHECKOUT_REPOS = $(patsubst %,.git.%.checkout,$(REPOS))
.stage.checkout: $(CHECKOUT_REPOS)

# Prep fetched urls & local archives
.stage.fetch: | $(REPODIR)
	echo STAGE: $@
	(for url in $(URLS) ; do \
	    archive=$${url##*/}; name=$${archive%.t*}; base=$${name%-*}; ext=$${archive##*.} ; \
		test -r $(REPODIR)/$${archive} || wget -v -O $(REPODIR)/$${archive} $${url} ; \
		(cd $(REPODIR); \
			case "$${ext}" in \
				(bz2|gz|lz|xz) tar xf $${archive} ;; \
				(zip) unzip -qu $${archive} ;; \
				(*) echo " ERROR Unknown archive type $${ext}" ; exit 1 ;; \
			esac && echo " BLOB $${archive}") ; \
	done) $(call log_stage,$@)
	(cd $(REPODIR) \
		&& tar xf $(LIBELF_BLOB) \
		&& echo " BLOB libelf-$(LIBELF_BLOB)" ) $(call log_stage,$@)

.stage.blobs: .stage.fetch .git.gcc.checkout | $(REPODIR)

# Checkout and reset, then apply patches to the local GIT repos
patch = \
	test -r "$(1)" || continue ; \
    (set -x; patch -s -p1 -i $(1))

.stage.gcc.patch: .git.gcc.checkout
	echo STAGE: $@
	(cd $(REPODIR)/$(gcc_DIR); \
		for p in $(PATCHDIR)/gcc-*.patch $(PATCHDIR)/gcc$(GCC)/gcc-*.patch; do \
			$(call patch,$$p); \
		done ) $(call log_stage,$@)
	# external dependencies could be built as part of the tree
	(cd $(REPODIR)/$(gcc_DIR) \
		&& rm -rf libelf \
		&& ln -sf ../libelf-$(LIBELF_VER) libelf \
		&& echo " LINK $(gcc_DIR)/libelf <- libelf-$(LIBELF_VER)" ) $(call log,$@)
ifeq ($(GCC_MAJOR), 4)
	(cd $(REPODIR)/$(gcc_DIR) \
		&& rm -rf cloog \
		&& ln -sf ../cloog-$(CLOOG_VER) cloog \
		&& echo " LINK $(gcc_DIR)/cloog <- cloog-$(CLOOG_VER)" ) $(call log,$@)
endif

.stage.binutils.patch: .git.binutils.checkout
	echo STAGE: $@
	(cd $(REPODIR)/$(binutils_DIR); \
		for p in $(PATCHDIR)/bin-*.patch $(PATCHDIR)/gcc$(GCC)/bin-*.patch; do \
			$(call patch,$$p); \
		done ) $(call log_stage,$@)

.stage.newlib.patch: .git.lx106-hal.patch .git.newlib.checkout
	echo STAGE: $@
	(cd $(REPODIR)/$(newlib_DIR); \
		for p in $(PATCHDIR)/lib-*.patch $(PATCHDIR)/gcc$(GCC)/lib-*.patch; do \
			$(call patch,$$p); \
		done ) $(call log_stage,$@)
	# Recent newlib ships minimal HAL core-isa.h for lx6/lx7 (aka esp32), make sure it is for lx106
	(set -x; cp -va $(REPODIR)/$(lx106-hal_DIR)/include/xtensa/config/core-isa.h \
		$(REPODIR)/$(newlib_DIR)/newlib/libc/machine/xtensa/include/xtensa/config/core-isa.h ) \
		$(call log,$@)

.stage.lx106-hal.patch: .git.lx106-hal.checkout
	echo STAGE: $@
	(cd $(REPODIR)/$(lx106-hal_DIR); \
		for p in $(PATCHDIR)/hal-*.patch; do \
			$(call patch,$$p); \
		done ) $(call log_stage,$@)
	# HAL Makefile.am was patched above
	(cd $(REPODIR)/$(lx106-hal_DIR); \
		set -x; autoreconf -i ) $(call log,$@)

.stage.mkspiffs.patch: .stage.fetch
	echo STAGE: $@
	(cd $(REPODIR)/$(mkspiffs_DIR); \
		for p in $(PATCHDIR)/mkspiffs/$(mkspiffs_BRANCH)*.patch; do \
			$(call patch,$$p); \
		done ) $(call log_stage,$@)

.stage.%.patch:

# Apply all patches
PATCH_REPOS = $(patsubst %,.stage.%.patch,$(REPOS))
.stage.patch: $(PATCH_REPOS) .stage.blobs .stage.checkout
	echo STAGE: $@
	# Dirty-force HAL definition to binutils & gcc
	for ow in \
		$(REPODIR)/$(gcc_DIR)/include/xtensa-config.h \
		$(REPODIR)/$(binutils_DIR)/include/xtensa-config.h; do \
		( cd $(REPODIR)/$(lx106-hal_DIR)/include/xtensa/config; \
	      cat core-isa.h system.h ) > $${ow} ; \
    done $(call log_stage,$@)

.clean.%.cross:
	echo STAGE: $@
	rm -rf $(call arena,$@)/cross

# DO NOT clear downloads & patch w/ NOCLEAN=1
ifneq ($(NOCLEAN),1)
.stage.%.start: .clean.%.cross .stage.patch
else
.stage.%.start:
endif
	echo STAGE: $@
	mkdir -p $(call arena,$@) $(call log_stage,$@)

# Shared dependency for binutils and gcc
.stage.%.gmp: .stage.%.start
	echo STAGE: $@
	(cd $(call arena,$@); \
        rm -rf gmp-$(GMP_VER) mpfr-$(MPFR_VER) mpc-$(MPC_VER)) $(call log_stage,$@)
	(cd $(call arena,$@); \
		mkdir -p gmp-$(GMP_VER) mpfr-$(MPFR_VER) mpc-$(MPC_VER)) $(call log,$@)
	(cd $(call arena,$@)/gmp-$(GMP_VER); \
		$(call setenv,$@); \
		$(REPODIR)/gmp-$(GMP_VER)/configure \
			$(GMP_CONFIGURE_FLAGS) \
			$(call configure,$@) \
				--target=$(call host,$@) \
				--prefix=$(call arena,$@)/cross \
		&& $(MAKE) \
		&& $(MAKE) install) $(call log,$@)
	(cd $(call arena,$@)/mpfr-$(MPFR_VER); \
		$(call setenv,$@); \
		$(REPODIR)/mpfr-$(MPFR_VER)/configure \
			$(call configure,$@) \
			$(call configure_with_gmp,$@) \
			--target=$(call host,$@) \
			--prefix=$(call arena,$@)/cross \
		&& $(MAKE) \
		&& $(MAKE) install) $(call log,$@)
	(cd $(call arena,$@)/mpc-$(MPC_VER); \
		$(call setenv,$@); \
		$(REPODIR)/mpc-$(MPC_VER)/configure \
			$(call configure,$@) \
			$(call configure_with_gmp,$@) \
			--target=$(call host,$@) \
			--prefix=$(call arena,$@)/cross \
		&& $(MAKE) \
		&& $(MAKE) install) $(call log,$@)
	touch $@

.stage.%.isl: .stage.%.gmp
	echo STAGE: $@
	rm -rf $(call arena,$@)/isl $(call log_stage,$@)
	mkdir $(call arena,$@)/isl $(call log,$@)
	(cd $(call arena,$@)/isl ; \
		$(call setenv,$@); \
		$(REPODIR)/isl-$(ISL_VER)/configure \
			$(call configure,$@) \
			$(call configure_with_gmp,$@) \
			--target=$(call host,$@) \
			--prefix=$(call arena,$@)/cross \
		&& $(MAKE) \
		&& $(MAKE) install) $(call log,$@)
	touch $@

# ./configure cannot test .s w/ macos toolchain
.stage.MACOSARM.gmp .stage.MACOSX86.gmp: GMP_CONFIGURE_FLAGS=--disable-assembly

# GDB static build has to have up-to-date libs
.stage.%.libexpat: .stage.%.start
	echo STAGE: $@
	rm -rf $(call arena,$@)/libexpat $(call log_stage,$@)
	mkdir $(call arena,$@)/libexpat $(call log,$@)
	(cd $(call arena,$@)/libexpat; \
		$(call setenv,$@); \
		cp -r $(REPODIR)/libexpat-$(LIBEXPAT_VER)/* ./ ; \
		bash buildconf.sh ;\
		./configure $(call configure,$@) \
			$(CONFIGURE_LIBEXPAT) \
			--prefix=$(call arena,$@)/cross ; \
		$(MAKE) && $(MAKE) install) $(call log,$@)
	touch $@

.stage.%.ncurses: .stage.%.start
	echo STAGE: $@
	rm -rf $(call arena,$@)/ncurses $(call log_stage,$@)
	mkdir $(call arena,$@)/ncurses $(call log,$@)
	(cd $(call arena,$@)/ncurses ; \
		$(call setenv,$@); \
		$(REPODIR)/ncurses-snapshots-$(NCURSES_VER)/configure \
			$(call configure_ncurses,$@) \
			--prefix=$(call arena,$@)/cross \
		&& $(MAKE) \
		&& $(MAKE) install) $(call log,$@)
	touch $@

# --enable-sp-funcs --enable-term-driver
#   available since ncurses-5.8
#
#   > compile  with  terminal-driver. That is used in the
#   > MinGW  port,  and (being somewhat more complicated)
#   > is  an experimental alternative to the conventional
#   > termlib   internals.  Currently,  it  requires  the
#   > sp-funcs feature to be enabled.
#
.stage.WIN32.ncurses .stage.WIN64.ncurses: NCURSES_CONFIGURE_FLAGS=--enable-sp-funcs --enable-term-driver

BUILD_CROSS = .stage.%.gmp \
			  .stage.%.isl \
			  .stage.%.libexpat \
			  .stage.%.ncurses

.NOTPARALLEL: $(BUILD_CROSS)

# Build binutils & gdb
.stage.%.binutils-config: $(BUILD_CROSS)
	echo STAGE: $@
	rm -rf $(call arena,$@)/binutils $(call log_stage,$@)
	mkdir -p $(call arena,$@)/binutils $(call log,$@)
	(cd $(call arena,$@)/binutils; \
		$(call setenv,$@); \
		$(REPODIR)/$(BINUTILS_DIR)/configure \
			$(call configure_binutils,$@) ) $(call log,$@)
	touch $@

BINUTILS_LDFLAGS=

setenv_binutils = \
	export LDFLAGS="$(BINUTILS_LDFLAGS)"

.stage.%.binutils-make: .stage.%.binutils-config
	echo STAGE: $@
	(cd $(call arena,$@)/binutils; \
		$(call setenv,$@); \
		$(call setenv_binutils,$@); \
		$(MAKE) \
		&& $(MAKE) install) $(call log_stage,$@)
	touch $@

# attempt to fix dynamic plugins loader by actually building plugins dynamically
# https://github.com/msys2/MINGW-packages/issues/7890
# https://github.com/msys2/MINGW-packages/blob/68f7d4665c396a464536871b1de7b680a47a8fa7/mingw-w64-binutils/PKGBUILD#L150-L151
.stage.%.binutils-post: .stage.%.binutils-make
ifeq ($(BINUTILS_BRANCH),master)
	echo SKIP: $@
else ifeq ($(BINUTILS_BRANCH),binutils-2_32)
	echo SKIP: $@
else
	echo STAGE: $@
	rm -rf $(call arena,$@)/binutils/ld $(call log_stage,$@)
	mkdir -p $(call arena,$@)/binutils/ld $(call log,$@)
	(cd $(call arena,$@)/binutils/ld; \
		$(call setenv,$@); \
		$(REPODIR)/$(BINUTILS_DIR)/ld/configure \
			$(call configure_binutils,$@) \
			--enable-static=no \
			--enable-shared \
		&& $(MAKE) \
		&& cp -v .libs/$(BINUTILS_PLUGINS) $(call install,$@)/lib/bfd-plugins/) $(call log,$@)
endif
	touch $@

.stage.%.binutils-post: BINUTILS_PLUGINS=libdep.so
.stage.WIN32.binutils-post .stage.WIN64.binutils-post: BINUTILS_PLUGINS=libdep.dll

.stage.%.gdb-config: .stage.%.binutils-post
	echo STAGE: $@
	rm -rf $(call arena,$@)/gdb $(call log_stage,$@)
	mkdir -p $(call arena,$@)/gdb $(call log,$@)
	(cd $(call arena,$@)/gdb; \
		$(call setenv,$@); \
		$(call setenv_gdb,$@); \
		$(REPODIR)/$(BINUTILS_DIR)/configure \
			$(call configure_gdb,$@) ) $(call log,$@)
	touch $@


# --disable-source-highlight
#   ref. https://github.com/crosstool-ng/crosstool-ng/blob/master/scripts/build/debug/300-gdb.sh
#   > libsource-highlight is a dynamic library that uses exception
#   > exceptions are handled by libstdc++
#   > this combination is very buggy, so configure don't use it and abort
#
.stage.WIN32.gdb-config .stage.WIN64.gdb-config: GDB_CONFIGURE_FLAGS=--disable-source-highlight

.stage.%.gdb-make: .stage.%.gdb-config
	echo STAGE: $@
	(cd $(call arena,$@)/gdb; \
		$(call setenv,$@); \
		$(call setenv_binutils,$@); \
		$(call setenv_gdb,$@); \
		$(MAKE) \
		&& $(MAKE) install) $(call log_stage,$@)
	touch $@

# statically link w/ build host gcc & libstdc++
# TODO: c1a5d03a89a455d79f025c66dce83342de4d26ce introduces --with-static-standard-libraries
# TODO: actually useful for binutils as a whole OR as OR ld OR ... ?
.stage.WIN32.binutils-make .stage.WIN32.gdb-make: BINUTILS_LDFLAGS=-static-libgcc -static-libstdc++
.stage.WIN64.binutils-make .stage.WIN64.gdb-make: BINUTILS_LDFLAGS=-static-libgcc -static-libstdc++

.stage.%.gcc1-config: .stage.%.gdb-make
	echo STAGE: $@
	rm -rf $(call arena,$@)/$(GCC_DIR) $(call log_stage,$@)
	mkdir -p $(call arena,$@)/$(GCC_DIR) $(call log,$@)
	(cd $(call arena,$@)/$(GCC_DIR); \
		$(call setenv,$@); \
		$(REPODIR)/$(GCC_DIR)/configure \
			$(CONFIGURE_EH_POOL) \
			$(call configure_with_gmp,$@) \
			$(call configure_with_isl,$@) \
			$(call configure,$@) ) $(call log,$@)
	touch $@

.stage.%.gcc1-make: .stage.%.gcc1-config
	echo STAGE: $@
	(cd $(call arena,$@)/$(GCC_DIR) \
		&& $(call setenv,$@) \
		&& $(MAKE) all-gcc \
		&& $(MAKE) install-gcc) $(call log_stage,$@)
	(cd $(call install,$@)/bin; \
		ln -sf $(TARGET_ARCH)-gcc$(call exe,$@) $(TARGET_ARCH)-cc$(call exe,$@)) $(call log,$@)
	touch $@

.stage.%.newlib-config: .stage.%.gcc1-make
	echo STAGE: $@
	rm -rf $(call arena,$@)/newlib $(call log_stage,$@)
	mkdir -p $(call arena,$@)/newlib $(call log,$@)
	(cd $(call arena,$@)/newlib; \
		$(call setenv,$@); \
		$(REPODIR)/$(newlib_DIR)/configure \
			$(call configure_newlib,$@)) $(call log,$@)
	touch $@

# generates newlib aka libc and hal installations at the install root
# even though these don't have to be rebuilt per target, its fairly short and also verifies that the compiler actually works
.stage.%.newlib-make: .stage.%.newlib-config
	echo STAGE: $@
	(cd $(call arena,$@)/newlib; \
		$(call setenv,$@); $(MAKE)) $(call log_stage,$@)
	(cd $(call arena,$@)/newlib; \
		$(call setenv,$@); $(MAKE) install) $(call log,$@)
	touch $@

.stage.%.hal-config: .stage.%.newlib-make
	echo STAGE: $@
	rm -rf $(call arena,$@)/lx106-hal $(call log_stage,$@)
	mkdir -p $(call arena,$@)/lx106-hal $(call log,$@)
	# note the CC=... to override possibly injected variable after calling 'configure'
	(cd $(call arena,$@)/lx106-hal; \
		$(call setenv,$@); \
		$(REPODIR)/$(lx106-hal_DIR)/configure \
			$(call configure,$@) \
			CC=$(TARGET_ARCH)-gcc \
			--target=$(TARGET_ARCH) \
			--host=$(TARGET_ARCH) ) $(call log,$@)
	touch $@

# nb. override prefix to ONLY place hal .a into the target arch directory, don't copy to BOTH system-wide and target
.stage.%.hal-make: .stage.%.hal-config
	echo STAGE: $@
	(cd $(call arena,$@)/lx106-hal; \
		$(call setenv,$@); \
		$(MAKE) && $(MAKE) \
			prefix=$(call install,$@)/$(TARGET_ARCH) \
			exec_prefix=$(call install,$@)/$(TARGET_ARCH) \
			install ) $(call log_stage,$@)
	touch $@

.stage.%.libstdcpp: .stage.%.hal-make
	echo STAGE: $@
	# stage 2 (build libstdc++)
	(cd $(call arena,$@)/$(GCC_DIR); \
		$(call setenv,$@); \
		$(MAKE) && $(MAKE) install ) $(call log_stage,$@)
	touch $@

.stage.%.libstdcpp-nox: .stage.%.libstdcpp
	echo STAGE: $@
	# We copy existing stdc, adjust the makefile, and build a single .a to save much time
	rm -rf $(call arena,$@)/$(GCC_DIR)/$(TARGET_ARCH)/libstdc++-v3-nox $(call log_stage,$@)
	(cd $(call arena,$@)/$(GCC_DIR)/$(TARGET_ARCH); \
		cp -a libstdc++-v3 libstdc++-v3-nox) $(call log,$@)
	(cd $(call arena,$@)/$(GCC_DIR)/$(TARGET_ARCH)/libstdc++-v3-nox; \
		$(call setenv,$@); \
		$(MAKE) clean; \
		find . -name Makefile -exec sed -i 's/mlongcalls/mlongcalls -fno-exceptions/' \{\} \; ; \
		$(MAKE)) $(call log,$@)
	(cd $(TARGET_ARCH)$(call ext,$@)/$(TARGET_ARCH)/lib/; \
		cp libstdc++.a libstdc++-exc.a; \
		cp $(call arena,$@)/$(GCC_DIR)/$(TARGET_ARCH)/libstdc++-v3-nox/src/.libs/libstdc++.a ./) $(call log,$@)
	touch $@

.stage.%.strip: .stage.%.libstdcpp-nox
	echo STAGE: $@
	($(call setenv,$@); \
		$(call host,$@)-strip \
		$(call install,$@)/bin/*$(call exe,$@) \
		$(call install,$@)/lib/bfd-plugins/* \
		$(call install,$@)/libexec/gcc/$(TARGET_ARCH)/*/c*$(call exe,$@) \
		$(call install,$@)/libexec/gcc/$(TARGET_ARCH)/*/lto1$(call exe,$@) || true ) $(call log_stage,$@)
	touch $@

# see MACOSARM_CONFIGURE_FLAGS, strip is no-op
.stage.MACOSARM.strip: .stage.MACOSARM.libstdcpp-nox
	echo STAGE: $@
	touch $@

.stage.%.post: .stage.%.strip
	echo STAGE: $@
	for sh in post/$(GCC)*.sh; do \
	    [ -x "$${sh}" ] && $${sh} $(call ext,$@) ; \
	done $(call log_stage,$@)
	touch $@

#.stage.%.package: .stage.%.post
.stage.%.package:
	echo STAGE: $@
	rm -rf pkg.$(call arch,$@) $(call log_stage,$@)
	mkdir -p pkg.$(call arch,$@) $(call log,$@)
	cp -a $(call install,$@) pkg.$(call arch,$@)/$(TARGET_ARCH) $(call log,$@)
	(cd pkg.$(call arch,$@)/$(TARGET_ARCH); \
		$(call make_package_json,toolchain-xtensa,xtensa-gcc,$(call asys,$@)) ) $(call log,$@)
	echo before
	(tarball=$(call tarball,$@) \
	    && cd pkg.$(call arch,$@) \
		&& $(call tarcmd,$@) $(call taropt,$@) ../$${tarball} $(TARGET_ARCH)/ \
		&& cd .. \
		&& $(call make_releases_json,$$tarball,$(call ahost,$@)) ) $(call log,$@)
	echo after
	rm -rf pkg.$(call arch,$@) $(call log,$@)
	touch $@

# packaged tools depend only on the host toolchain

.stage.%.mkspiffs:
	echo STAGE: $@
	rm -rf $(call arena,$@)/mkspiffs $(call log_stage,$@)
	mkdir -p $(call arena,$@)/mkspiffs $(call log,$@)
	cp -a $(REPODIR)/$(mkspiffs_DIR) $(call arena,$@)/ $(call log,$@)
	# Dependencies borked in mkspiffs makefile, so don't use parallel make
	(cd $(call arena,$@)/$(mkspiffs_DIR);\
	    $(call setenv,$@); \
	    $(MAKE) -j1 TARGET_OS=$(call mktgt,$@) \
			CC=$(CC) CXX=$(CXX) STRIP=$(STRIP) \
			BUILD_CONFIG_NAME="-arduino-esp8266" \
			CPPFLAGS="-DSPIFFS_USE_MAGIC_LENGTH=0 -DSPIFFS_ALIGNED_OBJECT_INDEX_TABLES=1" \
            mkspiffs$(call exe,$@)) $(call log,$@)
	rm -rf pkg.mkspiffs.$(call arch,$@) $(call log,$@)
	mkdir -p pkg.mkspiffs.$(call arch,$@)/mkspiffs $(call log,$@)
	(cd pkg.mkspiffs.$(call arch,$@)/mkspiffs; \
		$(call make_package_json,mkspiffs,mkspiffs-utility,$(call asys,$@)) ) $(call log,$@)
	cp $(call arena,$@)/mkspiffs/mkspiffs$(call exe,$@) pkg.mkspiffs.$(call arch,$@)/mkspiffs/. $(call log,$@)
	(tarball=$(call host,$@).mkspiffs-$$(cd $(REPODIR)/$(mkspiffs_DIR) \
		&& git rev-parse --short HEAD).$(STAMP).$(call tarext,$@) ; \
	    cd pkg.mkspiffs.$(call arch,$@) && $(call tarcmd,$@) $(call taropt,$@) ../$${tarball} mkspiffs; \
		cd ..; $(call make_releases_json,$$tarball,$(call ahost,$@)) ) $(call log,$@)
	rm -rf pkg.mkspiffs.$(call arch,$@) $(call log,$@)
	touch $@

.stage.%.mklittlefs:
	echo STAGE: $@
	rm -rf $(call arena,$@)/mklittlefs $(call log_stage,$@)
	mkdir -p $(call arena,$@)/mklittlefs $(call log,$@)
	cp -a $(REPODIR)/mklittlefs $(call arena,$@)/ $(call log,$@)
	# Dependencies borked in mklittlefs makefile, so don't use parallel make
	(cd $(call arena,$@)/mklittlefs;\
	    $(call setenv,$@); \
	    $(MAKE) -j1 TARGET_OS=$(call mktgt,$@) \
			CC=$(CC) CXX=$(CXX) STRIP=$(STRIP) \
			BUILD_CONFIG_NAME="-arduino-esp8266" \
            mklittlefs$(call exe,$@)) $(call log,$@)
	rm -rf pkg.mklittlefs.$(call arch,$@) $(call log,$@)
	mkdir -p pkg.mklittlefs.$(call arch,$@)/mklittlefs $(call log,$@)
	(cd pkg.mklittlefs.$(call arch,$@)/mklittlefs; \
		$(call make_package_json,mklittlefs,littlefs-utility,$(call asys,$@)) ) $(call log,$@)
	cp $(call arena,$@)/mklittlefs/mklittlefs$(call exe,$@) pkg.mklittlefs.$(call arch,$@)/mklittlefs/. $(call log,$@)
	(tarball=$(call host,$@).mklittlefs-$$(cd $(REPODIR)/mklittlefs \
		&& git rev-parse --short HEAD).$(STAMP).$(call tarext,$@) ; \
	    cd pkg.mklittlefs.$(call arch,$@) && $(call tarcmd,$@) $(call taropt,$@) ../$${tarball} mklittlefs; \
		cd ..; $(call make_releases_json,$$tarball,$(call ahost,$@)) ) $(call log,$@)
	rm -rf pkg.mklittlefs.$(call arch,$@) $(call log,$@)
	touch $@

# TODO still packaged, but esptool-ck was deprecated in favour of esptool-py a long time ago
.stage.%.esptool:
	echo STAGE: $@
	rm -rf $(call arena,$@)/esptool $(call log_stage,$@)
	mkdir -p $(call arena,$@)/esptool $(call log,$@)
	cp -a $(REPODIR)/esptool $(call arena,$@)/$(call log,$@)
	# Dependencies borked in esptool makefile, so don't use parallel make
	(cd $(call arena,$@)/esptool;\
	    $(call setenv,$@); \
	    $(MAKE) -j1 TARGET_OS=$(call mktgt,$@) \
			CC=$(CC) CXX=$(CXX) STRIP=$(STRIP) \
			BUILD_CONFIG_NAME="-arduino-esp8266" \
            esptool$(call exe,$@)) $(call log,$@)
	rm -rf pkg.esptool.$(call arch,$@) $(call log,$@)
	mkdir -p pkg.esptool.$(call arch,$@)/esptool $(call log,$@)
	cp $(call arena,$@)/esptool/esptool$(call exe,$@) pkg.esptool.$(call arch,$@)/esptool/. $(call log,$@)
	(tarball=$(call host,$@).esptool-$$(cd $(REPODIR)/esptool \
		&& git rev-parse --short HEAD).$(STAMP).$(call tarext,$@) ; \
	    cd pkg.esptool.$(call arch,$@) && $(call tarcmd,$@) $(call taropt,$@) ../$${tarball} esptool; \
		cd ..; $(call make_releases_json,$$tarball,$(call ahost,$@)) ) $(call log,$@)
	rm -rf pkg.esptool.$(call arch,$@) $(call log,$@)
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

.stage.%.done: .stage.%.package .stage.%.mkspiffs .stage.%.mklittlefs .stage.%.esptool
	echo DONE: $(call arch,$@)
	touch $@

.PHONY: .stage.LINUX.arduino-checkout
.stage.LINUX.arduino-checkout:
	echo "-------- Preparing Arduino repo at $(ARDUINO)"
	test -d $(ARDUINO) || git clone https://github.com/$(GHUSER)/Arduino $(ARDUINO)
	(cd $(ARDUINO) \
		&& git clean -x -f -d \
		&& git fetch origin $(INSTALLBRANCH) \
		&& git checkout $(INSTALLBRANCH) \
		&& git submodule init \
		&& git submodule update)

.PHONY: .stage.LINUX.arduino-toolchain
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

.PHONY: .stage.LINUX.arduino-package-json
.stage.LINUX.arduino-package-json:
	echo "-------- Updating package.json"
	ver=$(RELEASES_JSON_FULLVER); pkgfile=$(ARDUINO)/package/package_esp8266com_index.template.json; \
	./patch_json.py --pkgfile "$${pkgfile}" --tool $(TARGET_ARCH)-gcc --ver "$${ver}" --glob '*$(TARGET_ARCH)*.json' ; \
	./patch_json.py --pkgfile "$${pkgfile}" --tool esptool --ver "$${ver}" --glob '*esptool*json' ; \
	./patch_json.py --pkgfile "$${pkgfile}" --tool mkspiffs --ver "$${ver}" --glob '*mkspiffs*json'; \
	./patch_json.py --pkgfile "$${pkgfile}" --tool mklittlefs --ver "$${ver}" --glob '*mklittlefs*json'

.PHONY: .stage.LINUX.arduino-build
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
.stage.LINUX.install: .stage.LINUX.done
	echo STAGE: $@
	$(MAKE) .stage.LINUX.arduino-checkout
	$(MAKE) .stage.LINUX.arduino-toolchain
	$(MAKE) .stage.LINUX.arduino-hal
	$(MAKE) .stage.LINUX.arduino-package-json
	$(MAKE) .stage.LINUX.arduino-build
	echo "Install done"
	touch $@

# Upload a draft toolchain release
.PHONY: .stage.upload
upload: .stage.upload
.stage.upload: $(BUILD_DONE)
	echo STAGE: $@
	rm -rf ./arena.upload
	mkdir ./arena.upload
	(cd ./arena.upload \
		&& cp -vaf ../blobs/* . \
		&& python3 -m venv ./venv \
		&& . venv/bin/activate \
			&& pip3 install -q pygithub \
			&& python3 ../upload_release.py \
				--user "$(GHUSER)" \
				--token "$(GHTOKEN)" \
				--tag $(RELEASES_JSON_SHORTVER) \
				--name "ESP8266 Quick Toolchain for $(RELEASES_JSON_SHORTVER)" \
				--msg "See https://github.com/esp8266/Arduino for more info" \
				$$(find ./ -maxdepth 1 -name "*.tar.gz" -o -name "*.zip") )
	rm -rf ./arena.upload

.PHONY: .stage.%.dumpvars
.stage.%.dumpvars:
	echo SETENV:	'$(call setenv,$@)'
	echo CONFIGURE:	'$(call configure,$@)'
	echo NCURSES:	'$(CONFIGURE_NCURSES)'
	echo LIBEXPAT:	'$(CONFIGURE_LIBEXPAT)'
	echo BINUTILS:	'$(call configure_binutils,$@)'
	echo GDB:	'$(call configure_gdb,$@)'
	echo NEWLIB:	'$(call configure_newlib,$@)'
