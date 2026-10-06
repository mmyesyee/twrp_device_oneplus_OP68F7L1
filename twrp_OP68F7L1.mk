# Inherit from common AOSP config
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk) # vab加载到vendor boot里使用

# Inherit from TWRP product configuration
$(call inherit-product, vendor/twrp/config/common.mk) # twrp-9分支改为onmi

# Device specific configs
$(call inherit-product, device/xiaomi/rubens/device.mk)

# Device identifier
PRODUCT_DEVICE := OP68F7L1 # 设备型号
PRODUCT_NAME := twrp_PYS110 # 设备名称
PRODUCT_BRAND := oneplus # 自定义品牌，如果有
PRODUCT_MODEL := PYS110 # 产品最终用户可见名称
PRODUCT_MANUFACTURER := oppo # 制造商

PRODUCT_PROPERTY_OVERRIDES += ro.twrp.vendor_boot=true # 对twrp启动vendor_boot支持
