@echo off
cls
echo.
echo.
:ini
echo.
echo.
echo  1 - Compilar executavel
echo  2 - Compilar DLL 32bits
echo.
set /p opcao=**Digite sua opcao: 
if %opcao% equ 1 goto opica1
if %opcao% equ 2 goto opica2
cls
echo.
echo OPCAO INVALIDA
goto ini

:opica1
cls
mkdir out
g++ main.cpp md5.cpp -o out\md5_sample
goto fim

:opica2
cls
mkdir out
echo Iniciando Compilacao...
g++ -c -DBUILD_DLL md5.cpp md5_dll.cpp
echo exportando DLL...
g++ -shared -o out\md5.dll md5_dll.o md5.cpp -Wl,--out-implib,libshared_lib.a
echo limpando arquivos temporarios...
del /q md5_dll.o
del /q md5.o
del /q libshared_lib.a
goto fim

:fim
echo processo finalizado.
pause
exit