# Makefile for tutorial01
SHELL=/bin/bash
.ONESHELL:
.SUFFIXES:
.SHELLFLAGS = -uec
MAKEFLAGS += --no-builtin-rules --no-print-directory

absdir := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

# Should be in /usr/local/cuda/bin:
Nvcc = $(CUDA_HOME)/bin/nvcc

tutorial01: cuda_hello.cu
	@
	$(Nvcc) $< -o $@
