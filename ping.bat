@echo off
set "url=https://portal.esforzados.com/html/reception.php?user_id=1"

:LOOP
curl -s %url%
echo Respuesta del servidor: %response%

rem Esperar 5 minutos
timeout /t 300 /nobreak >nul

rem Volver al inicio del bucle
goto :LOOP