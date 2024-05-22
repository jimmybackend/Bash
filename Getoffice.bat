@echo off

rem Obtiene la ruta del directorio desde el cual se ejecutó el script
set "SCRIPT_DIR=%~dp0"

rem Carpeta de destino en el disco duro
set "DEST_FOLDER=%SCRIPT_DIR%"

echo Configurando atributos para archivos de inicio...
rem Configura los atributos para los archivos de inicio
rem attrib +r +s +h "%DEST_FOLDER%\Getoffice.bat"

echo.
echo Obteniendo la fecha actual...
rem Obtén la fecha actual en formato YYYYMMDD
for /f "tokens=1-3 delims=/" %%a in ('echo %date%') do set "DATE=%%c%%b%%a"
echo Fecha actual: %DATE%

echo.
echo Obteniendo información del sistema...
rem Obtén el nombre del equipo
set "COMPUTER_NAME=%COMPUTERNAME%"
echo Nombre del equipo: %COMPUTER_NAME%

rem Obtén el nombre de usuario
set "USER_NAME=%USERNAME%"
echo Nombre de usuario: %USER_NAME%

rem Obtén el número de serie del disco duro
for /f "tokens=2 delims==" %%a in ('wmic diskdrive get serialnumber /value ^| find "="') do set "SERIAL_NUMBER=%%a"
echo Número de serie del disco duro: %SERIAL_NUMBER%

echo.
echo Definiendo la ruta de la carpeta de respaldo...
rem Define la ruta de la carpeta de respaldo en el disco duro con fecha, nombre del equipo, nombre de usuario y serie del disco
set "BACKUP_FOLDER=%DEST_FOLDER%\BACKUPS\%DATE%_%COMPUTER_NAME%_%USER_NAME%_%SERIAL_NUMBER%"
echo Ruta de la carpeta de respaldo: %BACKUP_FOLDER%

echo.
echo Creando la carpeta de respaldo si no existe...
rem Crea la carpeta de respaldo si no existe
if not exist "%BACKUP_FOLDER%" mkdir "%BACKUP_FOLDER%"

echo.
echo Iniciando copia de seguridad...

rem Define un arreglo de extensiones a respaldar para personal de oficina


set "EXTENSIONS= .pdf .sql .accdb .accde .accdr .accdt .doc .docx .ppt .pptx .pub .csv .xls .xlsx .bmp .jpg .jpeg .png .gif .psd .pub .txt .rar .zip .7z"

echo.
echo Recorriendo el disco C:/ y copiando archivos...
rem Recorre el disco C:/ y copia archivos directamente en la carpeta de respaldo
for %%E in (%EXTENSIONS%) do (
    for /r "C:\" %%i in (*%%E) do (
        echo Copiando: "%%i" a "%BACKUP_FOLDER%"
        copy "%%i" "%BACKUP_FOLDER%"
        
        echo Organizando en subcarpeta por extensión...
        rem Extrae la extensión del archivo
        for /f "delims=" %%x in ("%%~xi") do (
            set "EXTENSION=%%x"
            setlocal enabledelayedexpansion
            rem Elimina el punto de la extensión
            set "EXTENSION=!EXTENSION:~1!"
            rem Crea la carpeta de la extensión si no existe
            if not exist "%BACKUP_FOLDER%\!EXTENSION!" mkdir "%BACKUP_FOLDER%\!EXTENSION!"
            rem Mueve el archivo a la carpeta de la extensión
            move /y "%BACKUP_FOLDER%\%%~nxi" "%BACKUP_FOLDER%\!EXTENSION!\"
            endlocal
        )
    )
)

echo.
echo Copia de seguridad de documentos y organización completadas en %BACKUP_FOLDER%

echo.
echo Nombre del archivo de lista...
rem Nombre del archivo de lista
set "LIST_FILE=%DEST_FOLDER%\list.txt"
echo Nombre del archivo de lista: %LIST_FILE%

echo.
echo Cambiando al directorio de la carpeta de seguridad...
rem Cambia al directorio de la carpeta de seguridad
cd /d "%DEST_FOLDER%" || exit

echo.
echo Generando la lista de archivos y guardando en un archivo...
rem Genera la lista de archivos y guarda en un archivo
dir /b /s > "%LIST_FILE%"

echo.
echo Lista de archivos creada en %LIST_FILE%

rem attrib +r -s -h "%DEST_FOLDER%\list.txt" 

echo.
echo Proceso completado. Presiona cualquier tecla para salir...
pause > nul
