# ISO2M-Tools
Scripts created by me for personal purposes (and you can also use it).

To date, only 'BootableISO builder' script has been recovered. I'm trying to recover all related scripts to include them here.

## BootableISO builder
It is a script that allows you to generate bootable ISO files with full compatibility on all system types (LEGACY and EFI) and all boot sources (live CD-ROM/ISO and live USB) easily with just one click. To get full compatibility, the script auto-detects the files related to system types + boot sources from the root input folder to generate the corresponding bootable ISO file.
The engine of this script is _xorriso_ from _libburnia project_ (and a build is included in 'tools' directory). Also, a 7-Zip installation is required on your system to internally process some files.

### How to use:
1. Set fields in 'config.properties' file (if they are not configured yet):
   - In '7ZIP_PATH', put the path to the 7-Zip installed on your system. Example: _7ZIP_PATH=C:\Program Files\7-Zip_
   - In 'ISO_NAME', put the name of the output ISO file. Example: _ISO_NAME=testName_
2. Create the input folder with name 'inputFolder' (if it is not created yet).
3. In the 'inputFolder', place the required content (consider this folder as root directory) to generate the bootable ISO file.
4. Run the 'ISObuild.bat'. If process ends OK, an output folder (named 'outputFolder') will be created with the bootable ISO file generated inside.

## Autor
[@RLJuan](https://github.com/RLJuan)

