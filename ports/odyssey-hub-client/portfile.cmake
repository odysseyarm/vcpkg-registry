# odyssey-hub-client ships prebuilt binaries only (no source build) — native
# libs for every platform/linkage are cross-compiled in
# odysseyarm/odyssey-desktop's CI and bundled into one
# odyssey-hub-client-ffi-vX.Y.Z GitHub Release zip, which also contains the
# CMakeLists.txt that vcpkg_cmake_configure/install below actually runs.
#
# On Linux, static linkage additionally requires libudev-dev, dbus-1-dev, and
# pkg-config to be installed on the machine running `vcpkg install` — the
# CMakeLists.txt looks them up via find_package(PkgConfig).

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/odysseyarm/odyssey-desktop/releases/download/odyssey-hub-client-ffi-v${VERSION}/odyssey-hub-client.zip"
    FILENAME "odyssey-hub-client-${VERSION}.zip"
    SHA512 75e841c3bbe93677c982ca789267a74f9deac32f6a01121f01d384826e3686d3f0c4db1086e18a5518f89752ffe3b9cc792267af0cec707b3a58aa3e9dd5f59c
)

vcpkg_extract_source_archive(SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(PACKAGE_NAME odyssey_hub_client CONFIG_PATH "lib/cmake/odyssey_hub_client")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

# vcpkg builds Debug and Release separately, but our CMakeLists.txt installs
# the same prebuilt headers regardless of config — drop the duplicate to
# match vcpkg's own header-dedup convention.
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
