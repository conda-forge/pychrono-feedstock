@echo on

cmake %CMAKE_ARGS% ^
      -G Ninja ^
      -B build ^
      -DBUILD_DEMOS:BOOL=OFF ^
      -DCH_CONDA_INSTALL:BOOL=ON ^
      -DCH_INSTALL_PYTHON_PACKAGE="../Lib/site-packages" ^
      -DCH_PYCHRONO_DATA_PATH:PATH=data ^
      -DCH_PYCHRONO_SHADER_PATH:PATH=shader ^
      -DCH_ENABLE_MODULE_CASCADE:BOOL=OFF ^
      -DCH_ENABLE_MODULE_IRRLICHT:BOOL=OFF ^
      -DCH_ENABLE_MODULE_MATLAB:BOOL=OFF ^
      -DCH_ENABLE_MODULE_POSTPROCESS:BOOL=OFF ^
      -DCH_ENABLE_MODULE_PYTHON:BOOL=OFF ^
      -DCH_ENABLE_MODULE_ROS:BOOL=OFF ^
      -DCH_ENABLE_MODULE_VEHICLE:BOOL=OFF ^
      -DCH_ENABLE_OPENMP:BOOL=ON ^
      -DCH_USE_SIMD=OFF ^
      .
if errorlevel 1 exit 1

cmake --build build -j%CPU_COUNT%
if errorlevel 1 exit 1

cmake --install build
if errorlevel 1 exit 1
