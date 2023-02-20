#!/bin/sh

mkdir build
cd build

# Workaround for https://github.com/conda-forge/tl-optional-feedstock/pull/3#issuecomment-1437631307
if [[ "$(uname)" == "Darwin" && "${CONDA_BUILD_CROSS_COMPILATION:-}" == "1" ]]; then
    export TL_OPTIONAL_BUILD_TESTING=OFF
else
    export TL_OPTIONAL_BUILD_TESTING=ON
fi

cmake ${CMAKE_ARGS} -GNinja .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_TESTING=${TL_OPTIONAL_BUILD_TESTING}

cmake --build . --config Release
cmake --build . --config Release --target install
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
ctest --output-on-failure -C Release
fi
