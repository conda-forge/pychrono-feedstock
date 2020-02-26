mkdir ./build_lib
cd ./build_lib


if [ `uname` == Darwin ]; then
    sed -i '' 's/find_package(AVX)//g' $SRC_DIR/src/CMakeLists.txt
    sed -i '' 's/find_package(SSE)//g' $SRC_DIR/src/CMakeLists.txt
    sed -i '' 's/find_package(NEON)//g' $SRC_DIR/src/CMakeLists.txt
    sed -i '' 's/find_package(FMA)//g' $SRC_DIR/src/CMakeLists.txt
    sed -i '' 's/find_package(OpenMP)//g' $SRC_DIR/src/CMakeLists.txt
else
    sed -i 's/find_package(AVX)//g' $SRC_DIR/src/CMakeLists.txt
    sed -i 's/find_package(SSE)//g' $SRC_DIR/src/CMakeLists.txt
    sed -i 's/find_package(NEON)//g' $SRC_DIR/src/CMakeLists.txt
    sed -i 's/find_package(FMA)//g' $SRC_DIR/src/CMakeLists.txt
    sed -i 's/find_package(OpenMP)//g' $SRC_DIR/src/CMakeLists.txt
fi

export LDFLAGS="-Wl,-undefined,dynamic_lookup $LDFLAGS"

CONFIGURATION=Release
# Configure step
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_SYSTEM_PREFIX_PATH=$PREFIX \
      -DCMAKE_BUILD_TYPE=$CONFIGURATION \
      -DENABLE_MODULE_IRRLICHT:BOOL=OFF \
      -DENABLE_MODULE_POSTPROCESS:BOOL=ON \
      -DENABLE_MODULE_VEHICLE:BOOL=ON \
      -DENABLE_MODULE_PYTHON:BOOL=OFF \
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
