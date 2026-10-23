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

# Maintainer
OF_MAINTAINER := mmyesyee

# Display - 1080x2400 (OF_SCREEN_H is the aspect height, 2400 for a 2400-tall panel)
OF_SCREEN_H := 2400
OF_STATUS_H := 90
OF_STATUS_INDENT_LEFT := 48
OF_STATUS_INDENT_RIGHT := 48
OF_HIDE_NOTCH := 1
OF_CLOCK_POS := 1
OF_ALLOW_DISABLE_NAVBAR := 0
OF_OPTIONS_LIST_NUM := 6

# Lights - this device has no notification LED, and the flashlight is driven by
# a vendor-specific MTK node, so disable both
OF_USE_GREEN_LED := 0
OF_FLASHLIGHT_ENABLE := 0

# Tools / partition tools (OF_ENABLE_ALL_PARTITION_TOOLS implies OF_ENABLE_LPTOOLS)
OF_ENABLE_ALL_PARTITION_TOOLS := 1
OF_ENABLE_LPTOOLS := 1

# Actual "super" partition size, in bytes (BOARD_SUPER_PARTITION_SIZE).
# Needed because the ROM's dynamic partitions (system + vendor + the ten oplus
# "my_*" partitions) otherwise trip "The maximum size of all groups for the
# target slot has exceeded allocatable space for dynamic partitions".
OF_DYNAMIC_FULL_SIZE := 16911433728

# Kernel - we always use the prebuilt Image.gz and ignore any in-tree kernel
OF_FORCE_PREBUILT_KERNEL := 1
OF_USE_LZ4_COMPRESSION := 1

# Decryption
OF_DEFAULT_KEYMASTER_VERSION := 4.1
OF_NO_RELOAD_AFTER_DECRYPTION := 1
OF_FBE_METADATA_MOUNT_IGNORE := 1

# /data is f2fs, and metadata encryption is enabled on this device
OF_FORCE_DATA_FORMAT_F2FS := 1
OF_WIPE_METADATA_AFTER_DATAFORMAT := 1

# Misc
OF_NO_TREBLE_COMPATIBILITY_CHECK := 1
OF_NO_MIUI_PATCH_WARNING := 1
OF_DISPLAY_FORMAT_FILESYSTEMS_DEBUG_INFO := 1
OF_WORKAROUND_BACKUP_BUG := 1
#
