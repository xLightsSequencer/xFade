PREFIX          = /usr

export PKG_CONFIG_PATH := $(if $(PKG_CONFIG_PATH),$(PKG_CONFIG_PATH):$(PREFIX)/lib/pkgconfig/,$(PREFIX)/lib/pkgconfig)
export PATH := $(PATH):$(PREFIX)/bin

IGNORE_WARNINGS = -Wno-reorder -Wno-sign-compare -Wno-unused-variable -Wno-unused-but-set-variable -Wno-unused-function -Wno-unknown-pragmas

MKDIR           = mkdir -p
CHK_DIR_EXISTS  = test -d
INSTALL_PROGRAM = install -m 755 -p
DEL_FILE        = rm -f
SUDO            = `which sudo`

WXWIDGETS_TAG=xlights_2026.04

.NOTPARALLEL:

all: wxwidgets33 cbp2make makefile xFade

#############################################################################

xFade: FORCE
	@${MAKE} -C xFade -f xFade.cbp.mak OBJDIR_LINUX_DEBUG=".objs_debug" linux_release

#############################################################################

debug: makefile xFade_debug

xFade_debug:
	@${MAKE} -C xFade -f xFade.cbp.mak OBJDIR_LINUX_DEBUG=".objs_debug" linux_debug

#############################################################################

clean:
	@if test -f xFade/xFade.cbp.mak; then \
		${MAKE} -C xFade -f xFade.cbp.mak OBJDIR_LINUX_DEBUG=".objs_debug" clean; \
		$(DEL_FILE) xFade/xFade.cbp.mak xFade/xFade.cbp.mak.orig; \
	fi

#############################################################################

install:
	@$(CHK_DIR_EXISTS) $(DESTDIR)/${PREFIX}/bin || $(MKDIR) $(DESTDIR)/${PREFIX}/bin
	-$(INSTALL_PROGRAM) -D bin/xFade $(DESTDIR)/${PREFIX}/bin/xFade
	-$(INSTALL_PROGRAM) -D bin/xfade.desktop $(DESTDIR)/${PREFIX}/share/applications/xfade.desktop

uninstall:
	-$(DEL_FILE) $(DESTDIR)/${PREFIX}/bin/xFade
	-$(DEL_FILE) $(DESTDIR)/${PREFIX}/share/applications/xfade.desktop

#############################################################################

wxwidgets33: FORCE
	@printf "Checking wxwidgets\n"
	@if test -n "`wx-config --version 2>/dev/null`"; then \
		echo "wxWidgets already installed: `wx-config --version`"; \
	elif test ! -d wxWidgets-$(WXWIDGETS_TAG); then \
		echo Downloading wxwidgets; \
		git clone --depth=1 --shallow-submodules --recurse-submodules -b $(WXWIDGETS_TAG) https://github.com/xLightsSequencer/wxWidgets wxWidgets-$(WXWIDGETS_TAG); \
		cd wxWidgets-$(WXWIDGETS_TAG); \
		./configure --enable-cxx11 --with-cxx=17 --enable-std_containers --enable-std_string_conv_in_wxstring --enable-backtrace --enable-exceptions --enable-mediactrl --enable-graphics_ctx --enable-monolithic --disable-sdltest --with-gtk=3 --disable-pcx --disable-iff --without-libtiff --enable-utf8 --enable-utf8only --prefix=$(PREFIX); \
		echo Building wxwidgets; \
		${MAKE} -j 4 -s; \
		echo Installing wxwidgets; \
		$(SUDO) ${MAKE} install DESTDIR=$(DESTDIR); \
		echo Completed build/install of wxwidgets; \
	fi

cbp2make:
	@if test -n "`cbp2make --version`"; \
		then $(DEL_FILE) xFade/xFade.cbp.mak; \
	fi

makefile: xFade/xFade.cbp.mak

xFade/xFade.cbp.mak: xFade/xFade.cbp
	@cbp2make -in xFade/xFade.cbp -cfg cbp2make.cfg -out xFade/xFade.cbp.mak \
			--with-deps --keep-outdir --keep-objdir
	@cp xFade/xFade.cbp.mak xFade/xFade.cbp.mak.orig
	@cat xFade/xFade.cbp.mak.orig \
		| sed \
			-e "s/CFLAGS_LINUX_RELEASE = \(.*\)/CFLAGS_LINUX_RELEASE = \1 $(IGNORE_WARNINGS)/" \
			-e "s/OBJDIR_LINUX_DEBUG = \(.*\)/OBJDIR_LINUX_DEBUG = .objs_debug/" \
		> xFade/xFade.cbp.mak

#############################################################################

FORCE:
