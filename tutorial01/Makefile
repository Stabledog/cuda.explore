# Makefile for tutorial01
SHELL=/bin/bash
.ONESHELL:
.SUFFIXES:
.SHELLFLAGS = -uec
MAKEFLAGS += --no-builtin-rules --no-print-directory

absdir := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

# Should be in /usr/local/cuda/bin:
Nvcc = $(CUDA_HOME)/bin/nvcc
CudaGdb = $(CUDA_HOME)/bin/cuda-gdb

out/vector_add_c: vector_add.c
	g++ -g -o $@ $<

out/vector_add_cu: vector_add.cu
	$(Nvcc) -g -G -o $@ $<

out/.init:
	mkdir -p $@

.PHONY: build
build: out/.init out/vector_add_c out/vector_add_cu

debug:
	@$(CudaGdb) --args out/vector_add_cu

clean:
	@rm -rf out || :
