#!/bin/bash

mkdir build
cd build

BUILD_CONFIG=Release

export CFLAGS="$CFLAGS -idirafter /usr/include"
export CXXFLAGS="$CXXFLAGS -idirafter /usr/include"

# now we can start configuring
    # -DVTK_USE_SYSTEM_HDF5:BOOL=ON \
    # -DVTK_EXTERNAL_HDF5_IS_SHARED:BOOL=ON \
    # -DVTK_USE_SYSTEM_LZ4:BOOL=OFF \
cmake -G "Ninja" \
    -Wno-dev \
    -DCMAKE_BUILD_TYPE=$BUILD_CONFIG \
    -DCMAKE_PREFIX_PATH:PATH="${PREFIX}" \
    -DCMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
    -DCMAKE_INSTALL_RPATH:PATH="${PREFIX}/lib" \
    -DBUILD_DOCUMENTATION:BOOL=OFF \
    -DBUILD_TESTING:BOOL=OFF \
    -DBUILD_EXAMPLES:BOOL=OFF \
    -DBUILD_SHARED_LIBS:BOOL=ON \
    -DVTK_WRAP_PYTHON:BOOL=OFF \
    -DModule_vtkPythonInterpreter:BOOL=OFF \
    -DModule_vtkRenderingMatplotlib=OFF \
    -DVTK_HAS_FEENABLEEXCEPT:BOOL=OFF \
    -DVTK_RENDERING_BACKEND=OpenGL \
    -DVTK_USE_SYSTEM_ZLIB:BOOL=ON \
    -DVTK_USE_SYSTEM_FREETYPE:BOOL=ON \
    -DVTK_USE_SYSTEM_LIBXML2:BOOL=ON \
    -DVTK_USE_SYSTEM_PNG:BOOL=ON \
    -DVTK_USE_SYSTEM_JPEG:BOOL=ON \
    -DVTK_USE_SYSTEM_TIFF:BOOL=ON \
    -DVTK_USE_SYSTEM_EXPAT:BOOL=ON \
    -DVTK_USE_SYSTEM_JSONCPP:BOOL=ON \
    -DVTK_SMP_IMPLEMENTATION_TYPE:STRING=TBB \
    -DVTK_USE_SYSTEM_NETCDF:BOOL=OFF \
    -DVTK_USE_SYSTEM_OGGTHEORA:BOOL=OFF \
    -DVTK_USE_X:BOOL=ON \
    -DOPENGL_egl_LIBRARY:FILEPATH=/usr/lib/x86_64-linux-gnu/libEGL.so \
    -DOPENGL_glu_LIBRARY:FILEPATH=/usr/lib/x86_64-linux-gnu/libGLU.so \
    -DOPENGL_glx_LIBRARY:FILEPATH=/usr/lib/x86_64-linux-gnu/libGLX.so \
    -DOPENGL_opengl_LIBRARY:FILEPATH=/usr/lib/x86_64-linux-gnu/libOpenGL.so \
    -DOPENGL_gl_LIBRARY:FILEPATH=/usr/lib/x86_64-linux-gnu/libGL.so \
    -DOpenGL_GL_PREFERENCE:STRING=GLVND \
    -DX11_X11_LIB:FILEPATH=/usr/lib/x86_64-linux-gnu/libX11.so \
    -DX11_Xext_LIB:FILEPATH=/usr/lib/x86_64-linux-gnu/libXext.so \
    -DX11_Xt_LIB:FILEPATH=/usr/lib/x86_64-linux-gnu/libXt.so \
    -DCMAKE_CXX_FLAGS:STRING=-std=c++17 \
    ..

# compile & install!
ninja install

# The egg-info file is necessary because some packages,
# like mayavi, have a __requires__ in their __init__.py,
# which means pkg_resources needs to be able to find vtk.
# See https://setuptools.readthedocs.io/en/latest/pkg_resources.html#workingset-objects

# cat > $SP_DIR/vtk-$PKG_VERSION.egg-info <<FAKE_EGG
# Metadata-Version: 2.1
# Name: vtk
# Version: $PKG_VERSION
# Summary: VTK is an open-source toolkit for 3D computer graphics, image processing, and visualization
# Platform: UNKNOWN
# FAKE_EGG
