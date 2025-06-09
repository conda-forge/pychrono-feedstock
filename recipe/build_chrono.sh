#!/bin/bash

set -e
set -x

unset CMAKE_GENERATOR
unset CMAKE_GENERATOR_PLATFORM

if [[ ${HOST} =~ .*darwin.* ]]; then
      export LDFLAGS="-Wl,-undefined,dynamic_lookup ${LDFLAGS}"
fi

# Configure step
cmake ${CMAKE_ARGS} \
      -G Ninja \
      -B build \
      -DBUILD_DEMOS:BOOL=OFF \
      -DCH_CONDA_INSTALL:BOOL=ON \
      -DCH_INSTALL_PYTHON_PACKAGE="lib/python${PY_VER}/site-packages" \
      -DCH_PYCHRONO_DATA_PATH:PATH=data \
      -DCH_PYCHRONO_SHADER_PATH:PATH=shader \
      -DENABLE_MODULE_CASCADE:BOOL=OFF \
      -DENABLE_MODULE_FSI:BOOL=ON \
      -DENABLE_MODULE_IRRLICHT:BOOL=OFF \
      -DENABLE_MODULE_MATLAB:BOOL=OFF \
      -DENABLE_MODULE_OPENGL:BOOL=OFF \
      -DENABLE_MODULE_POSTPROCESS:BOOL=OFF \
      -DENABLE_MODULE_PYTHON:BOOL=OFF \
      -DENABLE_MODULE_ROS:BOOL=OFF \
      -DENABLE_MODULE_VEHICLE:BOOL=OFF \
      -DENABLE_OPENMP:BOOL=ON \
      -DUSE_SIMD=OFF \
      .

# Build step
# on linux travis, limit the number of concurrent jobs otherwise
# gcc gets out of memory
cmake --build build -j${CPU_COUNT}
cmake --install build
