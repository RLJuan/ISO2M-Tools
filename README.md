# ISO2M-Tools
Scripts created by me a long time ago for personal purposes (and you can also use them).

Both versions of 'BootableISOBuilder' have been recovered (XOR and MK).

## Bootable ISO Builder
It is a utility that allows you to generate bootable ISO files with full compatibility on all system types (LEGACY and EFI) and all boot sources (live CD-ROM/ISO and live USB) easily with just one click. To get full compatibility, the script auto-detects the files related to system types + boot sources from the root input folder to generate the corresponding bootable ISO file.
This utility has two versions:
- XOR version (ISObuilderXOR.bat): The engine of this script is _xorriso_ (from _libburnia project_). 7-Zip is required to internally process some files. This version creates enhanced ISO files with ISOHybrid MBR (if detected).
- MK version (ISObuilderMK.bat): The engine of this script is _mkisofs_ (from _cdrtools_). 7-Zip is not required.

### How to use:
1. Set fields in 'config.properties' file (if they are not configured yet):
   - In 'TOOLS_PATH', put the path to the required tools ('7z.exe' + 'xorriso.exe' for XOR version or 'mkisofs.exe' for MK version). Example: _TOOLS_PATH=C:\Program Files\myTools_
   - In 'ISO_NAME', put the name of the output ISO file. Example: _ISO_NAME=myISOName_
2. Create the input folder with name 'inputFolder' (if it is not created yet).
3. In the 'inputFolder', place the required content (consider this folder as root directory) to generate the bootable ISO file.
4. Run 'ISObuilder' script (XOR or MK version, depending on what you need). If process ends OK, an output folder (named 'outputFolder') will be created with the bootable ISO file generated inside.

## Autor
[@RLJuan](https://github.com/RLJuan)

