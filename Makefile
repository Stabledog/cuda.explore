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
	CudaUrl="https://docs.nvidia.com/cuda/"
	CudaWslUrl="https://docs.nvidia.com/cuda/wsl-user-guide/index.html"
	EOF

$(Flag)/.init:
	@mkdir -p $(Flag)
	touch $@

$(Flag)/windows-driver:
	@
	cat <<-EOF
	Have you already installed the appropriate Windows NVIDIA driver for the host OS?
	If not, see https://docs.nvidia.com/cuda/wsl-user-guide/index.html and do that.

	WARNING: do not install any *LINUX* GPU driver.  (WSL borrows the Windows driver.)

	EOF
	read -p "Enter 'yes' to update the flag for this task when complete: "
	case $$REPLY in
		YES|yes) touch $@; exit;;
		*) echo "Exiting with fail." ; exit 19;;
	esac


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

$(Flag)/cuda.bashrc:
	@ # hook into the PATH, etc.:
	set +u
	[[ -n $$CUDA_HOME ]] && exit 0
	set -u
	cat <<-"EOF" > $@.tmp
	# Generated by $(absdir)Makefile -> $(@F)
	export CUDA_HOME=/usr/local/cuda
	PATH=$$CUDA_HOME/bin:$$PATH
	export LD_LIBRARY_PATH=$${CUDA_HOME}/lib64:$$LD_LIBRARY_PATH
	EOF
	echo 'source $@' >> $(HOME)/.bashrc
	mv $@.tmp $@

.PHONY: .gpu-debugger-enabled
.gpu-debugger-enabled:
	set -x
	powershell.exe -Command "Get-ItemProperty -Path  'HKLM:\SOFTWARE\NVIDIA Corporation\GPUDebugger\'  -Name EnableInterface | Select-Object -ExpandProperty EnableInterface" || {
		echo "ERROR: GPUDebugger is not enabled in the Windows registry. Set HKLM:/SOFTWARE/NVIDIA Corporation/GPUDebugger/EnableInterface to 0x00000001 and try again."
		exit 19
	}



setup: $(Flag)/setup
$(Flag)/setup: $(Flag)/windows-driver $(Flag)/cuda-toolkit-dpkg $(Flag)/cuda.bashrc .gpu-debugger-enabled
	touch $@

