ifeq ($(SRCDIR),)
	SRCDIR=$(shell pwd)
endif

OUTPUT:=$(SRCDIR)/output

ifeq ($(PREFIX),)
	PREFIX=/usr
endif

ifeq ($(RIME_DATA_DIR),)
	RIME_DATA_DIR=$(PREFIX)/share/rime-data
endif

all preset: clean
	$(SRCDIR)/scripts/select-packages.sh :$@ $(OUTPUT)
	@if [[ -n "$$BRISE_BUILD_BINARIES" ]]; then \
	  $(MAKE) build; \
	fi

build:
	rime_deployer --build $(OUTPUT)

install:
	@echo "installing rime data to '$(DESTDIR)$(RIME_DATA_DIR)'."
	@install -d $(DESTDIR)$(RIME_DATA_DIR)
	@install -m 644 $(OUTPUT)/*.* $(DESTDIR)$(RIME_DATA_DIR)

clean:
	rm -rf $(OUTPUT) > /dev/null 2>&1 || true

.PHONY: all preset build install clean
