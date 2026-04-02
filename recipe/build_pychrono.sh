#!/bin/bash

set -e
set -x

unset CMAKE_GENERATOR
unset CMAKE_GENERATOR_PLATFORM

if [[ ${HOST} =~ .*darwin.* ]]; then
      export LDFLAGS="-Wl,-undefined,dynamic_lookup ${LDFLAGS}"
fi

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  CMAKE_ARGS="${CMAKE_ARGS} -DPython3_EXECUTABLE=$BUILD_PREFIX/bin/python -DPython_EXECUTABLE=$BUILD_PREFIX/bin/python"
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
      -DCH_ENABLE_MODULE_CASCADE:BOOL=OFF \
      -DCH_ENABLE_MODULE_IRRLICHT:BOOL=OFF \
      -DCH_ENABLE_MODULE_MATLAB:BOOL=OFF \
      -DCH_ENABLE_MODULE_POSTPROCESS:BOOL=OFF \
      -DCH_ENABLE_MODULE_PYTHON:BOOL=ON \
      -DCH_ENABLE_MODULE_ROS:BOOL=OFF \
      -DCH_ENABLE_MODULE_VEHICLE:BOOL=OFF \
      -DCH_ENABLE_OPENMP:BOOL=ON \
      -DCH_USE_SIMD=OFF \
      .

# Build step
# on linux travis, limit the number of concurrent jobs otherwise
# gcc gets out of memory
cmake --build build -j${CPU_COUNT}
cmake --install build
