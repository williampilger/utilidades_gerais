@echo off
echo.
:ini
echo.
echo Imagens de Tela de Bloqueio do Windows 10
echo.
echo (Imagens encontradas em: "%userprofile%\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets")
echo.
echo.
echo                       Desenvolvido Por William Pilger
echo.
echo.
echo        1 - Abrir pasta dos arquivos
echo        2 - Copiar imagens para seu desktop
ehco.
echo.
set /p opcao=Sua opcao---
if %opcao% equ 1 goto COM1
if %opcao% equ 2 goto COM2
cls
echo OPCAO INVALIDA
goto ini
:COM1
start %userprofile%\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets
cls
echo Abrimos a janela com o local dos arquivos...
goto ini
:COM2
mkdir %userprofile%\Desktop\IMAGENSESTRAIDAS
copy %userprofile%\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\*.* %userprofile%\Desktop\IMAGENSESTRAIDAS\*.jpg
cls
echo Os arquivos foram copiados...
goto ini