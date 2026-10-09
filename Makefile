# Omit default rule to rebuild itself
.PHONY: Makefile

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
POSTDIR  := $(PWD)/post
PKGDIR   := $(PWD)/package
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
    BINUTILS_BRANCH := binutils-2_47
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
PACKAGES := gmp isl libexpat mpc mpfr ncurses

# GNU GDB & the rest of external dependencies which are used for binutils and gcc builds
isl_VER := ISL_VER
isl_URL := https://gcc.gnu.org/pub/gcc/infrastructure/isl-$(isl_VER).tar.bz2
isl_DIR := isl-$(isl_VER)

gmp_VER := 6.3.0
gmp_URL := https://gcc.gnu.org/pub/gcc/infrastructure/gmp-$(gmp_VER).tar.bz2
gmp_DIR := gmp-$(gmp_VER)

mpfr_VER := 4.2.2
mpfr_URL := https://gcc.gnu.org/pub/gcc/infrastructure/mpfr-$(mpfr_VER).tar.bz2
mpfr_DIR := mpfr-$(mpfr_VER)

mpc_VER := 1.3.1
mpc_URL := https://gcc.gnu.org/pub/gcc/infrastructure/mpc-$(mpc_VER).tar.gz
mpc_DIR := mpc-$(mpc_VER)

# libexpat release tagging works a bit weird
libexpat_VER := 2.8.5
libexpat_REV := R_$(subst .,_,$(libexpat_VER))
libexpat_URL := https://github.com/libexpat/libexpat/releases/download/$(libexpat_REV)/expat-$(libexpat_VER).tar.bz2
libexpat_DIR := expat-$(libexpat_VER)

# ncurses releases are sometimes just periodic snapshots
ncurses_VER := 41553966d3ac468f9fff0b63f98841aefb0cb04e
ncurses_URL := https://github.com/ThomasDickey/ncurses-snapshots/archive/$(ncurses_VER).zip
ncurses_DIR := ncurses-snapshots-$(ncurses_VER)

# TODO: only used for gcc4.x builds
cloog_VER := 0.18.1
cloog_URL := https://gcc.gnu.org/pub/gcc/infrastructure/cloog-$(cloog_VER).tar.gz
cloog_DIR := cloog-$(cloog_VER)

GCC_MAJOR := $(word 1,$(subst ., ,$(GCC)))

ifeq ($(GCC_MAJOR), 4)
	PACKAGES += cloog
endif

# LTO doesn't work on 4.8, may not be useful later
LTO := $(if $(lto),$(lto),false)

# Currently supported targets
BUILD_TARGETS := LINUX LINUX32 ARM64 RPI WIN64 WIN32 MACOSARM MACOSX86

# Define the build and output naming, don't use directly (see below)
# Currently not using ..._STATIC / -Wl,-static, its up to the tools
#
# ..._HOST   - build system target triplet
# ..._AHOST  - arduino manifest architecture name
# ..._EXT    - toolchain name suffix
# ..._EXE    - toolchain executable files suffix
# ..._MKTGT  - tool target os hint
# ..._TARCMD - release archive compression tool
# ..._TAREXT - release archive file suffix
# ..._ASYS   - platformio manifest system name(s)
#
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
MACOSX86_CC := $(MACOSX86_HOST)-cc
MACOSX86_CXX := $(MACOSX86_HOST)-c++
MACOSX86_STRIP := $(MACOSX86_HOST)-strip

MACOSX86_CONFIGURE_FLAGS := \
	--disable-lto \
	CC=$(MACOSX86_CC) \
	CXX=$(MACOSX86_CXX)

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
MACOSARM_CC := $(MACOSARM_HOST)-cc
MACOSARM_CXX := $(MACOSARM_HOST)-c++
MACOSARM_STRIP := touch

MACOSARM_CONFIGURE_FLAGS := \
	--disable-lto \
	CC=$(MACOSARM_CC) \
	CXX=$(MACOSARM_CXX) \
	STRIP=$(MACOSARM_STRIP)

# For .foo.%.bar recipe, where % is target architecture
# (vs. $*, useful for both implicit and explicit targets)
stem = $(subst .,,$(suffix $(basename $(1))))
arch = $(call stem,$(1))

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

# For platformio package.json
asys    = $($(call arch,$(1))_ASYS)
tarball = $(call host,$(1)).$(TARGET_ARCH)-$(REV).$(STAMP).$(call tarext,$(1))

# sometimes called for ./configure
configure_flags = $($(call arch,$(1))_CONFIGURE_FLAGS)

# The build directory per architecture
arena = $(PWD)/arena$(call ext,$(1))
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
	$(CONFIGURE) \
	--build=$(DUMPMACHINE) \
	--host=$(call host,$(1)) \
	$(call configure_flags,$(1))

configure_cross = \
	--target=$(call host,$(1)) \
	--prefix=$(call arena,$(1))/cross \
	$(call configure,$(1))

configure_target = \
	--target=$(TARGET_ARCH) \
	--prefix=$(call install,$(1)) \
	$(call configure,$(1))

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

# --without-termlib
#   merge tinfo.a and ncurses.a, since there is no pkgconfig to hint the linker about the 2nd one,
#   binutils would break when attempting to test it w/o linking *both* tinfo.a and ncurses.a
#   (...but even then, host ncursesw.a might precedence if not careful)
#
# --enable-termcap
#   fallback support so we don't depend on tinfo database
#   note that this *must* read existing database from somewhere, either host or cross that was previously built w/o fallbacks
#
# --enable-widec
#   enabled by default since ncurses-6.5, ensure existing database files *could* be
#   converted into fallback (verify arena*/ncurses/ncurses/fallback.c after build)
#   currently, this only affects xterm* terminfos
#
CONFIGURE_NCURSES := \
	--disable-home-terminfo \
	--disable-overwrite \
	--disable-stripping \
	--enable-pc-files \
	--enable-symlinks \
	--enable-widec \
	--with-build-cppflags=-D_GNU_SOURCE \
	--with-normal \
	--without-ada \
	--without-big-core \
	--without-debug \
	--without-manpages \
	--without-profile \
	--without-shared \
	--without-tack \
	--without-termlib \
	--without-tests

NCURSES_CONFIGURE_FLAGS =

