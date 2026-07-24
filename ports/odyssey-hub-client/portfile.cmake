# odyssey-hub-client ships prebuilt binaries only (no source build) — native
# libs are cross-compiled in odysseyarm/odyssey-desktop's CI and attached to
# the odyssey-hub-client-ffi-vX.Y.Z GitHub Release. This portfile just
# downloads and repackages the zip for the requesting triplet.

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    message(FATAL_ERROR "odyssey-hub-client only ships dynamic (shared) binaries. Use a dynamic triplet, e.g. x64-windows, x64-linux, x64-osx, arm64-osx, arm64-linux.")
endif()

# SHA512 per triplet, computed at release time. vcpkg_download_distfile
# prints the actual hash on a mismatch — paste it in below after the first
# real release if these placeholders are still here.
if(VCPKG_TARGET_TRIPLET STREQUAL "x64-windows")
    set(OHC_SHA512 "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
elseif(VCPKG_TARGET_TRIPLET STREQUAL "x64-linux")
    set(OHC_SHA512 "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
elseif(VCPKG_TARGET_TRIPLET STREQUAL "arm64-linux")
    set(OHC_SHA512 "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
elseif(VCPKG_TARGET_TRIPLET STREQUAL "x64-osx")
    set(OHC_SHA512 "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
elseif(VCPKG_TARGET_TRIPLET STREQUAL "arm64-osx")
    set(OHC_SHA512 "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
else()
    message(FATAL_ERROR "odyssey-hub-client has no prebuilt binary for triplet '${VCPKG_TARGET_TRIPLET}'. Supported: x64-windows, x64-linux, arm64-linux, x64-osx, arm64-osx.")
endif()

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/odysseyarm/odyssey-desktop/releases/download/odyssey-hub-client-ffi-v${VERSION}/ffi-${VCPKG_TARGET_TRIPLET}.zip"
    FILENAME "odyssey-hub-client-${VERSION}-${VCPKG_TARGET_TRIPLET}.zip"
    SHA512 ${OHC_SHA512}
)

vcpkg_extract_source_archive(PACKAGE_PATH
    ARCHIVE "${ARCHIVE}"
    NO_REMOVE_ONE_LEVEL
)

file(INSTALL "${PACKAGE_PATH}/include/" DESTINATION "${CURRENT_PACKAGES_DIR}/include")

if(VCPKG_TARGET_IS_WINDOWS)
    file(INSTALL "${PACKAGE_PATH}/bin/ohc.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
    file(INSTALL "${PACKAGE_PATH}/bin/ohc.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin")
    file(INSTALL "${PACKAGE_PATH}/lib/ohc.dll.lib" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
    file(INSTALL "${PACKAGE_PATH}/lib/ohc.dll.lib" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
else()
    file(GLOB OHC_SHARED_LIB "${PACKAGE_PATH}/lib/*")
    file(INSTALL ${OHC_SHARED_LIB} DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
    file(INSTALL ${OHC_SHARED_LIB} DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
endif()

vcpkg_install_copyright(FILE_LIST "${PACKAGE_PATH}/LICENSE")
