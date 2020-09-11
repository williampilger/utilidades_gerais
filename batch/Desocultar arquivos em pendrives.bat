@echo off
echo desocultando arquivos desta unidade, aguarde...
attrib -a -s -r -h /s /d *.*
cls
echo            Trabalhando em ajustes...
echo.
echo.
echo e em seguida confirume ou nao a remocao da pasta...
attrib +s +h /s /d "System Volume Information"
attrib +s +h "autorun.inf"
del *.lnk
set conguig=0
:cong
set /a conguig=%conguig% + 1
cls
color 0b
echo concluido!
echo    @
echo    @@@@@   @@@@@@@@@
echo        @   @       @
echo        @   @       @
echo        @@@@@       @
echo                    @    @@@@@@@@@@@@@@@@
echo                  @@@@@  @         @    @
echo                  @@@@@  @    @   @     @
echo                  @@@@@  @     @ @      @
echo                  @@ @@  @      @       @
echo                  @ @ @  @@@@@@@@@@@@@@@@
echo                  @@@@@         @@
echo                  @@@@@        @@@@
echo.
pause
exit