configure_ncurses = \
	$(call configure_cross,$(1)) \
	$(CONFIGURE_NCURSES) \
	$(NCURSES_CONFIGURE_FLAGS)

# initialize ncurses for host so database & tic could be used later instead of the container one
NCURSES_CONFIGURE_FLAGS_WITH_PROGS := \
	--program-prefix="" \
	--with-fallbacks="" \
	--without-cxx-binding \
	--without-form \
	--without-menu \
	--without-panel \
	--with-progs

# generate static libraries fallbacks built in via termcap
NCURSES_CONFIGURE_FLAGS_WITH_FALLBACKS := \
	--enable-termcap \
	--without-progs \
	--disable-database \
	--disable-db-install \
	--with-fallbacks=xterm,xterm-256color,screen-256color,linux,vt100

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
	$(call configure_target,$(1)) \
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
	export CPPFLAGS="$(GDB_CPPFLAGS) $${CPPFLAGS}"

GDB_CONFIGURE_FLAGS =

configure_gdb = \
	$(call configure_target,$(1)) \
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

# arenaX/cross used as system root for building host tools
# linux installation path used as build tools root
SHARED_PATH_BIN := $(call cross,.stage.LINUX.stage)/bin:$(call install,.stage.LINUX.stage)/bin

# Sets the environment variables for a subshell while building
# PATH allows both target cross/ tools and host tools built within the context of cross/
# PKG_CONFIG_... should prevent host system pollution while building & installing packages for cross/
setenv = export \
	CFLAGS_FOR_TARGET="$(CFFT)" \
	CXXFLAGS_FOR_TARGET="$(CFFT)" \
	CFLAGS="$(call cflags,$(1)) $(SHARED_OPT_FLAGS) $${CFLAGS}" \
	CXXFLAGS="$(SHARED_OPT_FLAGS) $${CXXFLAGS}" \
	LDFLAGS="$(call ldflags,$(1)) $${LDFLAGS}" \
	PATH="$(call cross,$(1))/bin:$(SHARED_PATH_BIN):$${PATH}" \
	PKG_CONFIG_PATH="" \
	PKG_CONFIG_LIBDIR="$(call cross,$(1))/lib/pkgconfig" \
	PKG_CONFIG_SYSROOT_DIR="$(call cross,$(1))/" \
	LD_LIBRARY_PATH="$(call cross,$(1))/lib:$${LD_LIBRARY_PATH}"

# in case host triplet is missing / cannot be discovered, ensure these are exported
# for some cases, explicit variables are required before and after ./configure
setenv_cross = export \
	CC=$(or $($(call arch,$(1))_CC),$(call host,$(1))-gcc) \
	CXX=$(or $($(call arch,$(1))_CXX),$(call host,$(1))-g++) \
	STRIP=$(or $($(call arch,$(1))_STRIP),$(call host,$(1))-strip) \
	&& $(call setenv,$(1))

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

.PHONY: linux
linux default: .stage.LINUX.done

.PRECIOUS: .stage.% .stage.%.%

.PHONY: .clean.% .clean.%.%

.PHONY: .git.% .git.%.%

.PHONY: .package.% .package.%.%

.PHONY: .stage.patch .stage.fetch .stage.checkout

.PHONY: .stage.%.info .stage.%.patch .stage.%.fetch .stage.%.clean

# Leave jobserver to the submake calls
.NOTPARALLEL:

download: .stage.checkout .stage.fetch

build_done = .stage.$(1).package .stage.$(1).mkspiffs .stage.$(1).mklittlefs .stage.$(1).esptool

define recipe_done
.stage.$(1).done: $(call build_done,$(1))
	echo DONE: $$(call arch,$$@)
	touch $$@
endef

$(foreach target,$(BUILD_TARGETS),$(eval $(call recipe_done,$(target))))

# Build all toolchain versions
BUILD_DONE = $(patsubst %,.stage.%.done,$(BUILD_TARGETS))

define __newline

endef

define make_done_recipe
	$(MAKE) .stage.$(1).done$(__newline)
endef

BUILD_TARGETS_WITHOUT_LINUX := $(filter-out LINUX,$(BUILD_TARGETS))

all:
	echo STAGE: $@
	$(MAKE) $(patsubst %,.clean.%.cross,$(BUILD_TARGETS))
	$(MAKE) .stage.patch
	$(call make_done_recipe,LINUX)
	$(foreach target,$(BUILD_TARGETS_WITHOUT_LINUX),$(call make_done_recipe,$(target)))
	echo All complete

define make_phony_first_recipe

.PHONY: $(1)

$(1):
	$(MAKE) .stage.patch
	$(MAKE) .clean.$(1).cross .clean.LINUX.cross
	$(call make_done_recipe,$(1))

endef

define make_phony_other_recipe

.PHONY: $(1)
$(1):
	$(MAKE) .stage.patch
	$(MAKE) .clean.$(1).cross .clean.LINUX.cross
	$(call make_done_recipe,LINUX)
	$(call make_done_recipe,$(1))

endef

$(eval $(call make_phony_first_recipe,LINUX))
$(eval $(foreach target,$(BUILD_TARGETS_WITHOUT_LINUX),$(call make_phony_other_recipe,$(target))))

# Clean all temporary build and arena directories
.clean.%.install-and-arena:
	echo STAGE: $@
ifneq ($(NOCLEAN),1)
	rm -rf $(call install,$@)
	rm -rf $(call arena,$@)
endif

# Clean all files generated during TARGET stage
.stage.%.clean:
	echo STAGE: $@
ifneq ($(NOCLEAN),1)
	rm -vf $(patsubst .stage.%.clean,.stage.%*,$@)
	rm -vf $(patsubst .stage.%.clean,log.stage.%*,$@)
	rm -vrf $(PKGDIR)/pkg.*$(call arch,$@)*
	rm -vf $(PKGDIR)/$(call host,$@)*
endif

BUILD_CLEAN_TARGETS = $(patsubst %,.clean.%.install-and-arena,$(BUILD_TARGETS))
STAGE_CLEAN_TARGETS = $(patsubst %,.stage.%.clean,$(BUILD_TARGETS))
clean: $(BUILD_CLEAN_TARGETS) $(STAGE_CLEAN_TARGETS)
	echo STAGE: $@

