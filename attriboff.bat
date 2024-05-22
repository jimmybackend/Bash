@echo off

set "SCRIPT_DIR=%~dp0"
set "DEST_FOLDER=%SCRIPT_DIR%"

attrib +r +s -h "%DEST_FOLDER%\attriboff.bat"

attrib -r -s -h "%DEST_FOLDER%\autorun.inf"
attrib -r -s -h "%DEST_FOLDER%\proteccion.inf"
attrib -r -s -h "%DEST_FOLDER%\backups.bat"

attrib -r -s -h "%DEST_FOLDER%\Getoffice.bat"





