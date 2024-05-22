@echo off

rem Obtén la unidad del USB conectado
set "USB_DRIVE="
for /f "tokens=2 delims==" %%D in ('wmic logicaldisk where drivetype^=2 get deviceid /value') do (
    set "USB_DRIVE=%%D"
    goto :FoundUSB
)
:FoundUSB

if not defined USB_DRIVE (
    echo No se detectó un USB conectado.
    exit /b
)

echo --- Unidad del USB detectada: %USB_DRIVE% ---

rem Carpeta de destino en el USB
set "USB_DEST_FOLDER=%USB_DRIVE%"

rem Verifica si la carpeta de destino en el USB existe
if not exist "%USB_DEST_FOLDER%" mkdir "%USB_DEST_FOLDER%"
echo --- Carpeta de destino en el USB creada: %USB_DEST_FOLDER% ---

rem Carpeta de origen en el disco duro
set "SOURCE_FOLDER=C:\seguridad"
echo --- Carpeta de origen en el disco duro: %SOURCE_FOLDER% ---

rem Archivos que quieres copiar al USB
set "FILES_TO_COPY=autorun.inf proteccion.inf proteger.bat"

rem Copia los archivos al USB desde la carpeta de origen
for %%i in (%FILES_TO_COPY%) do (
    echo Copiando: %%i
    copy "%SOURCE_FOLDER%\%%i" "%USB_DEST_FOLDER%\"
    echo --- Archivo %%i copiado a %USB_DEST_FOLDER% ---
)

rem Asigna atributos a los archivos en la raíz del USB
attrib +r +s +h "%USB_DEST_FOLDER%\autorun.inf"
attrib +r +s +h "%USB_DEST_FOLDER%\proteccion.inf"
attrib +r +s +h "%USB_DEST_FOLDER%\proteger.bat"

echo --- Atributos asignados a los archivos en el USB ---

echo Copia y protección de archivos completada en "%USB_DEST_FOLDER%"

pause > nul
