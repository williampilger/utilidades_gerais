@echo off
cls
echo.
echo.
echo     Abrindo conversa no WhatsApp
echo.
set /p numero=***Digite o numero de telefone, com DDD---
start http://api.whatsapp.com/send?phone=%numero%
exit