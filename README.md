# ISO2M-Tools
Scripts created by me a long time ago for personal purposes (and you can also use them).

Both versions of 'BootableISOBuilder' have been recovered (XOR and MK).

## Bootable ISO Builder
It is a utility that allows you to generate bootable ISO files with full compatibility on all system types (LEGACY and EFI) and all boot sources (live CD-ROM/ISO and live USB) easily with just one click. To get full compatibility, the script auto-detects the files related to system types + boot sources from the root input folder to generate the corresponding bootable ISO file.
This utility has two versions:
- XOR version (ISObuilderXOR.bat): The engine of this script is _xorriso_ (from _libburnia project_). 7-Zip is required to internally process some files. This version creates enhanced ISO files with ISOHybrid MBR (if detected).
- MK version (ISObuilderMK.bat): The engine of this script is _mkisofs_ (from _cdrtools_). 7-Zip is not required.

Both scripts share a similar workflow, but they rely on different underlying engines and provide different levels of UEFI compatibility.


### How to use:
1. Set fields in 'config.properties' file (if they are not configured yet):
   - In 'TOOLS_PATH', put the path to the required tools ('7z.exe' + 'xorriso.exe' for XOR version or 'mkisofs.exe' for MK version). Example: _TOOLS_PATH=C:\Program Files\myTools_
   - In 'ISO_NAME', put the name of the output ISO file. Example: _ISO_NAME=myISOName_
2. Create the input folder with name 'inputFolder' (if it is not created yet).
3. In the 'inputFolder', place the required content (consider this folder as root directory) to generate the bootable ISO file.
4. Run 'ISObuilder' script (XOR or MK version, depending on what you need). If process ends OK, an output folder (named 'outputFolder') will be created with the bootable ISO file generated inside.

---

## Features

### 🔹 ISObuilderMK

- Internal engine: **mkisofs**
- Boot support:
  - ✅ BIOS (El Torito)
  - ✅ UEFI *fallback*
- Recommended environments:
  - VMware
  - Lab / testing setups
- Limitations:
  - ❌ Not real UEFI boot (PlatformID = 0xEF)
  - ❌ Not standard hybrid BIOS + UEFI ISOs
  - ❌ Limited compatibility on real hardware

> ISObuilderMK is ideal for quick tests and controlled environments, where UEFI boot relies on *fallback* mechanisms.

---

### 🔹 ISObuilderXOR

- Internal engine: **xorriso**
- Boot support:
  - ✅ BIOS (El Torito)
  - ✅ Real UEFI boot (PlatformID = 0xEF)
- Key features:
  - Standard hybrid BIOS + UEFI ISO
  - Embedded FAT EFI System Partition (ESP)
  - Full compatibility (real hardware and VMs)
- Suitable for:
  - ISO distribution
  - Professional environments
  - Secure Boot (depending on the EFI bootloader)

> ISObuilderXOR is the recommended option for creating **UEFI-compliant, production-ready ISO images**.

---

## Technical comparison

| Feature | ISObuilderMK | ISObuilderXOR |
|-------|--------------|---------------|
| Internal engine | mkisofs | xorriso |
| BIOS boot (El Torito) | ✅ | ✅ |
| UEFI fallback | ✅ | ✅ |
| Real UEFI (PlatformID 0xEF) | ❌ | ✅ |
| Standard hybrid BIOS + UEFI ISO | ❌ | ✅ |
| VMware compatibility | ✅ | ✅ |
| Real hardware compatibility | ⚠️ Limited | ✅ |
| Secure Boot | ❌ | 📎 EFI-dependant |
| Recommended usage | Testing / lab | Production / distribution / professional environments|

---

## Final notes

- **ISObuilderMK** is suitable for testing and laboratory environments, especially when used with virtual machines such as VMware.
- **ISObuilderXOR** is the recommended tool for creating **real hybrid BIOS + UEFI ISOs**, fully compatible with physical hardware and production environments.

For any professional project that requires UEFI-compliant booting or public ISO distribution. **ISObuilderXOR should be used**.

## Autor
[@RLJuan](https://github.com/RLJuan)