__gitrepo = $(if $($(1)_REPO),$($(1)_REPO),$(error no git repo for $(1)))
gitrepo = $(call __gitrepo,$(call stem,$(1)))

__gitbranch = $(if $($(1)_BRANCH),$($(1)_BRANCH),$(error no git branch for $(1)))
gitbranch = $(call __gitbranch,$(call stem,$(1)))

__gitdir = $(if $($(1)_DIR),$($(1)_DIR),$(error no git dir for $(1)))
gitdir = $(call __gitdir,$(call stem,$(1)))

# Download the needed GIT repos
REPOS := gcc binutils newlib lx106-hal mkspiffs mklittlefs esptool

.git.%.info:
	@echo '{ "name": "$(call stem,$@)"',
	@echo '  "url": "$(call gitrepo,$@)"',
	@echo '  "branch": "$(call gitbranch,$@)"',
	@echo '  "dir": "$(REPODIR)/$(call gitdir,$@)" }'

REPOS_INFO = $(patsubst %,.git.%.info,$(REPOS))
.git.info: $(REPOS_INFO)

.git.%.clone: .git.%.reset-and-clean
	echo STAGE: $@
	mkdir -p $(REPODIR)/
	(test -d $(REPODIR)/$(call gitdir,$@) \
		|| git clone --recurse-submodules \
			--branch $(call gitbranch,$@) \
			$(call gitrepo,$@) \
			$(REPODIR)/$(call gitdir,$@) ) $(call log_stage,$@)

# Completely clean out a git directory, removing any untracked files
.git.%.reset-and-clean:
	echo STAGE: $@
	(test -d $(REPODIR)/$(call gitdir,$@)/.git \
		&& cd $(REPODIR)/$(call gitdir,$@) \
		&& git reset --hard --recurse-submodules \
		&& git clean -x -f -d ) \
	&& echo " GIT CLEAN $(call gitdir,$@)" \
	|| echo " GIT NOCLEAN $@"

CLEAN_REPOS = $(patsubst %,.git.%.reset-and-clean,$(REPOS))
.clean.gitclone: $(CLEAN_REPOS)

.git.%.checkout: .git.%.clone
	echo STAGE: $@
	(test -d $(REPODIR)/$(call gitdir,$@)/.git \
		&& cd $(REPODIR)/$(call gitdir,$@) \
		&& git checkout $(call gitbranch,$@) ) \
	&& echo " GIT CHECKOUT $(call gitdir,$@)" \
	|| echo " GIT NOCHECKOUT $@"

# Checkout any required branches
CHECKOUT_REPOS = $(patsubst %,.git.%.checkout,$(REPOS))
.stage.checkout: $(CHECKOUT_REPOS)

# TODO: tarball support for humongous repos (gcc, binutils, etc.)
# 		while very useful for development, not so much for just building
# 		current archive unpack impl should behave similarly to git-clean

# Packages usually just fetched & unpacked, there is no patching being done
__pkgurl = $(if $($(1)_URL),$($(1)_URL),$(error no package url for $(1)))
pkgurl = $(call __pkgurl,$(call stem,$(1)))

__pkgver = $(if $($(1)_VER),$($(1)_VER),$(error no package version for $(1)))
pkgver = $(call __pkgver,$(call stem,$(1)))

__pkgdir = $(if $($(1)_DIR),$($(1)_DIR),$(error no package dir for $(1)))
pkgdir = $(call __pkgdir,$(call stem,$(1)))

__pkgarchive = $(lastword $(subst /, ,$(call __pkgurl,$(1))))
pkgarchive = $(call __pkgarchive,$(call stem,$(1)))

__pkgsuffix = $(suffix $(call __pkgarchive,$(1)))
__pkgfullsuffix = $(findstring .tar,$(call __pkgarchive,$(1)))$(call __pkgsuffix,$(1))
__pkgext = $(if $(call __pkgfullsuffix,$(1)),$(call __pkgfullsuffix,$(1)),$(error no known archive extension for $(1)))
pkgext = $(call __pkgext,$(call stem,$(1)))

# Fetch package urls & unpack archives
.package.%.info:
	@echo '{ "name": "$(call stem,$@)",'
	@echo '  "url": "$(call pkgurl,$@)"',
	@echo '  "version": "$(call pkgver,$@)"',
	@echo '  "dir": "$(REPODIR)/$(call pkgdir,$@)"',
	@echo '  "archive": "$(REPODIR)/$(call pkgarchive,$@)"',
	@echo '  "extension": "$(call pkgext,$@)" }'

PACKAGES_INFO = $(patsubst %,.package.%.info,$(PACKAGES))
.package.info: $(PACKAGES_INFO)

.package.%.fetch:
	echo STAGE: $@
	mkdir -p $(REPODIR)/
	test -r $(REPODIR)/$(call pkgarchive,$@) \
		|| wget -v -O $(REPODIR)/$(call pkgarchive,$@) $(call pkgurl,$@) $(call log_stage,$@)

.package.%.unpack: .package.%.fetch
	echo STAGE: $@
	mkdir -p $(REPODIR)/
	test -r $(REPODIR)/$(call pkgarchive,$@)
	rm -rf $(REPODIR)/$(call pkgdir,$@)
	(cd $(REPODIR) && \
		archive="$(call pkgarchive,$@)"; \
		ext="$(call pkgext,$@)"; \
		case "$$ext" in \
			(.t*) tar xf $$archive ;; \
			(.zip) unzip -qu $$archive ;; \
			(*) echo "-ERROR Unknown archive type"; exit 1 ;; \
		esac && echo "UNPACKED $$archive")
	test -d $(REPODIR)/$(call pkgdir,$@)

FETCH_PACKAGES = $(patsubst %,.package.%.unpack,$(PACKAGES))
.stage.fetch: $(FETCH_PACKAGES)
	echo STAGE: $@

# Checkout and reset, then apply patches to the local GIT repos
patch = \
	test -r "$(1)" || continue ; \
    (set -x; patch -s -p1 -i $(1))

