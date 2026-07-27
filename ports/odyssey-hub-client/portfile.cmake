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
    SHA512 367ebf12d66e6948f7d41ed279aab71ed934eee290099c6bb911e3f2a95f261a5468ec281a9a2ab81ac152b15fbe7af543b20b84b9174bd4d319a8f29b1e991b
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

# vcpkg_cmake_config_fixup only deletes known cmake-config filename patterns
# from the debug share copy — our extra DeclareOhcTarget.cmake sibling file
# doesn't match any of them, so it's left behind and trips vcpkg's
# debug/share policy check.
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
