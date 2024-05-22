@echo off

rem Obtener la letra de unidad
for /f "tokens=2 delims=:" %%D in ('echo %cd%') do set "drive=%%D"
echo Unidad detectada: %drive%

rem Archivo de registro
set "log_file=%~dp0usb_access_log.txt"
echo Archivo de registro: %log_file%

:monitor
rem Monitorear procesos con PowerShell y escribir en el archivo de registro
powershell -command "& {Get-Process | Where-Object { $_.MainModule.FileName -like '*%drive%*' } | ForEach-Object { Add-Content -Path '%log_file%' -Value ('Proceso detectado: {0}' -f $_.ProcessName); Add-Content -Path '%log_file%' -Value ('   ID del proceso: {0}' -f $_.Id); Add-Content -Path '%log_file%' -Value ('   Ruta del ejecutable: {0}' -f $_.MainModule.FileName); }}"
echo.

rem Pedir al usuario que decida si finalizar el proceso
rem set /p "respuesta=¿Deseas finalizar un proceso? (Y/N): "
rem if /i "%respuesta%"=="Y" (
rem     set /p "pid=Introduce el ID del proceso a finalizar: "
rem     taskkill /F /PID %pid%
rem     echo Proceso con ID %pid% finalizado.
rem )

rem Esperar un segundo y continuar monitoreando
timeout /nobreak /t 2 >nul
goto monitor
