# Makefile for cuda.explore
SHELL=/bin/bash
.ONESHELL:
.SUFFIXES:
.SHELLFLAGS = -uec
MAKEFLAGS += --no-builtin-rules --no-print-directory

absdir := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

Flag=$(absdir)flag

Config: $(Flag)/.init
	@cat <<-EOF
	absdir=$(absdir)
	Flag=$(Flag)
	Flags="$(shell cd $(Flag); ls)"
	EOF

$(Flag)/.init:
	@mkdir -p $(Flag)
	touch $@

$(Flag)/cuda-toolkit-dpkg:
	@ # See https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=WSL-Ubuntu&target_version=2.0&target_type=deb_network
	cd $(absdir)
	mkdir -p tmp
	cd tmp
	pkg=cuda-keyring_1.1-1_all.deb
	wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/$$pkg
	sudo dpkg -i $$pkg
	sudo apt-get update
	sudo apt-get -y install cuda-toolkit-12-3
	rm $$pkg
	touch $@

setup: $(Flag)/setup
$(Flag)/setup: $(Flag)/cuda-toolkit-dpkg
	touch $@
