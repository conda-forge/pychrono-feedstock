@echo on

cmake %CMAKE_ARGS% ^
      -B build ^
      -DBUILD_DEMOS:BOOL=OFF ^
      -DCH_CONDA_INSTALL:BOOL=ON ^
      -DCH_INSTALL_PYTHON_PACKAGE="lib/python%PY_VER%/site-packages" ^
      -DCH_PYCHRONO_DATA_PATH:PATH=data ^
      -DCH_PYCHRONO_SHADER_PATH:PATH=shader ^
      -DENABLE_MODULE_CASCADE:BOOL=OFF ^
      -DENABLE_MODULE_FSI:BOOL=ON ^
      -DENABLE_MODULE_IRRLICHT:BOOL=OFF ^
      -DENABLE_MODULE_MATLAB:BOOL=OFF ^
      -DENABLE_MODULE_OPENGL:BOOL=OFF ^
      -DENABLE_MODULE_POSTPROCESS:BOOL=OFF ^
      -DENABLE_MODULE_PYTHON:BOOL=OFF ^
      -DENABLE_MODULE_ROS:BOOL=ON ^
      -DENABLE_MODULE_VEHICLE:BOOL=OFF ^
      -DENABLE_OPENMP:BOOL=ON ^
      -DUSE_SIMD=OFF ^
      .
if errorlevel 1 exit 1

cmake --build build --config Release -j%CPU_COUNT%
if errorlevel 1 exit 1

cmake --install build --config Release
if errorlevel 1 exit 1
