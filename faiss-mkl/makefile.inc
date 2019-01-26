# Copyright (c) 2015-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the BSD+Patents license found in the
# LICENSE file in the root directory of this source tree.

CXX          = g++-7 -std=c++11
CXXCPP       = g++-7 -std=c++11 -E
# TODO: Investigate the LAPACKE wrapper for LAPACK, which defines the correct
#   type for FORTRAN integers.
CPPFLAGS     = -DFINTEGER=long
CXXFLAGS     = -fPIC -fopenmp -m64 -Wno-sign-compare -g -O3 -Wall -Wextra
CPUFLAGS     = -msse4 -mpopcnt
LDFLAGS      = -fopenmp
LDFLAGS      += -Wl,--no-as-needed -L/opt/intel/mkl/lib/intel64
LIBS         = -lmkl_intel_lp64 -lmkl_gnu_thread -lmkl_core -lgomp -lpthread -lm -ldl
PYTHONCFLAGS = -I/usr/include/python3.7m -I/usr/include/python3.7m -I/usr/lib/python3.7/site-packages/numpy/core/include

NVCC         = /opt/cuda/bin/nvcc
NVCCLDFLAGS  = -L/opt/cuda/lib64
NVCCLIBS     = -lcudart -lcublas -lcuda
CUDAROOT     = /opt/cuda
CUDACFLAGS   = -I/opt/cuda/include
NVCCFLAGS    = -I $(CUDAROOT)/include/ \
-Xcompiler -fPIC \
-Xcudafe --diag_suppress=unrecognized_attribute \
-gencode arch=compute_35,code="compute_35" \
-gencode arch=compute_52,code="compute_52" \
-gencode arch=compute_60,code="compute_60" \
-gencode arch=compute_61,code="compute_61" \
-lineinfo \
-ccbin $(CXX) -DFAISS_USE_FLOAT16

OS = $(shell uname -s)

SHAREDEXT   = so
SHAREDFLAGS = -shared

ifeq ($(OS),Darwin)
	SHAREDEXT   = dylib
	SHAREDFLAGS = -dynamiclib -undefined dynamic_lookup
endif

MKDIR_P      = /usr/bin/mkdir -p
PYTHON       = python
SWIG         = swig

prefix      ?= /usr
exec_prefix ?= ${prefix}
libdir       = ${exec_prefix}/lib
includedir   = ${prefix}/include
