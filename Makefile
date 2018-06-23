ifeq ($(SRCDIR),)
	SRCDIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
endif

# Tips: you can set OUTPUT to Rime user directory in the command line
ifeq ($(OUTPUT),)
	OUTPUT := $(SRCDIR)/output
endif

ifeq ($(PREFIX),)
	PREFIX := /usr
endif

ifeq ($(RIME_DATA_DIR),)
	RIME_DATA_DIR := $(PREFIX)/share/rime-data
endif

.DEFAULT_GOAL := preset

preset extra all: clean
	bash $(SRCDIR)/scripts/install-packages.sh :$@ $(OUTPUT)

minimal: clean
	bash $(SRCDIR)/scripts/minimal-build.sh $(OUTPUT)

preset-bin: preset build

all-bin: all build

minimal-bin: minimal build

build:
	rime_deployer --build $(OUTPUT)
	rm $(OUTPUT)/user.yaml

install:
	@echo "Installing Rime data to '$(DESTDIR)$(RIME_DATA_DIR)'."
	@install -d $(DESTDIR)$(RIME_DATA_DIR)
	@install -m 644 $(OUTPUT)/*.* $(DESTDIR)$(RIME_DATA_DIR)
	@if [ -d "$(OUTPUT)/build" ]; then \
	  install -d $(DESTDIR)$(RIME_DATA_DIR)/build; \
	  install -m 644 $(OUTPUT)/build/*.* $(DESTDIR)$(RIME_DATA_DIR)/build; \
	fi

clean:
	rm -rf $(OUTPUT) > /dev/null 2>&1 || true

VERSION = $(shell date "+%Y%m%d")

# A source tarball that includes all data packages.
# To reproduce package contents of the release, set `no_update=1`:
#     tar xzf plum-YYYYMMDD.tar.gz
#     cd plum
#     no_update=1 make
#     sudo make install
dist:
	$(MAKE) OUTPUT=$(OUTPUT) all
	tar czf plum-$(VERSION).tar.gz \
	  --exclude=.git \
	  --exclude=output \
	  --exclude='plum-*.tar.gz' \
	  -C .. plum

.PHONY: preset extra all minimal \
	preset-bin all-bin minimal-bin \
	build install clean dist
