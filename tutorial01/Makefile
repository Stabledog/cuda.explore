# Makefile for tutorial01
SHELL=/bin/bash
.ONESHELL:
.SUFFIXES:
.SHELLFLAGS = -uec
MAKEFLAGS += --no-builtin-rules --no-print-directory

absdir := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

# Should be in /usr/local/cuda/bin:
Nvcc = $(CUDA_HOME)/bin/nvcc

out/cuda_hello_c: cuda_hello.c
	g++ -o $@ $<

out/cuda_hello_cu: cuda_hello.cu
	$(Nvcc) -o $@ $<

out/.init:
	mkdir -p $@

.PHONY: build
build: out/.init out/cuda_hello_c out/cuda_hello_cu
