################################################################################
#
# python-gobject
#
################################################################################

PYTHON_GOBJECT_VERSION_MAJOR = 3.36
PYTHON_GOBJECT_VERSION = $(PYTHON_GOBJECT_VERSION_MAJOR).1
PYTHON_GOBJECT_SOURCE = pygobject-$(PYTHON_GOBJECT_VERSION).tar.xz
PYTHON_GOBJECT_SITE = https://ftp.gnome.org/pub/gnome/sources/pygobject/$(PYTHON_GOBJECT_VERSION_MAJOR)
PYTHON_GOBJECT_LICENSE = LGPL-2.1+
PYTHON_GOBJECT_LICENSE_FILES = COPYING
PYTHON_GOBJECT_INSTALL_STAGING = YES
PYTHON_GOBJECT_DEPENDENCIES = \
	gobject-introspection \
	host-pkgconf \
	libglib2 \
	python3

PYTHON_GOBJECT_CONF_OPTS += \
	-Dpycairo=false \
	-Dtests=false

# HACK: PKG_PYTHON_SYSCONFIGDATA_NAME gets evaluated before
#       $(STAGING_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/_sysconfigdata__linux_*.py
#       exists. Always define it to a known value for now until it is fixed on
#       upstream buildroot.
ifeq ($(BR2_aarch64),y)
define PKG_PYTHON_SYSCONFIGDATA_NAME
_sysconfigdata__linux_aarch64-linux-gnu
endef
endif

# A sysconfigdata_name must be manually specified or the resulting .so
# will have a x86_64 prefix, which causes "import gi" to fail.
# A pythonpath must be specified or the host python path will be used resulting
# in a "not a valid python" error.
PYTHON_GOBJECT_CONF_ENV += \
	_PYTHON_SYSCONFIGDATA_NAME=$(PKG_PYTHON_SYSCONFIGDATA_NAME) \
	PYTHONPATH=$(PYTHON3_PATH)

$(eval $(meson-package))
