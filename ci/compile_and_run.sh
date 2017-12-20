#!/bin/bash
cd $1
rm -rf build
mkdir build && cd build
ARGS=(
  -D CMAKE_BUILD_TYPE=Debug
  -D MFMG_ENABLE_TESTS=ON
  -D BUILD_SHARED_LIBS=ON
  -D MFMG_ENABLE_ClangFormat=ON
  -D MFMG_ENABLE_COVERAGE=ON
  -D MFMG_ENABLE_DOCUMENTATION=OFF
  -D DEAL_II_DIR=${DEAL_II_DIR}
  -D CMAKE_CXX_FLAGS="-Wall -Wpedantic -Wextra -Wshadow"
  )
cmake "${ARGS[@]}" ../
make -j12
ctest -j12 --no-compress-output -T Test

# Code coverage
make coverage
curl -s https://codecov.io/bash -o codecov_bash_uploader
chmod +x codecov_bash_uploader
./codecov_bash_uploader -Z -X gcov -f lcov.info

exit 0
