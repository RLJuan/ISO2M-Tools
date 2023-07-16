:: ISO2M tools - Bootable ISO builder script
:: Made by JRL with <3

:: This script requires XORrISO and 7-Zip to work.
:: XORrISO is currently installed in 'tools' directory.

@title ISO2M tools - Bootable ISO builder script
@echo off

set arg=%1

:: Internal files
set logFileName=ISObuild_record.log
set configFile=config.properties

:: Workspace folders
set "rootFolder=inputFolder"
set "outFolder=outputFolder"
set "isohybridFolder=_temp"

:: Required paths
set "legacyPath=syslinux/isolinux.bin"
set "legacyCat=syslinux/boot.cat"
set "efiPath=boot/grub/efi.img"
set "livefsPath=live/filesystem.squashfs"
set "isohybridPath=usr/lib/ISOLINUX/isohdpfx.bin"

:: Other required args
set "extraArgs= -isohybrid-gpt-basdat -isohybrid-apm-hfsplus"

:: MAIN PROGRAM
call:PrintL "ISO2M tools - ISO builder script"
call:PrintL "##################### %DATE% %TIME% #####################"

if exist %configFile% (
	for /F "tokens=1,2 delims==" %%I in (%configFile%) do (
		if %%I==ISO_NAME (
			set isoName=%%J
		)
		if %%I==7ZIP_PATH (
			set sevenZipPath=%%J
		)
	)
) else (goto:ERROR_NOCONFIG)

if "%isoName%"=="" (goto:ERROR_NOISONAME)
if not defined sevenZipPath (goto:ERROR_NO7ZIP)

call:PrintL "# ISO name configured: %isoName%"
call:PrintL "Detecting boot files..."

if exist "%rootFolder%" (
	tree %rootFolder% /a >>%logFileName%
	echo. >>%logFileName%
) else (goto:ERROR_NOFOLDER)

if not exist %outFolder% (mkdir %outFolder%)

:: Avoiding duplicated boot files
if exist "%rootFolder%\[BOOT]" (
	rmdir "%rootFolder%\[BOOT]" /s /q
	call:PrintL "# BOOT cleaning done."
)

:: LEGACY boot
if exist %rootFolder%\%legacyPath% (
	set "legacyArgs= -b %legacyPath% -c %legacyCat% -no-emul-boot -boot-load-size 4 -boot-info-table"
	call:PrintL "# LEGACY image detected. ISO will be able to boot on LEGACY BIOS systems."
)

:: EFI boot
if exist %rootFolder%\%efiPath% (
	set "efiArgs= -e %efiPath% -no-emul-boot"
	call:PrintL "# EFI image detected. ISO will be able to boot on UEFI systems."
)

:: MIXED boot
if not defined legacyArgs if not defined efiArgs (goto:ERROR_NOIMAGES)
if defined legacyArgs if not defined efiArgs (set exitcode=2)
if not defined legacyArgs if defined efiArgs (set exitcode=3)
if defined legacyArgs if defined efiArgs (
	set exitcode=0
	set "altBoot= -eltorito-alt-boot"
)

:: ISOHybrid MBR
if exist %rootFolder%\%livefsPath% (
	if not exist "%isohybridFolder%" (mkdir %isohybridFolder%)
	("%sevenZipPath%\7z.exe" x %rootFolder%\%livefsPath% -o%isohybridFolder% %isohybridPath% -y) >>%logFileName% 2>&1
	echo. >>%logFileName%
	if exist "%isohybridFolder%\%isohybridPath%" (
		set "isohybridArgs= -isohybrid-mbr %isohybridFolder%/%isohybridPath% -partition_offset 16"
		call:PrintL "# ISOHYBRID MBR detected. ISO will be enhanced to boot from USB."
	)
)

:: Arguments to trace
(echo.
echo ISOHYBRID ARGS:%isohybridArgs%
echo LEGACY ARGS:%legacyArgs%
echo ALTBOOT ARG:%altBoot%
echo EFI ARGS:%efiArgs%
echo EXTRA ARGS:%extraArgs%
echo IN/OUT: From "%rootFolder%" to "%outFolder%\%isoName%.iso"
echo.) >>%logFileName%

:: ISO creation
echo Creating ISO file...
(tools\xorriso -as mkisofs -R -r -J -joliet-long -l -iso-level 3 -V "ISO2VM" %isohybridArgs%%legacyArgs%%altBoot%%efiArgs%%extraArgs% -o ./%outFolder%/%isoName%.iso %rootFolder%) >>%logFileName% 2>&1
echo. >>%logFileName%
if %ERRORLEVEL%==0 if exist .\%outFolder%\%isoName%.iso (goto:SUCCESS) else (goto:ERROR_NOISO)

:: Functions
:PrintL
echo %~1
echo %~1 >>%logFileName%
goto:EOF

:: Errors
:ERROR_NOISONAME
call:PrintL "# 'ISO_NAME' property NOT configured."
goto:ERROR_END

:ERROR_NO7ZIP
call:PrintL "# 7-Zip NOT found."
goto:ERROR_END

:ERROR_NOCONFIG
call:PrintL "# NO config file detected."
goto:ERROR_END

:ERROR_NOIMAGES
call:PrintL "# NO boot images detected. ISO file will NOT be created."
goto:ERROR_END

:ERROR_NOFOLDER
call:PrintL "# NO input folder detected. ISO file will NOT be created."
goto:ERROR_END

:ERROR_NOISO
call:PrintL "# Error when creating ISO file."
goto:ERROR_END

:: End
:ERROR_END
set exitcode=1
call:PrintL "# Process cancelled! (Exit:%exitcode%)"
goto:EXIT

:SUCCESS
call:PrintL "# ISO file created successfully! (Exit:%exitcode%)"
goto:EXIT

:: Exitcodes: 0=Mixed - 1=Error - 2=Only Legacy - 3=Only EFI
:EXIT
if exist "%isohybridFolder%" (rmdir "%isohybridFolder%" /s /q)
if not "%arg%"=="silent" (pause)
echo. >>%logFileName%
exit /b %exitcode%
