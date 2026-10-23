#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2026 The OrangeFox Recovery Project
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
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#
# NOTE: OrangeFox fox_14.1 validates its build variables in
# bootable/recovery/orangefox.mk. All OF_* configuration for this device lives
# in fox_OP68F7L1.mk (inherited from device.mk), which is where the current
# OrangeFox device trees keep it. Only environment variables that the
# post-build script (vendor/recovery/OrangeFox_A14.sh) consumes at patch time
# are exported here.
#
# Do NOT export FOX_VERSION here - it is obsolete on fox_14.1 and orangefox.mk
# aborts the build if it is set. Use FOX_MAINTAINER_PATCH_VERSION instead.
#
FDEVICE="OP68F7L1"
#set -o xtrace

fox_get_target_device() {
local chkdev=$(echo "$BASH_SOURCE" | grep -w $FDEVICE)
   if [ -n "$chkdev" ]; then
      FOX_BUILD_DEVICE="$FDEVICE"
   else
      chkdev=$(set | grep BASH_ARGV | grep -w $FDEVICE)
      [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
   fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
   fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
	# Locale - zh_CN matches gui/theme/extra-languages/languages/zh_CN.xml
	export TW_DEFAULT_LANGUAGE="zh_CN"
	export LC_ALL="C"

	# Device specifics
	export TARGET_DEVICE_ALT="PYS110"
	export FOX_AB_DEVICE=1

	# Shell / editor tools (sources are synced by the OrangeFox 14.1 manifest:
	# external/bash, external/libncurses, external/nano, external/xz-utils)
	export FOX_USE_BASH_SHELL=1
	export FOX_ASH_IS_BASH=1
	export FOX_USE_TAR_BINARY=1
	export FOX_USE_SED_BINARY=1
	export FOX_USE_XZ_UTILS=1
	export FOX_REPLACE_TOOLBOX_GETPROP=1
	export FOX_USE_NANO_EDITOR=1

	# Extras
	export FOX_ENABLE_APP_MANAGER=0
	export FOX_DELETE_AROMAFM=1

	# Build VARs
	if [ -n "$FOX_BUILD_LOG_FILE" -a -f "$FOX_BUILD_LOG_FILE" ]; then
  	   export | grep "FOX" >> $FOX_BUILD_LOG_FILE
  	   export | grep "OF_" >> $FOX_BUILD_LOG_FILE
   	   export | grep "TARGET_" >> $FOX_BUILD_LOG_FILE
  	   export | grep "TW_" >> $FOX_BUILD_LOG_FILE
 	fi
fi
#
