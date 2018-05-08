ifeq ($(SRCDIR),)
	SRCDIR=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
endif

# Tips: you can set OUTPUT to Rime user directory in the command line
ifeq ($(OUTPUT),)
	OUTPUT:=$(SRCDIR)/output
endif

ifeq ($(PREFIX),)
	PREFIX=/usr
endif

ifeq ($(RIME_DATA_DIR),)
	RIME_DATA_DIR=$(PREFIX)/share/rime-data
endif

preset extra all: clean
	bash $(SRCDIR)/scripts/install-packages.sh :$@ $(OUTPUT)
	@if [[ -n "$$build_bin" ]]; then \
	  $(MAKE) build; \
	fi

minimal: clean
	bash $(SRCDIR)/scripts/minimal-build.sh $(OUTPUT)

build:
	rime_deployer --build $(OUTPUT)
	rm $(OUTPUT)/user.yaml

install:
	@echo "Installing Rime data to '$(DESTDIR)$(RIME_DATA_DIR)'."
	@install -d $(DESTDIR)$(RIME_DATA_DIR)
	@install -m 644 $(OUTPUT)/*.* $(DESTDIR)$(RIME_DATA_DIR)
	@if [[ -d "$(OUTPUT)/build" ]]; then \
	  install -d $(DESTDIR)$(RIME_DATA_DIR)/build; \
	  install -m 644 $(OUTPUT)/build/*.* $(DESTDIR)$(RIME_DATA_DIR)/build; \
	fi

clean:
	rm -rf $(OUTPUT) > /dev/null 2>&1 || true

.PHONY: preset extra all minimal build install clean