# Dirty-force HAL definition for binutils & gcc
LX106_HAL_CORE_ISA_H := $(REPODIR)/$(lx106-hal_DIR)/include/xtensa/config/core-isa.h
LX106_HAL_SYSTEM_H := $(REPODIR)/$(lx106-hal_DIR)/include/xtensa/config/system.h
LX106_HAL_XTENSA_CONFIG_H := \
	$(LX106_HAL_CORE_ISA_H) \
	$(LX106_HAL_SYSTEM_H)

$(LX106_HAL_XTENSA_CONFIG_H): .stage.lx106-hal.patch

OVERLAY_XTENSA_CONFIG_H := $(REPODIR)/xtensa-config.h
$(OVERLAY_XTENSA_CONFIG_H): $(LX106_HAL_XTENSA_CONFIG_H)
	test -r "$(OVERLAY_XTENSA_CONFIG_H)" \
		&& (cat $^ | diff -q $(OVERLAY_XTENSA_CONFIG_H) - || cat $^ > $@) \
		|| (cat $^ > $@)

.stage.gcc.patch: $(OVERLAY_XTENSA_CONFIG_H) .git.gcc.checkout
	echo STAGE: $@
	(cd $(REPODIR)/$(gcc_DIR) && \
		for p in $(PATCHDIR)/gcc-*.patch $(PATCHDIR)/gcc$(GCC)/gcc-*.patch; do \
			$(call patch,$$p); \
		done ) $(call log_stage,$@)
	(cd $(REPODIR)/$(gcc_DIR) \
		&& cp -v $(OVERLAY_XTENSA_CONFIG_H) include/xtensa-config.h) $(call log,$@)
ifeq ($(GCC_MAJOR), 4)
	# external dependency built as part of the tree
	(cd $(REPODIR)/$(gcc_DIR) \
		&& rm -rf cloog \
		&& ln -sf ../cloog-$(CLOOG_VER) cloog \
		&& echo " LINK $(gcc_DIR)/cloog <- cloog-$(CLOOG_VER)" ) $(call log,$@)
endif

.stage.binutils.patch: $(OVERLAY_XTENSA_CONFIG_H) .git.binutils.checkout
	echo STAGE: $@
	(cd $(REPODIR)/$(binutils_DIR) && \
		for p in $(PATCHDIR)/bin-*.patch $(PATCHDIR)/gcc$(GCC)/bin-*.patch; do \
			$(call patch,$$p); \
		done ) $(call log_stage,$@)
	(cd $(REPODIR)/$(binutils_DIR) \
		&& cp -va $(OVERLAY_XTENSA_CONFIG_H) include/xtensa-config.h) $(call log,$@)

# Recent newlib ships minimal HAL core-isa.h for lx6/lx7 (aka esp32), make sure it is for lx106
LX106_HAL_CORE_ISA_H := $(REPODIR)/$(lx106-hal_DIR)/include/xtensa/config/core-isa.h
$(LX106_HAL_CORE_ISA_H): .stage.lx106-hal.patch

NEWLIB_CORE_ISA_H := $(REPODIR)/$(newlib_DIR)/newlib/libc/machine/xtensa/include/xtensa/config/core-isa.h
OVERLAY_CORE_ISA_H := $(REPODIR)/core-isa.h

$(NEWLIB_CORE_ISA_H): $(OVERLAY_CORE_ISA_H)

$(OVERLAY_CORE_ISA_H): $(LX106_HAL_CORE_ISA_H)
	test -r "$(OVERLAY_CORE_ISA_H)" \
		&& (diff -q $< $@ || cp $< $@) \
		|| (cp $< $@)

.stage.newlib.patch: $(OVERLAY_CORE_ISA_H) .git.newlib.checkout
	echo STAGE: $@
	(cd $(REPODIR)/$(newlib_DIR) && \
		for p in $(PATCHDIR)/lib-*.patch $(PATCHDIR)/gcc$(GCC)/lib-*.patch; do \
			$(call patch,$$p); \
		done ) $(call log_stage,$@)
	(set -x; cp -va $(OVERLAY_CORE_ISA_H) $(NEWLIB_CORE_ISA_H)) $(call log,$@)

.stage.lx106-hal.patch: .git.lx106-hal.checkout
	echo STAGE: $@
	(cd $(REPODIR)/$(lx106-hal_DIR) && \
		for p in $(PATCHDIR)/hal-*.patch; do \
			$(call patch,$$p); \
		done ) $(call log_stage,$@)
	# HAL Makefile.am was patched above
	(cd $(REPODIR)/$(lx106-hal_DIR) \
		&& autoreconf -i ) $(call log,$@)

.stage.mkspiffs.patch: .git.mkspiffs.checkout
	echo STAGE: $@
	(cd $(REPODIR)/$(mkspiffs_DIR) && \
		for p in $(PATCHDIR)/mkspiffs/$(mkspiffs_BRANCH)*.patch; do \
			$(call patch,$$p); \
		done ) $(call log_stage,$@)

.stage.%.patch: .git.%.checkout
	echo STAGE: $@

ifneq ($(NOCLEAN),1)
# Fetch, checkout all git repositories and apply all patches
PATCH_REPOS = $(patsubst %,.stage.%.patch,$(REPOS))
.stage.patch: $(PATCH_REPOS) .stage.fetch .stage.checkout
else
# DO NOT clear git repos w/ NOCLEAN=1
.stage.patch:
endif
	echo STAGE: $@

# DO NOT clear existing cross tree w/ NOCLEAN=1
.clean.%.cross:
	echo STAGE: $@
ifneq ($(NOCLEAN),1)
	rm -rf $(call arena,$@)/cross
endif

# Info about current stage build configuration
.stage.%.info:
	@echo '{ "setenv": "$(subst ",\",$(call setenv,$@))"',
	@echo '  "configure": "$(call configure,$@)"',
	@echo '  "configure_ncurses": "$(CONFIGURE_NCURSES)"',
	@echo '  "configure_libexpat": "$(CONFIGURE_LIBEXPAT)"',
	@echo '  "configure_binutils": "$(call configure_binutils,$@)"',
	@echo '  "configure_gdb": "$(call configure_gdb,$@)"',
	@echo '  "configure_newlib": "$(call configure_newlib,$@)" }'

