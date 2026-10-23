DEVICE_PATH := device/oneplus/OP68F7L1
# The prebuilt kernel image / DTB / DTBO and the kernel module set live inside
# this device tree now (prebuilt/ and kernel-modules/), so there is no separate
# device/oneplus/OP68F7L1-kernel repository to place next to it.

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a55

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := $(TARGET_ARCH_VARIANT)
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := $(TARGET_CPU_VARIANT)
TARGET_2ND_CPU_VARIANT_RUNTIME := $(TARGET_CPU_VARIANT)

# Assertation
TARGET_OTA_ASSERT_DEVICE := OP68F7L1

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := OP68F7L1
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true

# Build Rule
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

# Crypto
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
BOARD_USES_METADATA_PARTITION := true

# Kernel
TARGET_KERNEL_ARCH := arm64
BOARD_RAMDISK_USE_LZ4 := true
TARGET_KERNEL_HEADER_ARCH := arm64
BOARD_BOOT_HEADER_VERSION := 4
BOARD_INIT_BOOT_HEADER_VERSION := 4
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_KERNEL_IMAGE_NAME := Image.gz
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_KERNEL_BASE := 0x3FFF8000
BOARD_PAGE_SIZE := 4096
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x26F08000
BOARD_TAGS_OFFSET := 0x07C88000
BOARD_PREBUILT_DTBIMAGE_DIR := $(DEVICE_PATH)/prebuilt/dtb.img
BOARD_DTB_SIZE := 327372
BOARD_DTB_OFFSET := 0x07C88000
BOARD_VENDOR_CMDLINE := bootopt=64S3,32N2,64N2
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
TARGET_NO_KERNEL_OVERRIDE := true
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbo.img
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img

# Vendor_boot_ramdisk
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
BOARD_MKBOOTIMG_ARGS += --vendor_cmdline $(BOARD_VENDOR_CMDLINE)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_PAGE_SIZE) --board ""
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --base $(BOARD_KERNEL_BASE)

# Kernel modules
BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)/kernel-modules/modules.load))
BOARD_VENDOR_KERNEL_MODULES := $(addprefix $(DEVICE_PATH)/kernel-modules/vendor_dlkm/, $(notdir $(BOARD_VENDOR_KERNEL_MODULES_LOAD)))

BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)/kernel-modules/modules.load.vendor_boot))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(addprefix $(DEVICE_PATH)/kernel-modules/vendor_boot/, $(notdir $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD)))

BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)/kernel-modules/modules.load.recovery))
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES := $(addprefix $(DEVICE_PATH)/kernel-modules/vendor_boot/, $(notdir $(BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD)))
# Make the recovery-only modules available to the normal (non-recovery) vendor
# ramdisk too, otherwise a module that is in modules.load.recovery but not in
# modules.load.vendor_boot is missing when TWRP loads the module set.
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += $(filter-out $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES),$(BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES))

# Modules that TWRP itself loads at startup (touch panel, charger, etc.).
#
# Derived from BOARD_VENDOR_RAMDISK_KERNEL_MODULES (= every .ko the build puts
# into the vendor ramdisk at /lib/modules) instead of shipping a second copy of
# the same .ko files inside recovery/root/vendor/lib/modules. TWRP probes
# /lib/modules (VENDOR_BOOT_MODULE_DIR) before /vendor/lib/modules
# (VENDOR_MODULE_DIR), see kernel_module_loader.cpp, so one copy is enough and
# the vendor_boot image does not carry the same 36 MiB twice.
#
# The value has to carry its own double quotes: bootable/recovery/Android.mk
# passes it straight through as -DTW_LOAD_VENDOR_MODULES=$(TW_LOAD_VENDOR_MODULES).
# $(sort) is there because mtk_dramc.ko is listed twice in
# modules.load.vendor_boot / modules.load.recovery of this kernel drop; it also
# keeps the list to the 235 .ko that actually exist.
TW_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true
TW_LOAD_VENDOR_MODULES := $(shell echo \"$(sort $(notdir $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES)))\")

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
TARGET_COPY_OUT_VENDOR := vendor
BOARD_SUPER_PARTITION_SIZE := 16911433728
BOARD_SUPER_PARTITION_GROUPS := mtk_dynamic_partitions
BOARD_MTK_DYNAMIC_PARTITIONS_SIZE           := 16907239424
BOARD_MTK_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext product vendor vendor_dlkm odm
BOARD_MTK_DYNAMIC_PARTITIONS_PARTITION_LIST += my_bigball my_carrier my_company my_engineering my_heytap my_manifest my_preload my_product my_region my_stock

# Recovery
BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/recovery.fstab
# Our own fstab is authoritative; make sure TWRP does not additionally pull in
# the vendor fstab and re-parse /data and /metadata with different flags.
TW_SKIP_ADDITIONAL_FSTAB := true

# Extra system properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# Hardware
BOARD_USES_MTK_HARDWARE := true

# Platform
TARGET_BOARD_PLATFORM := mt6878

# Treble
BOARD_VNDK_VERSION := 32
AB_OTA_UPDATER := true

# Vendor_boot recovery ramdisk
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true
BOARD_USES_RECOVERY_AS_BOOT := false

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 0

# Hack: prevent anti rollback
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := 2099-12-31
PLATFORM_VERSION := 99.87.36

# TWRP Configurations
TW_THEME := portrait_hdpi
TW_DEFAULT_LANGUAGE := zh_CN
TW_EXTRA_LANGUAGES := true
TW_INCLUDE_FASTBOOTD := true
TW_DEVICE_VERSION := OP68F7L1
TW_MAX_BRIGHTNESS := 2047
TW_NO_SCREEN_BLANK := true
TW_CUSTOM_BATTERY_PATH := "/sys/class/power_supply/battery"

# Debug
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
