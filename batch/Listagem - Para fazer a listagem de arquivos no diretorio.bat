set exte=doc
@echo off
cls
echo.
echo.
echo Criando lista de caminhos...
echo.
echo.
echo Aguarde
set num=0
:ini
if not exist LOG-BANCO_DE_DADOS-%num%.%exte% goto fim
set /a num=%num%+1
goto ini
:fim
echo Listagem de diretorios em "%cd%". Dia %date% as %time% > LOG-BANCO_DE_DADOS-%num%.%exte%
tree >> LOG-BANCO_DE_DADOS-%num%.%exte%
exit