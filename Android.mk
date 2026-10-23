LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),OP68F7L1)
include $(call all-subdir-makefiles,$(LOCAL_PATH))
endif
