mkdir ./build
cd ./build

HOST_PY_VER=`python -c 'import sys; print(str(sys.version_info[0])+"."+str(sys.version_info[1]))'`

if [ ! -d "${PREFIX}/include/python${HOST_PY_VER}" ]; then
    HOST_PY_VER="${HOST_PY_VER}m"
fi

if [ `uname` == Darwin ]; then
    PY_LIB="libpython${HOST_PY_VER}.dylib"
    sed -i '' 's/${PYTHON_LIBRARY}//g' $SRC_DIR/src/chrono_python/CMakeLists.txt
    sed -i '' 's/${AVX_FLAGS}//g' $SRC_DIR/src/chrono_python/CMakeLists.txt
    sed -i '' 's/${SSE_FLAGS}//g' $SRC_DIR/src/chrono_python/CMakeLists.txt
    sed -i '' 's/${NEON_FLAGS}//g' $SRC_DIR/src/chrono_python/CMakeLists.txt
    sed -i '' 's/${FMA_FLAGS}//g' $SRC_DIR/src/chrono_python/CMakeLists.txt
else
    PY_LIB="libpython${HOST_PY_VER}.so"
    sed -i 's/${PYTHON_LIBRARY}//g' $SRC_DIR/src/chrono_python/CMakeLists.txt
    sed -i 's/${AVX_FLAGS}//g' $SRC_DIR/src/chrono_python/CMakeLists.txt
    sed -i 's/${SSE_FLAGS}//g' $SRC_DIR/src/chrono_python/CMakeLists.txt
    sed -i 's/${NEON_FLAGS}//g' $SRC_DIR/src/chrono_python/CMakeLists.txt
    sed -i 's/${FMA_FLAGS}//g' $SRC_DIR/src/chrono_python/CMakeLists.txt
fi

export LDFLAGS="-Wl,-undefined,dynamic_lookup $LDFLAGS"

CONFIGURATION=Release
# Configure step
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_SYSTEM_PREFIX_PATH=$PREFIX \
      -DCH_INSTALL_PYTHON_PACKAGE=lib/python$HOST_PY_VER/site-packages \
      -DPYTHON_EXECUTABLE:FILEPATH=$PYTHON \
      -DPYTHON_INCLUDE_DIR:PATH=$PREFIX/include/python$HOST_PY_VER \
      -DPYTHON_LIBRARY:FILEPATH=$PREFIX/lib/${PY_LIB} \
      -DCMAKE_BUILD_TYPE=$CONFIGURATION \
      -DENABLE_MODULE_IRRLICHT:BOOL=OFF \
      -DENABLE_MODULE_POSTPROCESS:BOOL=ON \
      -DENABLE_MODULE_VEHICLE:BOOL=ON \
      -DENABLE_MODULE_PYTHON:BOOL=ON \
      -DBUILD_DEMOS:BOOL=OFF \
      -DBUILD_TESTING:BOOL=OFF \
      -DBUILD_BENCHMARKING:BOOL=OFF \
      -DENABLE_MODULE_CASCADE:BOOL=OFF \
      -DENABLE_MODULE_MKL:BOOL=OFF \
      -DEIGEN3_INCLUDE_DIR:PATH=$PREFIX/include/eigen3 \
      -DENABLE_UNIT_CASCADE:BOOL=OFF \
      -DENABLE_MODULE_FSI:BOOL=ON \
      -DENABLE_OPENMP:BOOL=ON \
      -DENABLE_MODULE_COSIMULATION:BOOL=OFF \
      -DENABLE_MODULE_MATLAB:BOOL=OFF \
      -DENABLE_MODULE_PARALLEL:BOOL=OFF \
      -DENABLE_MODULE_OPENGL:BOOL=OFF \
      -DENABLE_MODULE_OGRE:BOOL=OFF \
      ./..

# Build step
# on linux travis, limit the number of concurrent jobs otherwise
# gcc gets out of memory
cmake --build . --config "$CONFIGURATION"

cmake --build . --config "$CONFIGURATION" --target install
