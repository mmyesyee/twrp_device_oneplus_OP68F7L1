#
#	This file is part of the OrangeFox Recovery Project
#	Copyright (C) 2026 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
#	Please maintain this if you use this script or any part of it
#

# Inherit the standard AOSP pieces. compression.mk already pulls in
# launch_with_vendor_ramdisk.mk, so there is no need to inherit that separately:
# this device is a Virtual A/B device whose recovery lives in vendor_boot, and
# Virtual A/B compression (snapuserd) is enabled (ro.virtual_ab.compression.enabled=true
# in the stock vendor build.prop).
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from the TWRP product configuration (OrangeFox reuses vendor/twrp)
$(call inherit-product, vendor/twrp/config/common.mk)

# Device specific configs (this also inherits fox_OP68F7L1.mk)
$(call inherit-product, device/oneplus/OP68F7L1/device.mk)

# Device identifier
PRODUCT_DEVICE := OP68F7L1
PRODUCT_NAME := twrp_OP68F7L1
PRODUCT_BRAND := oneplus
PRODUCT_MODEL := PYS110
PRODUCT_MANUFACTURER := oppo
PRODUCT_RELEASE_NAME := PYS110
PRODUCT_GMS_CLIENTID_BASE := android-oplus

# Fingerprint of the stock ColorOS 17 (Android 17) build. Devices launching with
# Android 16+ refuse to boot/decrypt under an older fingerprint, so this must
# match the stock ROM rather than being left at an OrangeFox/AOSP default.
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="OnePlus/PYS110/OP68F7L1:17/CP2A.260605.016/B.4a295d3-241d2b0-242afbd:user/release-keys"

BUILD_FINGERPRINT := OnePlus/PYS110/OP68F7L1:17/CP2A.260605.016/B.4a295d3-241d2b0-242afbd:user/release-keys

# Vendor_boot recovery ramdisk
PRODUCT_PROPERTY_OVERRIDES += ro.twrp.vendor_boot=true
PRODUCT_BUILD_VENDOR_BOOT_IMAGE := true
