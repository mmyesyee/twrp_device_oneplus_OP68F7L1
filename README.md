# TWRP device tree — OnePlus PYS110 / OP68F7L1 (mt6878)

Pure **TWRP** device tree (branch `twrp-12.1`), targeting the TeamWin
`android-12.1` / Android 12.1 (S, API 32) minimal manifest.

An OrangeFox R14.1 variant of this tree lives on the `Fox-14.1` branch. This
branch carries **no OrangeFox layer**: no `fox_*.mk`, no `vendorsetup.sh`, no
`OF_*` / `FOX_*` variables, and it inherits the stock `vendor/twrp` product
configuration only.

## Quick facts

| Item | Value |
|---|---|
| Device / model | `OP68F7L1` / OnePlus PYS110 |
| SoC | MediaTek MT6878 (Dimensity 7300), arm64 + arm |
| A/B + Virtual A/B | yes (`AB_OTA_UPDATER`, `ro.virtual_ab.compression.enabled=true`) |
| Recovery location | **`vendor_boot`** (header v4, `--ramdisk_type RECOVERY`), no recovery partition |
| Dynamic partitions | super group `mtk_dynamic_partitions`, 16,911,433,728 B |
| Filesystems | system/vendor/odm `erofs`, userdata `f2fs`, metadata `f2fs` |
| Crypto | FBE + metadata encryption (`TW_INCLUDE_CRYPTO`, `TW_INCLUDE_FBE_METADATA_DECRYPT`) |
| Encrypt impl | `OF_DEFAULT_KEYMASTER_VERSION` equivalent: keymaster 4.1 |

## What is inside the tree

```
device/oneplus/OP68F7L1/
├── Android.bp                  soong_namespace {} (device.mk sets PRODUCT_SOONG_NAMESPACES)
├── Android.mk                  includes the sub-dir makefiles
├── AndroidProducts.mk          PRODUCT_MAKEFILES + COMMON_LUNCH_CHOICES
├── BoardConfig.mk              kernel/DTB/DTBO, partitions, VNDK 32, TWRP flags
├── device.mk                   A/B partitions, HAL/service packages, dynamic partitions
├── twrp_OP68F7L1.mk            product makefile (identifiers, fingerprint)
├── bootctrl/                   MediaTek fork of android.hardware.boot@1.2 (HIDL impl)
├── mtk_plpath_utils/           preloader/LK path fixups, used by init.recovery
├── kernel-modules/             modules.load{,.vendor_boot,.recovery} + vendor_boot/, vendor_dlkm/ .ko
├── prebuilt/                   kernel (Image.gz), dtb.img, dtbo.img
├── recovery/root/              init rc files, recovery.fstab (TARGET_RECOVERY_FSTAB), twrp.flags
├── security/                   stock ColorOS OTA keys (local_OTA / special_OTA .x509.pem)
└── system.prop                 ro.boot.dynamic_partitions, ro.vendor.mediatek.platform=MT6878, ...
```

`recovery/stock-ramdisk-backup/` holds the stock ColorOS recovery ramdisk dump
that the tree originally shipped under `recovery/root/system/`. It is kept only
as a reference and is **not** part of the build. Keeping it under
`recovery/root/` would overwrite the built TWRP binary with the stock OPPO
recovery (`recovery/root/**` is copied over the finished ramdisk).

## Building

Sync the TWRP 12.1 minimal manifest:

```sh
mkdir twrp-12.1 && cd twrp-12.1
repo init -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1
repo sync -j8 --force-sync --no-clone-bundle --no-tags
```

Drop this directory in as `device/oneplus/OP68F7L1`, then:

```sh
export ALLOW_MISSING_DEPENDENCIES=true
source build/envsetup.sh
lunch twrp_OP68F7L1-eng
mka vendorbootimage            # recovery lives in vendor_boot on this device
```

Flash `out/target/product/OP68F7L1/vendor_boot.img` to the `vendor_boot`
partition (both slots: `fastboot flash vendor_boot_a` and `vendor_boot_b`).

## Notes / known caveats

* `TARGET_RECOVERY_FSTAB` points at `recovery/root/recovery.fstab`, and
  `TW_SKIP_ADDITIONAL_FSTAB := true` — the tree's own fstab is authoritative, so
  TWRP will not re-parse the vendor fstab and fight over `/data` flags.
* The fstab uses the **v2** column layout
  (`<src> <mnt_point> <type> <mount options> <twrp flags>`). A line that starts
  with a plain `/` is parsed as **v1** by `partition.cpp`, which turns
  `/system /system erofs ro ...` into a partition whose *block device* is
  `erofs`. Do not reformat the fstab.
* `recovery/root/system/etc/twrp.flags` uses TWRP **v1** flag syntax
  (`mnt_point type device flags=display="...";backup=1;flashimg=1`); TWRP always
  re-parses `twrp.flags` with the v1 parser, even for v2 fstabs.
* `TW_LOAD_VENDOR_MODULES` is derived from `BOARD_VENDOR_RAMDISK_KERNEL_MODULES`,
  i.e. TWRP loads the same 235 `.ko` that the build installs into
  `/lib/modules` of the vendor ramdisk. Do not add a second copy of the module
  set under `recovery/root/vendor/lib/modules/` — TWRP probes `/lib/modules`
  first, and both copies would count against the 64 MiB `vendor_boot`
  partition.
* `BOARD_VNDK_VERSION := 32` matches Android 12.1. If the sync ever complains
  about a missing VNDK snapshot, drop that line and let build/make default to
  `current`.
* `bootctrl/boot_region_control.cpp` opens `/dev/block/sdc` for the UFS
  `QUERY_ATTR_IDN_BOOT_LUN_EN` query. On this device `sda`/`sdb` are the two
  4 MiB boot LUs and `sdc` is the main data LUN holding the GPT — the attribute
  is device-level, so targeting `sdc` is correct (same as the MediaTek
  reference), and `bootctl set-active-boot-slot N` works.

## Optional: lptools (super-partition GUI tools)

`TW_ENABLE_ALL_PARTITION_TOOLS := true` / `TW_INCLUDE_LPTOOLS := true` are
deliberately **not** set, because TWRP 12.1 backs them with the `lptools` binary
(`bootable/recovery/prebuilt/Android.mk:288-306` adds it to
`TWRP_REQUIRED_MODULES`), and `external/lptools` is not part of the official
TWRP 12.1 minimal manifest. Enabling them without the source only produces a
silently broken partition-tools menu.

The device still ships `lpflash` / `lpmake` / `lpunpack` from
`system/extras/partition_tools`. If you also want the GUI partition tools:

```sh
git clone https://github.com/phhusson/vendor_lptools external/lptools
```

then add to `BoardConfig.mk`:

```make
TW_ENABLE_ALL_PARTITION_TOOLS := true
```

