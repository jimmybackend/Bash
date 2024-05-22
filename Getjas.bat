@echo off
echo Busqueda y Respaldo de JAS.
set "SCRIPT_DIR=%~dp0"
set "DEST_FOLDER=%SCRIPT_DIR%"
rem attrib +r +s +h "%DEST_FOLDER%\getofice.bat"
for /f "tokens=1-3 delims=/" %%a in ('echo %date%') do set "DATE=%%c%%b%%a"
set "COMPUTER_NAME=%COMPUTERNAME%"
set "USER_NAME=%USERNAME%"
for /f "tokens=2 delims==" %%a in ('wmic diskdrive get serialnumber /value ^| find "="') do set "SERIAL_NUMBER=%%a"
set "BACKUP_FOLDER=%DEST_FOLDER%\BACKUPS\%DATE%_%COMPUTER_NAME%_%USER_NAME%_%SERIAL_NUMBER%"
if not exist "%BACKUP_FOLDER%" mkdir "%BACKUP_FOLDER%"

set "EXTENSIONS=.jas .bat"

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


echo Crea la lista...
set "LIST_FILE=%BACKUP_FOLDER%\list.txt"
echo Finalizando...
cd /d "%DEST_FOLDER%" || exit
dir /b /s > "%LIST_FILE%"
rem attrib +r +s -h "%LIST_FILE%" 
echo Proceso completado. 
echo Presiona cualquier tecla para salir...
pause > nul