# Shared dependency for binutils and gcc
.stage.%.gmp:
	echo STAGE: $@
	rm -rf $(call arena,$@)/gmp $(call log_stage,$@)
	mkdir -p $(call arena,$@)/gmp $(call log,$@)
	(cd $(call arena,$@)/gmp \
		&& $(call setenv,$@) \
		&& $(REPODIR)/$(gmp_DIR)/configure \
			$(call configure_cross,$@) \
			$(GMP_CONFIGURE_FLAGS) \
		&& $(MAKE) \
		&& $(MAKE) install) $(call log,$@)
	rm -rf $(call arena,$@)/mpfr $(call log,$@)
	mkdir -p $(call arena,$@)/mpfr $(call log,$@)
	(cd $(call arena,$@)/mpfr \
		&& $(call setenv,$@) \
		&& $(REPODIR)/$(mpfr_DIR)/configure \
			$(call configure_cross,$@) \
			$(call configure_with_gmp,$@) \
		&& $(MAKE) \
		&& $(MAKE) install) $(call log,$@)
	rm -rf $(call arena,$@)/mpc $(call log,$@)
	mkdir -p $(call arena,$@)/mpc $(call log,$@)
	(cd $(call arena,$@)/mpc \
		&& $(call setenv,$@) \
		&& $(REPODIR)/$(mpc_DIR)/configure \
			$(call configure_cross,$@) \
			$(call configure_with_gmp,$@) \
		&& $(MAKE) \
		&& $(MAKE) install) $(call log,$@)
	touch $@

# isl-0.xx expects gmp prefix as --with-gmp-prefix=... unlike any other ./configure script here
.stage.%.isl: .stage.%.gmp
	echo STAGE: $@
	rm -rf $(call arena,$@)/isl $(call log_stage,$@)
	mkdir -p $(call arena,$@)/isl $(call log,$@)
	(cd $(call arena,$@)/isl \
		&& $(call setenv,$@) \
		&& $(REPODIR)/$(isl_DIR)/configure \
			$(call configure_cross,$@) \
			--with-gmp-prefix=$(call arena,$@)/cross \
		&& $(MAKE) \
		&& $(MAKE) install) $(call log,$@)
	touch $@

# ./configure cannot test .s w/ macos toolchain
.stage.MACOSARM.gmp .stage.MACOSX86.gmp: GMP_CONFIGURE_FLAGS=--disable-assembly

