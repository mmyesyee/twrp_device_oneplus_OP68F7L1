#
# Copyright (C) 2026 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Inherit the standard AOSP pieces.
#
# compression.mk already pulls in launch_with_vendor_ramdisk.mk, so that one
# must not be inherited a second time. This device is a Virtual A/B device whose
# recovery lives in vendor_boot, and its stock vendor build.prop carries
# ro.virtual_ab.compression.enabled=true as well as
# ro.virtual_ab.userspace.snapshots.enabled=true with snapuserd in the vendor
# ramdisk, so the compressed variant is the right one.
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# TWRP product configuration
$(call inherit-product, vendor/twrp/config/common.mk)

# Device specific configuration
$(call inherit-product, device/oneplus/OP68F7L1/device.mk)

# Device identifier
PRODUCT_DEVICE := OP68F7L1
PRODUCT_NAME := twrp_OP68F7L1
PRODUCT_BRAND := oneplus
PRODUCT_MODEL := PYS110
PRODUCT_MANUFACTURER := oppo
PRODUCT_RELEASE_NAME := PYS110
PRODUCT_GMS_CLIENTID_BASE := android-oplus

# Fingerprint of the stock ColorOS build. Devices launching with a recent
# fingerprint refuse to boot/decrypt under an older one, so this has to match
# the stock ROM instead of being left at an AOSP default.
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="OnePlus/PYS110/OP68F7L1:17/CP2A.260605.016/B.4a295d3-241d2b0-242afbd:user/release-keys"

BUILD_FINGERPRINT := OnePlus/PYS110/OP68F7L1:17/CP2A.260605.016/B.4a295d3-241d2b0-242afbd:user/release-keys

# Vendor_boot recovery ramdisk
PRODUCT_PROPERTY_OVERRIDES += ro.twrp.vendor_boot=true
PRODUCT_BUILD_VENDOR_BOOT_IMAGE := true
