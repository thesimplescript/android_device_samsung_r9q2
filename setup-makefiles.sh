#!/bin/bash
#
# Copyright (C) 2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="/home/aniket/device/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Device specific variables
DEVICE_COMMON="sm8350-common"
DEVICE="r9q2"
VENDOR="samsung"

echo "Setting up vendor for common device: ${DEVICE_COMMON}"
setup_vendor "${DEVICE_COMMON}" "${VENDOR}" "${ANDROID_ROOT}" true

echo "Writing headers for common"
write_headers "r9q2"

echo "Writing makefiles for common"
write_makefiles "/home/aniket/device/samsung/android_device_samsung_sm8350-common/proprietary-files.txt" true

echo "Writing footers for common"
write_footers

if [ -s "${MY_DIR}/proprietary-files.txt" ]; then
    echo "Setting up vendor for device: ${DEVICE}"
    setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false

    echo "Writing headers for device"
    write_headers

    echo "Writing makefiles for device"
    write_makefiles "${MY_DIR}/proprietary-files.txt" true

    echo "Writing footers for device"
    write_footers
fi

echo "Done! Check /home/aniket/device/vendor/samsung/ for generated files"