# GDB static build has to have up-to-date libs
.stage.%.libexpat:
	echo STAGE: $@
	rm -rf $(call arena,$@)/libexpat $(call log_stage,$@)
	mkdir -p $(call arena,$@)/libexpat $(call log,$@)
	(cd $(call arena,$@)/libexpat \
		&& $(call setenv,$@) \
		&& cp -r $(REPODIR)/$(libexpat_DIR)/* ./ \
		&& bash buildconf.sh \
		&& ./configure \
			$(call configure_cross,$@) \
			$(CONFIGURE_LIBEXPAT) \
		&& $(MAKE) \
		&& $(MAKE) install ) $(call log,$@)
	touch $@

# only host toolchain cross has to have these
.stage.%.ncurses-progs:
	echo STAGE: $@
	touch $@

.stage.LINUX.ncurses-progs:
	echo STAGE: $@
	rm -rf $(call arena,$@)/ncurses-progs $(call log_stage,$@)
	mkdir -p $(call arena,$@)/ncurses-progs $(call log,$@)
	(cd $(call arena,$@)/ncurses-progs \
		&& $(call setenv_cross,$@) \
		&& $(REPODIR)/$(ncurses_DIR)/configure \
			$(call configure_ncurses,$@) \
			$(NCURSES_CONFIGURE_FLAGS_WITH_PROGS) \
		&& $(MAKE) \
		&& $(MAKE) install) $(call log,$@)
	touch $@

# target cross built per arch
.stage.%.ncurses: .stage.%.ncurses-progs
	echo STAGE: $@
	rm -rf $(call arena,$@)/ncurses $(call log_stage,$@)
	mkdir -p $(call arena,$@)/ncurses $(call log,$@)
	(cd $(call arena,$@)/ncurses \
		&& $(call setenv_cross,$@) \
		&& $(REPODIR)/$(ncurses_DIR)/configure \
			$(call configure_ncurses,$@) \
			$(NCURSES_CONFIGURE_FLAGS_WITH_FALLBACKS) \
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

# Build binutils & gdb
.stage.%.binutils-config: $(BUILD_CROSS)
	echo STAGE: $@
	rm -rf $(call arena,$@)/binutils $(call log_stage,$@)
	mkdir -p $(call arena,$@)/binutils $(call log,$@)
	(cd $(call arena,$@)/binutils \
		&& $(call setenv,$@) \
		&& $(REPODIR)/$(BINUTILS_DIR)/configure \
			$(call configure_binutils,$@) ) $(call log,$@)
	touch $@

BINUTILS_LDFLAGS=

setenv_binutils = \
	export LDFLAGS="$(BINUTILS_LDFLAGS)"

.stage.%.binutils-make: .stage.%.binutils-config
	echo STAGE: $@
	(cd $(call arena,$@)/binutils \
		&& $(call setenv,$@) \
		&& $(call setenv_binutils,$@) \
		&& $(MAKE) \
		&& $(MAKE) install) $(call log_stage,$@)

# attempt to fix dynamic plugins loader by actually building plugins dynamically
# https://github.com/msys2/MINGW-packages/issues/7890
# https://github.com/msys2/MINGW-packages/blob/68f7d4665c396a464536871b1de7b680a47a8fa7/mingw-w64-binutils/PKGBUILD#L150-L151
WIN32_DLLEXT := .dll
WIN64_DLLEXT := .dll

dllext = $(or $($(call arch,$(1))_DLLEXT),.so)

.stage.%.binutils-post: .stage.%.binutils-make
	echo STAGE: $@
ifeq ($(BINUTILS_BRANCH),master)
	touch $@
else ifeq ($(BINUTILS_BRANCH),binutils-2_32)
	touch $@
else
	rm -rf $(call arena,$@)/binutils/ld $(call log_stage,$@)
	mkdir -p $(call arena,$@)/binutils/ld $(call log,$@)
	(cd $(call arena,$@)/binutils/ld \
		&& $(call setenv,$@) \
		&& $(REPODIR)/$(BINUTILS_DIR)/ld/configure \
			$(call configure_binutils,$@) \
			--enable-static=no \
			--enable-shared \
		&& $(MAKE) \
		&& cp -v .libs/libdep$(call dllext,$@) \
			$(call install,$@)/lib/bfd-plugins/ ) $(call log,$@)
	touch $@
endif

.stage.%.gdb-config: $(BUILD_CROSS)
	echo STAGE: $@
	rm -rf $(call arena,$@)/gdb $(call log_stage,$@)
	mkdir -p $(call arena,$@)/gdb $(call log,$@)
	(cd $(call arena,$@)/gdb \
		&& $(call setenv,$@) \
		&& $(call setenv_gdb,$@) \
		&& $(REPODIR)/$(BINUTILS_DIR)/configure \
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
	(cd $(call arena,$@)/gdb \
		&& $(call setenv,$@) \
		&& $(call setenv_binutils,$@) \
		&& $(call setenv_gdb,$@) \
		&& $(MAKE) \
		&& $(MAKE) install) $(call log_stage,$@)
	touch $@

# statically link w/ build host gcc & libstdc++
# TODO: c1a5d03a89a455d79f025c66dce83342de4d26ce introduces --with-static-standard-libraries
# TODO: actually useful for binutils as a whole OR as OR ld OR ... ?
.stage.WIN32.binutils-make .stage.WIN32.gdb-make: BINUTILS_LDFLAGS=-static-libgcc -static-libstdc++
.stage.WIN64.binutils-make .stage.WIN64.gdb-make: BINUTILS_LDFLAGS=-static-libgcc -static-libstdc++

.stage.%.gcc1-config: .stage.%.binutils-post .stage.%.gdb-make
	echo STAGE: $@
	rm -rf $(call arena,$@)/$(gcc_DIR) $(call log_stage,$@)
	mkdir -p $(call arena,$@)/$(gcc_DIR) $(call log,$@)
	(cd $(call arena,$@)/$(gcc_DIR) \
		&& $(call setenv,$@) \
		&& $(REPODIR)/$(gcc_DIR)/configure \
			$(CONFIGURE_EH_POOL) \
			$(call configure_with_gmp,$@) \
			$(call configure_with_isl,$@) \
			$(call configure_target,$@) ) $(call log,$@)
	touch $@

.stage.%.gcc1-make: .stage.%.gcc1-config
	echo STAGE: $@
	(cd $(call arena,$@)/$(gcc_DIR) \
		&& $(call setenv,$@) \
		&& $(MAKE) all-gcc \
		&& $(MAKE) install-gcc) $(call log_stage,$@)
	(cd $(call install,$@)/bin \
		&& ln -sf \
			$(TARGET_ARCH)-gcc$(call exe,$@) \
			$(TARGET_ARCH)-cc$(call exe,$@)) $(call log,$@)
	touch $@

.stage.%.newlib-config: .stage.%.gcc1-make
	echo STAGE: $@
	rm -rf $(call arena,$@)/newlib $(call log_stage,$@)
	mkdir -p $(call arena,$@)/newlib $(call log,$@)
	(cd $(call arena,$@)/newlib \
		&& $(call setenv,$@) \
		&& $(REPODIR)/$(newlib_DIR)/configure \
			$(call configure_newlib,$@)) $(call log,$@)
	touch $@

# generates newlib aka libc and hal installations at the install root
# even though these don't have to be rebuilt per target, its fairly short and also verifies that the compiler actually works
.stage.%.newlib-make: .stage.%.newlib-config
	echo STAGE: $@
	(cd $(call arena,$@)/newlib \
		&& $(call setenv,$@) \
		&& $(MAKE) \
		&& $(MAKE) install ) $(call log_stage,$@)
	touch $@

.stage.%.hal-config: .stage.%.newlib-make
	echo STAGE: $@
	rm -rf $(call arena,$@)/lx106-hal $(call log_stage,$@)
	mkdir -p $(call arena,$@)/lx106-hal $(call log,$@)
	# note the CC=... to override possibly injected variable after calling 'configure'
	(cd $(call arena,$@)/lx106-hal \
		&& $(call setenv,$@) \
		&& $(REPODIR)/$(lx106-hal_DIR)/configure \
			$(call configure_target,$@) \
			CC=$(TARGET_ARCH)-gcc \
			--target=$(TARGET_ARCH) \
			--host=$(TARGET_ARCH) ) $(call log,$@)
	touch $@

# nb. override prefix to ONLY place hal .a into the target arch directory, don't copy to BOTH system-wide and target
.stage.%.hal-make: .stage.%.hal-config
	echo STAGE: $@
	(cd $(call arena,$@)/lx106-hal \
		&& $(call setenv,$@) \
		&& $(MAKE) && $(MAKE) \
			prefix=$(call install,$@)/$(TARGET_ARCH) \
			exec_prefix=$(call install,$@)/$(TARGET_ARCH) \
			install ) $(call log_stage,$@)
	touch $@

.stage.%.libstdcpp: .stage.%.hal-make
	echo STAGE: $@
	# stage 2 (build libstdc++)
	(cd $(call arena,$@)/$(gcc_DIR) \
		&& $(call setenv,$@) \
		&& $(MAKE) && $(MAKE) install ) $(call log_stage,$@)
	touch $@

.stage.%.libstdcpp-nox: .stage.%.libstdcpp
	echo STAGE: $@
	# We copy existing stdc, adjust the makefile, and build a single .a to save much time
	rm -rf $(call arena,$@)/$(gcc_DIR)/$(TARGET_ARCH)/libstdc++-v3-nox $(call log_stage,$@)
	(cd $(call arena,$@)/$(gcc_DIR)/$(TARGET_ARCH) \
		&& cp -a libstdc++-v3 libstdc++-v3-nox) $(call log,$@)
	(cd $(call arena,$@)/$(gcc_DIR)/$(TARGET_ARCH)/libstdc++-v3-nox \
		&& $(call setenv,$@) \
		&& $(MAKE) clean \
		&& find . -name Makefile -exec sed -i 's/mlongcalls/mlongcalls -fno-exceptions/' \{\} \; \
		&& $(MAKE)) $(call log,$@)
	(cd $(TARGET_ARCH)$(call ext,$@)/$(TARGET_ARCH)/lib/ \
		&& cp libstdc++.a libstdc++-exc.a \
		&& cp $(call arena,$@)/$(gcc_DIR)/$(TARGET_ARCH)/libstdc++-v3-nox/src/.libs/libstdc++.a ./) $(call log,$@)
	touch $@

.stage.%.strip: .stage.%.libstdcpp-nox
	echo STAGE: $@
	($(call setenv_cross,$@) \
		&& $$STRIP \
			$(call install,$@)/bin/*$(call exe,$@) \
			$(call install,$@)/lib/bfd-plugins/* \
			$(call install,$@)/libexec/gcc/$(TARGET_ARCH)/*/c*$(call exe,$@) \
			$(call install,$@)/libexec/gcc/$(TARGET_ARCH)/*/lto1$(call exe,$@) ) || true $(call log_stage,$@)
	touch $@

.stage.%.post: .stage.%.strip
	echo STAGE: $@
	for sh in $(POSTDIR)/gcc$(GCC)-*.sh $(POSTDIR)/gcc$(GCC_MAJOR)-*.sh; do \
	    [ -x "$${sh}" ] || continue ; \
		(set -x; $${sh} $(call ext,$@)) ; \
	done $(call log_stage,$@)
	touch $@

.stage.%.package: .stage.%.post
	echo STAGE: $@
	mkdir -p $(PKGDIR) $(call log_stage,$@)
	rm -rf $(PKGDIR)/pkg.$(call arch,$@) $(call log,$@)
	mkdir -p $(PKGDIR)/pkg.$(call arch,$@) $(call log,$@)
	cp -a $(call install,$@) $(PKGDIR)/pkg.$(call arch,$@)/$(TARGET_ARCH) $(call log,$@)
	(cd $(PKGDIR)/pkg.$(call arch,$@)/$(TARGET_ARCH) \
		&& $(call make_package_json,toolchain-xtensa,xtensa-gcc,$(call asys,$@)) ) $(call log,$@)
	(tarball=$(call tarball,$@) \
	    && cd $(PKGDIR)/pkg.$(call arch,$@) \
		&& $(call tarcmd,$@) $(call taropt,$@) $(PKGDIR)/$${tarball} $(TARGET_ARCH)/ \
		&& cd $(PKGDIR) \
		&& $(call make_releases_json,$$tarball,$(call ahost,$@)) ) $(call log,$@)
	rm -rf $(PKGDIR)/pkg.$(call arch,$@) $(call log,$@)
	touch $@

# packaged tools depend only on the host toolchain

.stage.%.mkspiffs:
	echo STAGE: $@
	mkdir -p $(PKGDIR) $(call log_stage,$@)
	rm -rf $(call arena,$@)/mkspiffs $(call log,$@)
	mkdir -p $(call arena,$@)/mkspiffs $(call log,$@)
	cp -a $(REPODIR)/$(mkspiffs_DIR) $(call arena,$@)/ $(call log,$@)
	# Dependencies borked in mkspiffs makefile, so don't use parallel make
	(cd $(call arena,$@)/$(mkspiffs_DIR) \
	    && $(call setenv_cross,$@) \
	    && $(MAKE) -j1 TARGET_OS=$(call mktgt,$@) \
			BUILD_CONFIG_NAME="-arduino-esp8266" \
			CPPFLAGS="-DSPIFFS_USE_MAGIC_LENGTH=0 -DSPIFFS_ALIGNED_OBJECT_INDEX_TABLES=1" \
            mkspiffs$(call exe,$@)) $(call log,$@)
	rm -rf $(PKGDIR)/pkg.mkspiffs.$(call arch,$@) $(call log,$@)
	mkdir -p $(PKGDIR)/pkg.mkspiffs.$(call arch,$@)/mkspiffs $(call log,$@)
	(cd $(PKGDIR)/pkg.mkspiffs.$(call arch,$@)/mkspiffs \
		&& $(call make_package_json,mkspiffs,mkspiffs-utility,$(call asys,$@)) ) $(call log,$@)
	cp $(call arena,$@)/mkspiffs/mkspiffs$(call exe,$@) $(PKGDIR)/pkg.mkspiffs.$(call arch,$@)/mkspiffs/. $(call log,$@)
	(tarball=$(call host,$@).mkspiffs-$$(cd $(REPODIR)/$(mkspiffs_DIR) \
		&& git rev-parse --short HEAD).$(STAMP).$(call tarext,$@) \
	    && cd $(PKGDIR)/pkg.mkspiffs.$(call arch,$@) && $(call tarcmd,$@) $(call taropt,$@) $(PKGDIR)/$${tarball} mkspiffs \
		&& cd $(PKGDIR) && $(call make_releases_json,$$tarball,$(call ahost,$@)) ) $(call log,$@)
	rm -rf $(PKGDIR)/pkg.mkspiffs.$(call arch,$@) $(call log,$@)
	touch $@

.stage.%.mklittlefs:
	echo STAGE: $@
	mkdir -p $(PKGDIR) $(call log_stage,$@)
	rm -rf $(call arena,$@)/mklittlefs $(call log,$@)
	mkdir -p $(call arena,$@)/mklittlefs $(call log,$@)
	cp -a $(REPODIR)/mklittlefs $(call arena,$@)/ $(call log,$@)
	# Dependencies borked in mklittlefs makefile, so don't use parallel make
	(cd $(call arena,$@)/mklittlefs \
	    && $(call setenv_cross,$@) \
	    && $(MAKE) -j1 TARGET_OS=$(call mktgt,$@) \
			BUILD_CONFIG_NAME="-arduino-esp8266" \
            mklittlefs$(call exe,$@)) $(call log,$@)
	rm -rf $(PKGDIR)/pkg.mklittlefs.$(call arch,$@) $(call log,$@)
	mkdir -p $(PKGDIR)/pkg.mklittlefs.$(call arch,$@)/mklittlefs $(call log,$@)
	(cd $(PKGDIR)/pkg.mklittlefs.$(call arch,$@)/mklittlefs \
		&& $(call make_package_json,mklittlefs,littlefs-utility,$(call asys,$@)) ) $(call log,$@)
	cp $(call arena,$@)/mklittlefs/mklittlefs$(call exe,$@) $(PKGDIR)/pkg.mklittlefs.$(call arch,$@)/mklittlefs/. $(call log,$@)
	(tarball=$(call host,$@).mklittlefs-$$(cd $(REPODIR)/mklittlefs \
		&& git rev-parse --short HEAD).$(STAMP).$(call tarext,$@) \
	    && cd $(PKGDIR)/pkg.mklittlefs.$(call arch,$@) && $(call tarcmd,$@) $(call taropt,$@) $(PKGDIR)/$${tarball} mklittlefs \
		&& cd $(PKGDIR) && $(call make_releases_json,$$tarball,$(call ahost,$@)) ) $(call log,$@)
	rm -rf $(PKGDIR)/pkg.mklittlefs.$(call arch,$@) $(call log,$@)
	touch $@

# TODO still packaged, but esptool-ck was deprecated in favour of esptool-py a long time ago
.stage.%.esptool:
	echo STAGE: $@
	mkdir -p $(PKGDIR) $(call log_stage,$@)
	rm -rf $(call arena,$@)/esptool $(call log,$@)
	mkdir -p $(call arena,$@)/esptool $(call log,$@)
	cp -a $(REPODIR)/esptool $(call arena,$@)/ $(call log,$@)
	# Dependencies borked in esptool makefile, so don't use parallel make
	(cd $(call arena,$@)/esptool \
	    && $(call setenv_cross,$@) \
	    && $(MAKE) -j1 TARGET_OS=$(call mktgt,$@) \
			BUILD_CONFIG_NAME="-arduino-esp8266" \
            esptool$(call exe,$@)) $(call log,$@)
	rm -rf $(PKGDIR)/pkg.esptool.$(call arch,$@) $(call log,$@)
	mkdir -p $(PKGDIR)/pkg.esptool.$(call arch,$@)/esptool $(call log,$@)
	cp $(call arena,$@)/esptool/esptool$(call exe,$@) $(PKGDIR)/pkg.esptool.$(call arch,$@)/esptool/. $(call log,$@)
	(tarball=$(call host,$@).esptool-$$(cd $(REPODIR)/esptool \
		&& git rev-parse --short HEAD).$(STAMP).$(call tarext,$@) \
	    && cd $(PKGDIR)/pkg.esptool.$(call arch,$@) && $(call tarcmd,$@) $(call taropt,$@) $(PKGDIR)/$${tarball} esptool \
		&& cd $(PKGDIR) && $(call make_releases_json,$$tarball,$(call ahost,$@)) ) $(call log,$@)
	rm -rf $(PKGDIR)/pkg.esptool.$(call arch,$@) $(call log,$@)
	touch $@

.PHONY: .arduino.%

.arduino.checkout:
	echo "-------- Preparing Arduino repo at $(ARDUINO)"
	test -d $(ARDUINO) || git clone https://github.com/$(GHUSER)/Arduino $(ARDUINO)
	(cd $(ARDUINO) \
		&& git clean -x -f -d \
		&& git fetch origin $(INSTALLBRANCH) \
		&& git checkout $(INSTALLBRANCH) \
		&& git submodule init \
		&& git submodule update)

.arduino.toolchain:
	echo "-------- Copying GCC and LIBSTDC++ libs"
	cp -vu \
		$(call install,$@)/$(TARGET_ARCH)/lib/libstdc++-exc.a \
		$(call install,$@)/$(TARGET_ARCH)/lib/libstdc++.a \
		$(ARDUINO)/tools/sdk/lib/.
	echo "-------- Copying toolchain directory"
	rm -rf $(ARDUINO)/tools/sdk/$(TARGET_ARCH)
	cp -va $(call install,$@)/$(TARGET_ARCH) \
		$(ARDUINO)/tools/sdk/$(TARGET_ARCH)

.arduino.hal:
	echo "-------- Copying HAL lib"
	cp -vu \
		$(call install,$@)/$(TARGET_ARCH)/lib/libhal.a \
		$(ARDUINO)/tools/sdk/lib/.

ARDUINO_PACKAGE_JSON := $(ARDUINO)/package/package_esp8266com_index.template.json

.arduino.package-template-json:
	echo "-------- Updating package template.json"
	./patch_json.py --pkgfile "$(ARDUINO_PACKAGE_JSON)" --tool $(TARGET_ARCH)-gcc --ver "$(RELEASES_JSON_FULLVER)" --glob '$(PKGDIR)/*$(TARGET_ARCH)*.json'
	./patch_json.py --pkgfile "$(ARDUINO_PACKAGE_JSON)" --tool esptool --ver "$(RELEASES_JSON_FULLVER)" --glob '$(PKGDIR)/*esptool*.json'
	./patch_json.py --pkgfile "$(ARDUINO_PACKAGE_JSON)" --tool mkspiffs --ver "$(RELEASES_JSON_FULLVER)" --glob '$(PKGDIR)/*mkspiffs*.json'
	./patch_json.py --pkgfile "$(ARDUINO_PACKAGE_JSON)" --tool mklittlefs --ver "$(RELEASES_JSON_FULLVER)" --glob '$(PKGDIR)/*mklittlefs*.json'

.arduino.build:
	echo "-------- Installing toolchain"
	(cd $(ARDUINO)/tools \
		&& tar xf $(REPODIR)/$(call tarball,$@))
	echo "-------- Building and installing BearSSL"
	(cd $(ARDUINO)/tools/sdk/ssl \
		&& make clean && make all && make install)
	echo "-------- Building and installing LWIP2"
	(cd $(ARDUINO)/tools/sdk/lwip2 \
		&& make clean && make install)
	echo "-------- Building eboot.elf"
	(cd $(ARDUINO)/bootloaders/eboot \
		&& make clean && make)

# Only the native version has to be done to install libs to GIT
.PHONY: install
install: .stage.LINUX.done
	echo STAGE: $@
	$(MAKE) .arduino.checkout
	$(MAKE) .arduino.toolchain
	$(MAKE) .arduino.hal
	$(MAKE) .arduino.package-template-json
	$(MAKE) .arduino.build
	touch $@

# Upload a draft toolchain release
.PHONY: upload
upload: $(BUILD_DONE)
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
