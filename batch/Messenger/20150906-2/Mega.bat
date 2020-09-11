@echo off
call conf.bat
color %color%
set versao=012
	set Edition=
REM selecione como "X" a "Edition" caso queira criar uma edição especial.
	set IDXE=
REM caso a "Edition" seja expecial, DEVEM ser preenchidos os campos "IDXE" e "locdirXE", onde a primeira é o ID que o usuario deve assumir, e o segundo é o local do servidor.
	set locdirXE=
REM [14/06/2015]
set TCARRE=2
REM tempo entre as atalizações de tala do "carrega".
set TCARREC=1
REM tempo que o programa espera, para reescrever as configurações do arquivo "config", entre uma configuração e outra.
set TLER=5
REM tempo que o programa espera para atualizar as mensagens da converça no modo SAVA.
set TLER=2
REM tempo que o programa espera para atualizar as mensagens da converça no modo SBMAVA.
set TESPENT=1
REM tempo que o programa espera para atualizar mensagens na hora de atualizar totalmente a lista, no modo SBMAVA
set TLOK=5
REM tempo que o programa dá para que algum ID sej banido.
set napp=Mega
REM Nome como o programa deve ser salvo.
set ex=bat
REM extensão do programa (no servidor?)
set exdoser=bat
REM extensao do servico
set senha=21232426
REM senha de administrador
set DEVE_OCULTAR_SERV=N
REM Deve ocultar arquivos no servidor?(S ou N)
set DEVE_OCULTAR_LOCA=S
REM Deve ocultar arquivos de configuração no diretorio do programa?(S ou N)
set opcao=0
:ini
if not exist conf.bat goto inib
set opcao=0
set direits=UP
call conf.bat
if %DEVE_OCULTAR_LOCA% equ S attrib -s -h sair.ir
del /q sair.ir
if not exist %napp%.%ex% goto RENOMEMENS
if exist SA.bat goto SACONCLO
if exist conf.bat call conf.bat
if exist ir.bat goto irr
if exist ir2.bat goto irr2
if exist ir3.bat goto ENCOL1
if exist mensa.ir goto chemensaagora
if exist service.ir goto comecaaquioservicka
attrib -s -h nom.bat
del /q nom.bat
cls
echo processed...
echo NAO INTERROMPA ESTE PROCESSO
if %DEVE_OCULTAR_LOCA% equ S attrib -s -h conf.bat
if %DEVE_OCULTAR_LOCA% equ S attrib -s -h altns*.bat
echo CONFIGURANDO ATRIBUTOS...
ping -n %TCARREC% 127.0.0.1 >NUL
del /q conf.bat
echo DELETANDO CONFIGURACOES DESNECESSARIAS
ping -n %TCARREC% 127.0.0.1 >NUL
echo set locdir=%locdir%> conf.bat
echo CONFIGURANDO SERVIDOR
ping -n %TCARREC% 127.0.0.1 >NUL
echo set ID=%ID%>> conf.bat
echo CONFIGURANDO IDENTIDADE
ping -n %TCARREC% 127.0.0.1 >NUL
echo set direits=%direits%>> conf.bat
echo CONFIGURANDO DIREITOS
ping -n %TCARREC% 127.0.0.1 >NUL
echo set color=%color%>> conf.bat
echo CONFIGURANDO CORES DO PAINEL
ping -n %TCARREC% 127.0.0.1 >NUL
echo set TSERV=%TSERV%>> conf.bat
echo CONFIGURANDO TIPO DE SERVIDOR
ping -n %TCARREC% 127.0.0.1 >NUL
if %DEVE_OCULTAR_LOCA% equ S attrib +s +h conf.bat
if %DEVE_OCULTAR_LOCA% equ S attrib +s +h altns*.bat
echo CONFIGURANDO ATRIBUTOS DAS CONFIGURACOES
ping -n %TCARREC% 127.0.0.1 >NUL
:inib
cls
echo   10000000000     0000000000  
echo     00000000       100000001  
echo     10000000       00000001   
echo     100000001     100000001   
echo     100000000     000000001   
echo     1000000001   0000000001   
echo     1000000000  10000000001   
echo     10001000001 00001000001   
echo     1000 00000000001 000001   
echo     1000  000000000  000001   0000000 0000000 0000000
echo     1000  100000001  000001   0       0       0     0
echo     1000   0000000   000001   0000000 0   000 0000000
echo     00001  100000   1000001   0       0     0 0     0
echo   00000001  00001  000000000  0000000 0000000 0     0
echo  0011111100  110   0111111100 
echo.
echo.
echo.          Will Corporation®
echo.
echo Para comecar, e conectar diretamente no servidor, tecle enter
set number=0
set /p opcao=
if %opcao% equ config goto config
if %opcao% equ ver goto ver
if %opcao% equ adm goto comadmm
if %opcao% equ add goto ADDSERV
if not exist conf.bat goto failconf
goto com
:ver
cls
echo config = configurar
echo adm    = entrar como administrador
echo add    = adicionar servidor
set /p OPKA=
if %OPKA% equ senha echo %senha%&pause
goto ini
:edx
cls
:edx2
echo Voce possui uma versao especial do Mega, por favor,
echo para continuar digite sua senha, caso ainda nao tenhas
echo uma senha, ela sera criada agora.
echo.
echo.
set /p senho=Digite sua senha---
if exist %locdir%\edx\%senho%%IDXE%.key goto CACJQTAS
if exist %locdir%\edx\*%IDXE%.Key goto FAHDE
cls
set /p resenho=Repita a senha---
if %senho% equ %resenho% goto crisennovuser
cls
echo.
echo Senhas diferentes...
echo Tente novamente!
echo.
echo.
goto edx2
:crisennovuser
cls
echo estamos configurando sua edição especial...
mkdir %locdir%\edx
copy NUL %locdir%\edx\%senho%%IDXE%.key
echo set locdir=%locdirXE%> conf.bat
echo set ID=%IDXE%>> conf.bat
if %DEVE_OCULTAR_LOCA% equ S attrib +h +s conf.bat
cls
if not exist %locdir%\edx\%senho%%IDXE%.key echo Falhou!
echo Concluido!
goto ini
:CACJQTAS
echo set locdir=%locdirXE%> conf.bat
echo set ID=%IDXE%>> conf.bat
if %DEVE_OCULTAR_LOCA% equ S attrib +h +s conf.bat
cls
echo Logado...
pause
goto ini
:FAHDE
cls
echo Esta senha esta incorreta!
pause
goto ini
:failconf
if %Edition% equ X goto edx
cls
echo necessaria a configuracao!!!
echo entre em contato com o desenvolvedor!!!
pause
exit
:config
cls
echo configurando...
set /p senh=Digite a senha--%RS%--
set NOMARQCONF=conf
if %senh% equ %senha% goto configur1
cls
set RS=Falhou
goto config
:ADDSERV
cls
echo Adicionando servidor...
echo.
echo.
set /p senh=Digite a senha--%RS%--
if %senh% equ %senha% goto PROARQDISP
cls
goto ADDSERV
:PROARQDISP
set num=0
:PROARQDISPB
if not exist altns%num%.bat goto ESTESERARQUIVSODIS
set /a num=%num + 1
goto PROARQDISPB
:ESTESERARQUIVSODIS
set NOMARQCONF=altns%num%
goto configur1
:configur1
cls
set /p locdir=Digite o diretorio do servidor---%RSD%
if exist %locdir%\server.ac goto configur11
mkdir %locdir%
copy NUL %locdir%\server.ac
if exist %locdir%\server.ac goto configur12
set RSD=caminho_invalido
goto configur1
:configur11
set RSD=servidor_encontrado
call %locdir%\TSERV.bat
echo set TSERV=%TSERV%>> %NOMARQCONF%.bat
goto configur2
:configur12
set RSD=Servidor_criado
mkdir %locdir%\Atualiza
echo set VSMA=%versao%> %locdir%\VSMA.bat
copy %napp%.%ex% %locdir%\Atualiza\%napp%.%ex%
:esctipserv
cls
echo.
echo celecione o tipo de servidor:
echo 1- SAVA (Servidor de Alta Velocidade de Acesso)
echo 2- SBMAVA (Servidor de Baixa/Media/Alta velocidade de Acesso)
echo.
echo  OBS: o servidor SBMAVA e indicado para casos onde o servidor
echo       a acessado de muitos locais ao mesmo tempo, ou em casos
echo       do servidor estar em um colal sincronisado pela internet.
echo.
set /p TS=Digite sua opcao-
if %TS% equ 1 goto SAVAcris
if %TS% equ 2 goto SBMAVAcris
goto esctipserv
:SAVAcris
echo set TSERV=SAVA>%locdir%\TSERV.bat
echo set TSERV=SAVA>> %NOMARQCONF%.bat
goto configur2
:SBMAVAcris
echo set TSERV=SBMAVA>%locdir%\TSERV.bat
echo set TSERV=SBMAVA>> %NOMARQCONF%.bat
mkdir %locdir%\MENSN
mkdir %locdir%\MENSA
:configur2
cls
echo Digite o diretorio do servidor--- %locdir% -- %RSD%
set /p ID=Digite a ID (sem espacos)---
echo set locdir=%locdir%>> %NOMARQCONF%.bat
echo set ID=%ID%>> %NOMARQCONF%.bat
if %DEVE_OCULTAR_LOCA% equ S attrib +s +h %NOMARQCONF%.bat
cls
echo configurado com sucesso!
pause
goto ini
:FSNE
if exist altns%number%.bat goto proxserv
cls
echo servidor nao encontrado!
echo por favor, faca o recadastro!
pause
goto ini
:proxserv
call altns%number%.bat
if exist %locdir%\server.ac goto exsernum
set /a number=%number% + 1
goto FSNE
:exsernum
if %DEVE_OCULTAR_LOCA% equ S attrib -s -h conf.bat
if %DEVE_OCULTAR_LOCA% equ S attrib -s -h altns%number%.bat
call altns%number%.bat
set Olocdir=%locdir%
set OID=%ID%
set OTSERV=%TSERV%
call conf.bat
echo set locdir=%Olocdir%>> conf.bat
ping -n %TCARREC% 127.0.0.1 >NUL
echo set locdir=%locdir%> altns%number%.bat
ping -n %TCARREC% 127.0.0.1 >NUL
echo set ID=%OID%>> conf.bat
ping -n %TCARREC% 127.0.0.1 >NUL
echo set ID=%ID%>> altns%number%.bat
ping -n %TCARREC% 127.0.0.1 >NUL
echo set TSERV=%OTSERV%>> conf.bat
ping -n %TCARREC% 127.0.0.1 >NUL
echo set TSERV=%TSERV%>> altns%number%.bat
ping -n %TCARREC% 127.0.0.1 >NUL
call conf.bat
if %DEVE_OCULTAR_LOCA% equ S attrib +s +h conf.bat
if %DEVE_OCULTAR_LOCA% equ S attrib +s +h altns*.bat
set /a number=%number% + 1
if %direits% equ Adm goto com2x
:com
if %direits% equ Adm goto com2x
if not exist %locdir%\server.ac goto FSNE
cls
echo.
echo.
echo Conectado ao servidor: %locdir%
echo.
echo.
echo para pular o servidor, digite ALT
echo.
echo.
set /p nome=Informe seu nome--
if "%nome%" equ "ALT" goto FSNE
del /q %locdir%\com.bat
echo set nome=%nome%> nom.bat
if %DEVE_OCULTAR_SERV% equ S attrib +s +h %locdir%
if %DEVE_OCULTAR_LOCA% equ S attrib +s +h nom.bat
call %locdir%\VSMA.bat
if %versao% LSS %VSMA% goto atualiza
copy NUL ir.bat
start %napp%.%ex%
if not %TSERV% equ SBMAVA goto com1
mkdir %locdir%\MENSN
set M=0
:com1
set comand=0
if exist %locdir%\com.bat call %locdir%\com.bat
if exist %locdir%\com.bat set M=0
if exist %locdir%\CO.bat goto LEITUCO
if exist sair.ir exit
:com1d
call conf.bat
color %color%
if %comand% equ relat goto relat
if %comand% equ lok goto lok
if %comand% equ lixver goto lixver
if %comand% equ LBO goto LBOJ
if %comand% equ comandoL goto lerLcom
if %comand% equ blo goto bloo
if %comand% equ Dblo goto Dbloo
if %comand% equ ADDADM goto ADDMYADM
if %TSERV% equ SAVA goto TSLMSAVA
if %M% equ 0 cls
if %TSERV% equ SBMAVA goto TSLMSBMAVA
cls
echo Algo falhou! por favor, verifique as suas configurações!
pause
exit
:TSLMSAVA
cls
type %locdir%\conv.MCMD
ping -n %TLER% 127.0.0.1 >NUL
goto com1
:TSLMSBMAVA
if exist %locdir%\MENSN\%M%.mens goto LEMENSMINHADOSER
ping -n %TLER@% 127.0.0.1 >NUL
goto com1
:LEMENSMINHADOSER
type %locdir%\MENSN\%M%.mens
set /a M=%M% + 1
ping -n %TESPENT% 127.0.0.1 >NUL
goto :TSLMSBMAVA
:relat
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ > %locdir%\Relat\%ID%.RM
echo ID= %ID% >> %locdir%\Relat\%ID%.RM
echo Nome: %nome% >> %locdir%\Relat\%ID%.RM
echo Data: %date% >> %locdir%\Relat\%ID%.RM
echo Hora: %time% >> %locdir%\Relat\%ID%.RM
echo Userprofile: %userprofile% >> %locdir%\Relat\%ID%.RM
echo versao do %napp% utilizada: %versao% >> %locdir%\Relat\%ID%.RM
ver >> %locdir%\Relat\%ID%.RM
echo Conectador como Usuario Padrao >> %locdir%\Relat\%ID%.RM
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ >> %locdir%\Relat\%ID%.RM
cls
set localvolt=com1
goto carrega
:lixver
echo %nome% ---- %ID% >> %locdir%\lixver.AM
cls
set localvolt=com1
goto carrega
:lok
if %idlok% equ %ID% goto lokme
if %idlok% equ todos goto lokme
goto com
:lokme
if %DEVE_OCULTAR_LOCA% equ S attrib -s -h conf.bat
del /q conf.bat
taskkill /f /im %napp%.exe
taskkill /f /im cmd.exe
exit
:bloo
if %idblo% equ %ID% goto blookJ
if %idblo% equ todos goto blookJ
if %DEVE_OCULTAR_LOCA% equ S attrib +s +h blo.bat
goto com1
:blookJ
copy NUL blo.bat
set localvolt=com1
goto carrega
:Dbloo
if %DEVE_OCULTAR_LOCA% equ S attrib -s -h blo.bat
if %idDblo% equ %ID% goto DBLOMEJ
if %DEVE_OCULTAR_LOCA% equ S attrib +s +h blo.bat
goto com1
:DBLOMEJ
del /q blo.bat
set localvolt=com1
goto carrega
:LBOJ
if %IDLB% equ %ID% goto leBAT
if %IDLB% equ todos goto leBAT
goto com1
:lerLcom
if %IDLCL% equ %ID% goto lerLcomb
if %IDLCL% equ todos goto lerLcomb
goto com1
:lerLcomb
%comandoL%
set localvolt=com1
goto carrega
goto com1
:leBAT
copy %locdir%\co.bat co.bat
start co.bat
cls
set localvolt=com1
goto carrega
:LEITUCO
call %locdir%\CO.bat
if %OP% equ BAIDOBRI goto BAMOBRI
if %OP% equ BLIDOBRI goto BLMOBRI
if %OP% equ EBOBRI goto EBOBRI
del /q %locdir%\CO.bat
goto com1
:BAMOBRI
if %idlok% equ %ID% goto BANMEJAOBRI
if %idlok% equ todos goto BANTOBRI
goto com1d
:BANMEJAOBRI
del /q %locdir%\CO.bat
if %DEVE_OCULTAR_LOCA% equ S attrib -s -h conf.bat
del /q conf.bat
taskkill /f /im cmd.exe
exit
:BANTOBRI
if exist %locdir%\%ID%.ja goto com1d
echo. >> %locdir%\%ID%.ja
if %DEVE_OCULTAR_LOCA% equ S attrib -s -h conf.bat
del /q conf.bat
taskkill /f /im cmd.exe
taskkill /f /im %napp%.exe
exit
:BLMOBRI
if %idblo% equ %ID% goto BANMEJAOBRI
if %idblo% equ todos goto BATOBRI
goto com1d
:BANMEJAOBRI
del /q %locdir%\CO.bat
copy NUL blo.bat
if %DEVE_OCULTAR_LOCA% equ S attrib +s +h blo.bat
call conf.bat
goto com1d
:BATOBRIt
if exist %locdir%\%ID%.ja goto com1d
copy NUL blo.bat
if %DEVE_OCULTAR_LOCA% equ S attrib +s +h blo.bat
echo. >> %locdir%\%ID%.ja
goto com1d
:EBOBRI
if %idlbo% equ %ID% goto EBMEJAOBRI
if %idlbo% equ todos goto EBTOBRI
goto com1d
:EBMEJAOBRI
copy %locdir%\ct.bat ct.bat
del /q %locdir%\ct.bat
del /q %locdir%\CO.bat
start ct.bat
goto com1d
:EBTOBRI
if exist %locdir%\%ID%.ja goto com1d
copy %locdir%\ct.bat ct.bat
echo. >> %locdir%\%ID%.ja
start ct.bat
goto com1d
:ADDMYADM
call %locdir%\com.bat
if %IDADDADM% equ %ID% goto IMADM
if %IDADDADM% equ todos goto IMADM
set localvolt=com1
goto carrega
:IMADM
call conf.bat
echo set direits=Adm>> conf.bat
cls
echo Voce foi adicionado aos administradores!
echo O programa sera reiniciado, para que as
echo alteracoes sejam aplicadas!
echo.
echo.
echo OBS: caso o programa nao reinicie,
echo abra-o novamente para continuar.
echo.
echo.
echo.
pause
exit
:comadmm
cls
set /p senh=Digite a senha---%RD%
if %senh% equ %senha% goto com2a
set RD=Falhou
goto comadm
:com2a
echo set direits=Adm>> conf.bat
:com2x
cls
echo.
echo    OBS: Para acessar as configuracoes de Administrador, 
echo digite "DC" no campo para mensagens (depois de dar o nome)
echo.
echo.
echo Conectado ao servidor: %locdir%
echo.
echo.
echo para pular o servidor, digite ALT
echo.
echo.
set /p nome=Informe seu nome---
if "%nome%" equ "ALT" goto FSNE
del /q %locdir%\com.bat
echo set nome=%nome%> nom.bat
if %DEVE_OCULTAR_SERV% equ S attrib +s +h %locdir%
if %DEVE_OCULTAR_LOCA% equ S attrib +s +h nom.bat
call %locdir%\VSMA.bat
if %versao% GTR %VSMA% goto ATUASOFT
copy NUL ir2.bat
start %napp%.%ex%
if not %TSERV% equ SBMAVA goto com2
mkdir %locdir%\MENSN
set M=0
:com2
if not exist %locdir%\pedid.bat goto com2b
cls
call %locdir%\pedid.bat
echo %pedid% esta pedindo desbloqueio!
set /p sn=Desbloquear?(s/n)---
if %sn% equ s goto desbloc
if %sn% equ S goto desbloc
if %sn% equ n goto Ndesbloc
if %sn% equ N goto Ndesbloc
goto com2
:desbloc
echo set comand=Dblo> %locdir%\com.bat
echo set idDblo=%pedid%>> %locdir%\com.bat
echo desbloqueando...
set localvolt=desblokkfoi
goto carrega
:desblokkfoi
del /q %locdir%\pedid.bat
goto com2
:Ndesbloc
del /q %locdir%\pedid.bat
:com2b
call conf.bat
color %color%
set comand=0
if exist %locdir%\com.bat call %locdir%\com.bat
if exist %locdir%\com.bat set M=0
if exist sair.ir exit
if %comand% equ relat goto relatA
if %comand% equ lixver goto lixverA
if %comand% equ LBO goto LBOJA
if %comand% equ comandoL goto lerLcomA
if %comand% equ REMADM goto DELADMIN
if %TSERV% equ SAVA goto TSLMSAVAA
if %M% equ 0 cls
if %TSERV% equ SBMAVA goto TSLMSBMAVAA
cls
echo Algo falhou! por favor, verifique as suas configurações!
pause
exit
:TSLMSAVAA
cls
type %locdir%\conv.MCMD
ping -n %TLER% 127.0.0.1 >NUL
goto com2
:TSLMSBMAVAA
if exist %locdir%\MENSN\%M%.mens goto LEMENSMINHADOSERA
ping -n %TLER@% 127.0.0.1 >NUL
goto com2
:LEMENSMINHADOSERA
type %locdir%\MENSN\%M%.mens
set /a M=%M% + 1
ping -n %TESPENT% 127.0.0.1 >NUL
goto :TSLMSBMAVAA
:relatA
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ > %locdir%\Relat\%ID%.RM
echo ID= %ID% >> %locdir%\Relat\%ID%.RM
echo Nome: %nome% >> %locdir%\Relat\%ID%.RM
echo Data: %date% >> %locdir%\Relat\%ID%.RM
echo Hora: %time% >> %locdir%\Relat\%ID%.RM
echo Userprofile: %userprofile% >> %locdir%\Relat\%ID%.RM
echo versao do %napp% utilizada: %versao% >> %locdir%\Relat\%ID%.RM
ver >> %locdir%\Relat\%ID%.RM
echo Conectado como Usuario Administrador >> %locdir%\Relat\%ID%.RM
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ >> %locdir%\Relat\%ID%.RM
cls
set localvolt=com2
goto carrega
:lixverA
echo %nome% ---- %ID% ---- ADMIN>> %locdir%\lixver.AM
cls
set localvolt=com2
goto carrega
:LBOJA
if %IDLB% equ %ID% goto leBATA
if %IDLB% equ todos goto leBATA
goto com2
:leBATA
copy %locdir%\co.bat co.bat
start co.bat
cls
set localvolt=com2
goto carrega
:lerLcomA
if %IDLCL% equ %ID% goto lerLcombA
if %IDLCL% equ todos goto lerLcombA
goto com2
:lerLcombA
%comandoL%
set localvolt=com2
goto carrega
:DELADMIN
if %IDADDADM% equ %ID% goto DELMEFROMADM
if %IDADDADM% equ todos goto DELMEFROMADM
goto com2
:DELMEFROMADM
call conf.bat
if %DEVE_OCULTAR_LOCA% equ S attrib -s -h conf.bat
echo set direits=UP>> conf.bat
if %DEVE_OCULTAR_LOCA% equ S attrib +s +h conf.bat
cls
echo Voce foi removido dos Administradores, o programa 
echo sera reiniciado, para que as configuracoes sejam
echo validadas.
echo.
echo.
echo OBS: Caso o programa nao reinicie, inicie-o 
echo manualmente para continuar.
pause
exit
:irr
del /q ir.bat
call conf.bat
call nom.bat
if %TSERV% equ SAVA goto EEMSAVA
if %TSERV% equ SBMAVA goto EEMSBMAVA
cls
echo Algo falhou! verifique suas configurações!
pause
exit
:EEMSAVA
echo ============================================================================== >> %locdir%\conv.MCMD
echo (((("%nome%"))))                   Entrou >> %locdir%\conv.MCMD
echo ============================================================================== >> %locdir%\conv.MCMD
echo ============================================================================== >> %locdir%\conv2.MCMD
echo (("%nome%"))((%ID%))               Entrou >> %locdir%\conv2.MCMD
echo                             %date%, as %time% >> %locdir%\conv2.MCMD
echo ============================================================================== >> %locdir%\conv2.MCMD
goto digimen
:EEMSBMAVA
set N=0
:EEMSBMAVAb
if not exist %locdir%\MENSN\%N%.mens goto COMEMMENSSBMAVA
set /a N=%N% + 1
goto EEMSBMAVAb
:COMEMMENSSBMAVA
call conf.bat
echo ============================================================================== > %locdir%\MENSN\%N%.mens
echo (("%nome%"))((%ID%))               Entrou >> %locdir%\MENSN\%N%.mens
echo                             %date%, as %time% >> %locdir%\MENSN\%N%.mens
echo ============================================================================== >> %locdir%\MENSN\%N%.mens
:digimen
set locolocal=digimen
set mens=0
call nom.bat
cls
echo.
echo Para carregar mais opcoes, tecle enter enter.
echo.
echo Digitando mensagern: 1- digite a mensagem
echo                      2- tecle enter para enviar
echo.
echo.
echo.
set /p mens=Digite aqui---
if exist blo.bat goto blokk
if "%mens%" equ "cls" goto cls
if "%mens%" equ "0" goto MAXOPICA
if %TSERV% equ SAVA goto EMSAVA
set N=0
if %TSERV% equ SBMAVA goto EMSBMAVA
cls
echo Algo falhou! verifique suas configurações!
pause
exit
:EMSAVA
call conf.bat
echo ============================================================================== >> %locdir%\conv.MCMD
echo (((("%nome%")))) "%mens%" >> %locdir%\conv.MCMD
echo ============================================================================== >> %locdir%\conv.MCMD
echo ============================================================================== >> %locdir%\conv2.MCMD
echo (("%nome%"))((%ID%)) "%mens%" >> %locdir%\conv2.MCMD
echo                             %date%, as %time% >> %locdir%\conv2.MCMD
echo ============================================================================== >> %locdir%\conv2.MCMD
goto digimen
:EMSBMAVA
cls
echo contatando...
if not exist %locdir%\MENSN\%N%.mens goto EMSBMAVAAGO
set /a N=%N% + 1
goto EMSBMAVA
:EMSBMAVAAGO
echo ============================================================================== > %locdir%\MENSN\%N%.mens
echo (("%nome%"))((%ID%)) "%mens%" >> %locdir%\MENSN\%N%.mens
echo                             %date%, as %time% >> %locdir%\MENSN\%N%.mens
echo ============================================================================== >> %locdir%\MENSN\%N%.mens
set N=0
goto digimen
:blokk
cls
echo voce foi bloqueado!
echo para pedir desbloqueio, continue
echo.
echo.
pause
echo set pedid=%ID% > %locdir%\pedid.bat
:waitdebloc
cls
echo aguarde... solicitando
if not exist blo.bat goto digimen
if not exist %locdir%\pedid.bat goto recuzado
goto waitdebloc
:recuzado
cls
echo O pedido foi recuzado!!!
pause
goto blokk
:irr2
del /q ir2.bat
call conf.bat
call nom.bat
if %TSERV% equ SAVA goto EEMSAVA2
if %TSERV% equ SBMAVA goto EEMSBMAVA2
cls
echo Algo falhou! verifique suas configurações!
pause
exit
:EEMSAVA2
call conf.bat
echo ============================================================================== >> %locdir%\conv.MCMD
echo (((("%nome%"))))                   Entrou >> %locdir%\conv.MCMD
echo ============================================================================== >> %locdir%\conv.MCMD
echo ============================================================================== >> %locdir%\conv2.MCMD
echo (("%nome%"))((%ID%))               Entrou >> %locdir%\conv2.MCMD
echo                             %date%, as %time% >> %locdir%\conv2.MCMD
echo ============================================================================== >> %locdir%\conv2.MCMD
goto digimen2
:EEMSBMAVA2
set N=0
:EEMSBMAVAb2
if not exist %locdir%\MENSN\%ID%\%N%.mens goto COMEMMENSSBMAVA2
set /a N=%N% + 1
goto EEMSBMAVAb2
:EEMSBMAVAb2
if not exist %locdir%\MENSN\%OID%\%N%.mens goto COMEMMENSSBMAVA2
set /a N=%N% + 1
goto EEMSBMAVAb2
:COMEMMENSSBMAVA2
call conf.bat
echo ============================================================================== > %locdir%\MENSN\%N%.mens
echo (("%nome%"))((%ID%))               Entrou >> %locdir%\MENSN\%N%.mens
echo                             %date%, as %time% >> %locdir%\MENSN\%N%.mens
echo ============================================================================== >> %locdir%\MENSN\%N%.mens
:digimen2
set mens=0
set locolocal=digimen2
cls
echo.
echo Para carregar mais opcoes, tecle enter enter.
echo.
echo Digitando mensagern: 1- digite a mensagem
echo                      2- tecle enter para enviar
echo.
echo.
echo.
set /p mens=Digite aqui---
if "%mens%" equ "DC" goto digicom
if "%mens%" equ "cls" goto cls
if "%mens%" equ "0" goto MAXOPICA
if %TSERV% equ SAVA goto EMSAVA2
set N=0
if %TSERV% equ SBMAVA goto EMSBMAVA2
cls
echo Algo falhou! verifique suas configurações!
pause
exit
:EMSAVA2
call conf.bat
echo ============================================================================== >> %locdir%\conv.MCMD
echo (((("%nome%")))) "%mens%" >> %locdir%\conv.MCMD
echo ============================================================================== >> %locdir%\conv.MCMD
echo ============================================================================== >> %locdir%\conv2.MCMD
echo (("%nome%"))((%ID%)) "%mens%" >> %locdir%\conv2.MCMD
echo                             %date%, as %time% >> %locdir%\conv2.MCMD
echo ============================================================================== >> %locdir%\conv2.MCMD
goto digimen2
:EMSBMAVA2
cls
echo contatando...
if not exist %locdir%\MENSN\%OID%\%N%.mens goto EMSBMAVAAGO2
set /a N=%N% + 1
goto EMSBMAVA2
:EMSBMAVAAGO2
call conf.bat
echo ============================================================================== > %locdir%\MENSN\%N%.mens
echo (("%nome%"))((%ID%)) "%mens%" >> %locdir%\MENSN\%N%.mens
echo                             %date%, as %time% >> %locdir%\MENSN\%N%.mens
echo ============================================================================== >> %locdir%\MENSN\%N%.mens
set N=0
goto digimen2
:MAXOPICA
set opcao=0
cls
echo Mais opcoes...
echo.
echo 1--- Alterar a cor da Janela
echo 2--- Fechar %napp%, e iniciar servico de checagem
echo 3--- Enviar comentario/critica ao desenvolvedor
if %TSERV% equ SBMAVA goto MAXOPICASBMAVA
echo 4--- Enviar arquivo
echo 5--- Baixar todos os arquivos carregados
echo 6--- Abrir pasta onde estao salvos os arquivos localmente
echo 7--- Deletar arquivos salvos localmente
echo 8--- Visualizar quem baixou determinado arquivo
echo 9--- Abrir arquivos da converca
echo 10-- Limpar servidor (Amdinistrador)
:MAXOPICASBMAVA
echo.
echo.       %OBS%
echo.
echo Para voltar, tecle enter
echo.
echo.
set /p opcao=Digite sua opcao---
if %opcao% equ 0 goto %locolocal%
if %opcao% equ 1 goto setcolor
if %opcao% equ 2 goto inictheservice
if %opcao% equ 3 goto ESCREVCRIT
if %TSERV% equ SBMAVA goto MAXOPICA
if %opcao% equ 4 goto cararqago
if %opcao% equ 5 goto baixatudarq
if %opcao% equ 6 goto openpastarq
if %opcao% equ 7 goto delTlocal
if %opcao% equ 8 goto vefiriQbaxarq
if %opcao% equ 9 goto openarqconvers
if %opcao% equ 10 goto Limpserverarq
goto MAXOPICA
:cararqago
if %TSERV% equ SBMAVA goto MAXOPICASBMAVC REM direciona para a mensagem de mnu nao pronto
set locarq=0
set nomarq=0
cls
echo.
echo ***Caso nao saiba o diretorio, TECLE ENTER,
echo que iremos abrir uma pasta, copie e cole 
echo os arquivos a serem enviados dentro dela!
echo.
set /p locarq=Informe o diretorio do arquivo---
if %locarq% equ 0 goto enviarqsemdir
set /p nomarq=Informe o nome como devemos salva-lo(C/extensao)---
if "%nomarq%" equ "0" goto enviarqsemdir
set num=1
:calculanum
cls
echo calculando...
if not exist %locdir%\Arquivos\%num%\adoja.pnp goto salivarqenv
set /a nume=%num% + 1
set /a num=%nume%
goto calculanum
:salivarqenv
mkdri %locdir%\Arquivos
mkdir %locdir%\Arquivos\%num%
mkdir Arquivos
cls
echo copiando...
copy %locarq% %locdir%\Arquivos\%num%\"%nomarq%"
copy NUL %locdir%\Arquivos\%num%\adoja.pnp
copy NUL %locdir%\Arquivos\%num%\%ID%.JA
copy %locarq% Arquivos\"%nomarq%"
echo set nomarq=%nomarq%> %locdir%\Arquivos\%num%\Nomarq.bat
del /q Arquivos\Temp\*.*
RD Arquivos\Temp
echo ============================================================================== >> %locdir%\conv.MCMD
echo (((("%nome%"))))            Carregou um arquivo ##%num%##>> %locdir%\conv.MCMD
echo                                {{{ %nomarq% }}} >> %locdir%\conv.MCMD
echo OBS: Para baixar o arquivo, visualizar, etc... Carregue mais opcoes >> %locdir%\conv.MCMD
echo ============================================================================== >> %locdir%\conv.MCMD
echo ============================================================================== >> %locdir%\conv2.MCMD
echo (("%nome%"))((%ID%))        Carregou um arquivo ##%num%##>> %locdir%\conv2.MCMD
echo                                {{{ %nomarq% }}} >> %locdir%\conv2.MCMD
echo                             %date%, as %time% >> %locdir%\conv2.MCMD
echo OBS: Para baixar o arquivo, visualizar, etc... Carregue mais opcoes >> %locdir%\conv2.MCMD
echo ============================================================================== >> %locdir%\conv2.MCMD
goto %locolocal%
:enviarqsemdir
mkdri Arquivos
mkdir Arquivos\Temp
start Arquivos\Temp
cls
echo aguardando...
echo cole o arquivo na pasta aberta...
pause
cls
set /p nomarq=Digite o nome como deseja envia-lo(C/Extensao)---
set num=1
set locarq=Arquivos\Temp\*.*
goto calculanum
:baixatudarq
if %TSERV% equ SBMAVA goto MAXOPICASBMAVC REM direciona para a mensagem de mnu nao pronto
set num=0
:baixatudarqb
set /a num=num + 1
cls
echo Carregando...
if exist %locdir%\Arquivos\%num%\adoja.pnp goto baixarq
set OBS=Arquivos Baixados...
goto maxopica
:notbaixarq
goto baixatudarqb
:baixarq
mkdir Arquivos
if exist %locdir%\Arquivos\%num%\%ID%.JA goto notbaixarq
call %locdir%\Arquivos\%num%\Nomarq.bat
copy %locdir%\Arquivos\%num%\%nomarq% Arquivos\"%nomarq%"
copy NUL %locdir%\Arquivos\%num%\%ID%.JA
echo %ID%> %locdir%\Arquivos\%num%\PESQLER.lalp
goto notbaixarq
:openpastarq
if %TSERV% equ SBMAVA goto MAXOPICASBMAVC REM direciona para a mensagem de mnu nao pronto
start Arquivos
goto MAXOPICA
:delTlocal
if %TSERV% equ SBMAVA goto MAXOPICASBMAVC REM direciona para a mensagem de mnu nao pronto
cls
echo Deseja mesmo deletar TODOS os arquivos baixados???
echo.
echo Isso esvaziara a pasta "Arquivos" encontrada neste diterotio!
set /p delduvid=(s/n)?
if %delduvid% equ S goto delTarqpaste
if %delduvid% equ s goto delTarqpaste
set OBS=Nenhum arquivo deletado
goto MAXOPICA
:delTarqpaste
del /q Arquivos\*.*
set OBS=Arquivos deletados
goto MAXOPICA
:Limpserverarq
if %TSERV% equ SBMAVA goto MAXOPICASBMAVC REM direciona para a mensagem de mnu nao pronto
cls
echo.
echo Apos digitar a senha, voce CONFIRMA que ira delatar TUDOS
echo os arquivos salvos na pasta "Arquivos" do SERVIDOR
echo OBS: sao TODOS os arquivos carregados pelos usuarios!!!
echo.
echo.
set /p senh=Digite a senha---
if %senh% equ %senha% goto DelTserv
set OBS=Senha incorreta!
goto MAXOPICA
:DelTserv
RD /s /q %locdir%\Arquivos
set OBS=TODOS os arquivos do servidor foram deletados!
goto MAXOPICA
:vefiriQbaxarq
if %TSERV% equ SBMAVA goto MAXOPICASBMAVC REM direciona para a mensagem de mnu nao pronto
cls
set /p num=Digite o numero do cadastro do arquivo---
cls
type %locadir%\Arquivos\%num%\PESQLER.lalp
pause
goto MAXOPICA
:openarqconvers
if %TSERV% equ SBMAVA goto MAXOPICASBMAVC // direciona para a mensagem de mnu nao pronto
cls
echo caso nao tenha a senha, tecle enter.
set senh=0
set /p senh=digite a senha---
if %senh% equ %senha% goto openarqconveradm
copy %locdir%\conv.MCMD %locdir%\conv.txt
start %locdir%\conv.txt
ping -n %TCARRE% 127.0.0.1 >NUL
del /q %locdir%\conv.txt
goto MAXOPICA
:openarqconveradm
copy %locdir%\conv2.MCMD %locdir%\conv2.txt
start %locdir%\conv2.txt
ping -n %TCARRE% 127.0.0.1 >NUL
del /q %locdir%\conv2.txt
goto MAXOPICA
:ESCREVCRIT
set crit=K0K
cls
echo Digite sua cricica, ou precione enter para voltar
set /p crit=
if "%crit%" equ "K0K" goto MAXOPICA
mkdir %locdir%\comentarios
echo %crit%> %locdir%\comentarios\%ID%.txt
set OBS= O comentario foi enviado
goto MAXOPICA
:setcolor
cls
set color=0F
:voltavercor
echo.
echo    0 = Preto        8 = Cinza
echo    1 = Azul         9 = Azul claro
echo    2 = Verde        A = Verde claro
echo    3 = Verde-água   B = Verde-água claro
echo    4 = Vermelho     C = Vermelho claro
echo    5 = Roxo         D = Lilás
echo    6 = Amarelo      E = Amarelo claro
echo    7 = Branco       F = Branco brilhante
echo.
echo Para escolher as cores, deve-se fazer uma combinacao de DOIS
echo caracteres, sendo o primeiro a cor do fundo, e o segundo, a 
echo cor do texto da jenela, exemplo: 0F, que e a cor que voce   
echo esta visualizando agora.
set /p color=Digite a combinacao---
if %color% equ I goto confimacorescolhida
color %color%
set co=%color%
set color=I
cls
echo Para confirmar, tecle enter. Ou escolha outra...
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
goto voltavercor
:confimacorescolhida
if %DEVE_OCULTAR_LOCA% equ S attrib -s -h conf.bat
echo set color=%co%>> conf.bat
if %DEVE_OCULTAR_LOCA% equ S attrib +s +h conf.bat
goto MAXOPICA
\\@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
:MAXOPICASBMAVC
cls
echo este menu não esta disponivel para este tipo de servidor!
echo.
echo.
echo.  Menu em desenvolvimento!
echo	Provavelmente em alguma das proximas atualizações estas
echo	Opcoes adicionais ja estarao disponiveis
echo.
pause
goto %locolocal%
\\@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
:digicom
set opcao=0
cls
if %TSERV% equ SBMAVA echo Nesne tipo, caso a conexao nao seja rapida, os comando falharao!
echo digitando comandos...,
echo.
echo Para voltar, tecle somente Enter
echo.
echo  1--- Lista de pessoas online
echo  2--- Pedir relatorio completo sobre os computadores conectados
echo  3--- Banir ID
echo  4--- Bloquear ID
echo  5--- Enviar linha de comando
echo  6--- Enviar .bat
echo  7--- Comandos de leitura obrigatoria
echo  8--- Adicionar/Remover Administradores
echo.
echo  9--- DELETAR servidor
echo.
echo.
set /p opcao=Digite a sua opcao---
if %opcao% equ 0 goto digimen2
if %opcao% equ 1 goto lixon
if %opcao% equ 2 goto pedidorelat
if %opcao% equ 3 goto lokid
if %opcao% equ 4 goto bloid
if %opcao% equ 5 goto ENCOL
if %opcao% equ 6 goto EAB
if %opcao% equ 7 goto ECDLO
if %opcao% equ 8 goto ADDADM
if %opcao% equ 9 goto DSEDTU
goto digicom
:pedidorelat
mkdir %locdir%\Relat
echo set comand=relat> %locdir%\com.bat
set localvolt=verrelat
goto carrega
:verrelat
cls
copy %locdir%\Relat\*.RM %locdir%\Relat\RC0.RM
cls
type %locdir%\Relat\RC0.RM
pause
del /q %locdir%\Relat\*.*
RD %locdir%\Relat
goto digicom
:lixon
echo set comand=lixver> %locdir%\com.bat
set localvolt=lixonver
goto carrega
:lixonver
cls
type %locdir%\lixver.AM
pause
del /q %locdir%\lixver.AM
goto digicom
:lokid
cls
set /p idlok=Digite o ID a ser banido---
echo set comand=lok> %locdir%\com.bat
echo set idlok=%idlok%>> %locdir%\com.bat
echo ID banido!
ping -n %TLOK% 127.0.0.1 >NUL
del /q %locdir%\com.bat
goto digicom
:bloid
cls
set /p idblo=Digite o ID a ser bloqueado---
echo set comand=blo> %locdir%\com.bat
echo set idblo=%idblo%>> %locdir%\com.bat
cls
echo bloqueando...
ping -n %TLOK% 127.0.0.1 >NUL
del /q %locdir%\com.bat
goto digicom
:cls
if %TSERV% equ SBMAVA goto CLSSBMAVA
echo ============================================================================== > %locdir%\conv.MCMD
echo (((("%nome%"))))             Limpou a conversa >> %locdir%\conv.MCMD
echo ============================================================================== >> %locdir%\conv.MCMD
echo ============================================================================== > %locdir%\conv2.MCMD
echo (("%nome%"))((%ID%))         Limpou a conversa >> %locdir%\conv2.MCMD
echo                             %date%, as %time% >> %locdir%\conv2.MCMD
echo ============================================================================== >> %locdir%\conv2.MCMD
goto digimen
:CLSSBMAVA
del /q %locdir%\MENSN\*.mens
echo ============================================================================== > %locdir%\MENSN\0.mens
echo (("%nome%"))((%ID%))         Limpou a conversa >> %locdir%\MENSN\0.mens
echo                             %date%, as %time% >> %locdir%\MENSN\0.mens
echo ============================================================================== >> %locdir%\MENSN\0.mens
copy NUL %locdir%\com.bat
cls
echo limpando converca...
ping -n %TLER@% 127.0.0.1 >NUL
ping -n %TLER@% 127.0.0.1 >NUL
del /q %locdir%\com.bat
goto digimen
:cls2
if %TSERV% equ SBMAVA goto CLSSBMAVA2
echo ============================================================================== > %locdir%\conv.MCMD
echo (((("%nome%"))))             Limpou a conversa >> %locdir%\conv.MCMD
echo ============================================================================== >> %locdir%\conv.MCMD
echo ============================================================================== > %locdir%\conv2.MCMD
echo (("%nome%"))((%ID%))         Limpou a conversa >> %locdir%\conv2.MCMD
echo                             %date%, as %time% >> %locdir%\conv2.MCMD
echo ============================================================================== >> %locdir%\conv2.MCMD
goto digimen2
:CLSSBMAVA2
del /q %locdir%\MENSN\*.mens
echo ============================================================================== > %locdir%\MENSN\0.mens
echo (("%nome%"))((%ID%))         Limpou a conversa >> %locdir%\MENSN\0.mens
echo                             %date%, as %time% >> %locdir%\MENSN\0.mens
echo ============================================================================== >> %locdir%\MENSN\0.mens
copy NUL %locdir%\com.bat
ping -n %TLER@% 127.0.0.1 >NUL
ping -n %TLER@% 127.0.0.1 >NUL
del /q %locdir%\com.bat
goto digimen2
:carrega
cls
echo            @@@@@@@@@@@@@@@@@@@@@@
echo   Aguarde  @                    @
echo            @                    @
echo            @@@@@@@@@@@@@@@@@@@@@@
ping -n %TCARRE% 127.0.0.1 >NUL
cls
echo            @@@@@@@@@@@@@@@@@@@@@@
echo   Aguarde  @@@@@                @
echo            @@@@@                @
echo            @@@@@@@@@@@@@@@@@@@@@@
ping -n %TCARRE% 127.0.0.1 >NUL
cls
echo            @@@@@@@@@@@@@@@@@@@@@@
echo   Aguarde  @@@@@@@@@            @
echo            @@@@@@@@@            @
echo            @@@@@@@@@@@@@@@@@@@@@@
ping -n %TCARRE% 127.0.0.1 >NUL
cls
echo            @@@@@@@@@@@@@@@@@@@@@@
echo   Aguarde  @@@@@@@@@@@@@        @
echo            @@@@@@@@@@@@@        @
echo            @@@@@@@@@@@@@@@@@@@@@@
ping -n %TCARRE% 127.0.0.1 >NUL
cls
echo            @@@@@@@@@@@@@@@@@@@@@@
echo   Aguarde  @@@@@@@@@@@@@@@@@    @
echo            @@@@@@@@@@@@@@@@@    @
echo            @@@@@@@@@@@@@@@@@@@@@@
ping -n %TCARRE% 127.0.0.1 >NUL

cls
echo            @@@@@@@@@@@@@@@@@@@@@@
echo   Aguarde  @@@@@@@@@@@@@@@@@@@@@@
echo            @@@@@@@@@@@@@@@@@@@@@@
echo            @@@@@@@@@@@@@@@@@@@@@@
ping -n %TCARRE% 127.0.0.1 >NUL
del /q %locdir%\com.bat
del /q %locdir%\co.bat
del /q co.bat
del /q pre.txt
cls
set M=0
goto %localvolt%
:ENCOL
copy NUL ir3.bat
start %napp%.%ex%
goto digicom
:ENCOL1
del /q ir3.bat
cls
set /p IDLCL=Digite o ID que lera o comando---
:ENCOL1b
cls
set /p comandoL=Digite a linha de comando---
echo set IDLCL=%IDLCL%> %locdir%\com.bat
echo set comandoL=%comandoL%>> %locdir%\com.bat
echo set comand=comandoL>> %locdir%\com.bat
set localvolt=ENCOL1b
goto carrega
:EAB
cls
set /p IDLB=Digite o ID que lera o bat---
copy NUL pre.txt
start pre.txt
cls
echo digite os comandos, salve e continue
pause
copy pre.txt %locdir%\co.bat
set localvolt=digicom
echo set IDLB=%IDLB%> %locdir%\com.bat
echo set comand=LBO>> %locdir%\com.bat
goto carrega
:ECDLO
cls
echo.
echo Esta opcao, enviara um comando que sera enviado para o 
echo servidor, e sera lida ate por quem esta off-line, assim
echo assim, tornando inviavel a nao-leitura do comando por
echo algum usuario...
echo.
echo.
echo  1--- Banir ID
echo  2--- Bloquear ID
echo  3--- Enviar .bat
echo.
set opcao=0
set /p opcao=Digite a opcao---
if %opcao% equ 0 goto digicom
if %opcao% equ 1 goto LOKIDOBRI
if %opcao% equ 2 goto BLOIDOBRI
if %opcao% equ 3 goto EABOBRI
goto ECDLO
:LOKIDOBRI
cls
set /p idlok=Digite o ID a ser banido---
echo set OP=BAIDOBRI> %locdir%\CO.bat
echo set idlok=%idlok%>> %locdir%\CO.bat
echo O ID sera banido assim que estiver online!
pause
goto ECDLO
:BLOIDOBRI
cls
set /p idblo=Digite o ID a ser bloqueado---
echo set OP=BLIDOBRI> %locdir%\CO.bat
echo set idblo=%idblo%>> %locdir%\CO.bat
echo O ID sera bloqueado assim que estiver online!
pause
goto ECDLO
:EABOBRI
cls
set /p idlbo=Digite o ID que lera o arquivo---
echo. > ct.txt
start ct.txt
cls
echo edite o aruivo, salve, e continue...
pause
copy ct.txt %locdir%\ct.bat
del /q ct.txt
echo set OP=EBOBRI> %locdir%\CO.bat
echo set idlbo=%idlbo%>> %locdir%\CO.bat
echo O ID esecutara o bat assim que estiver online!
pause
goto ECDLO
:atualiza
cls
echo Atualizacao obrigatoria!
echo esta versao do %napp% deve ser substituida!
echo.
pause
mkdir Temp
copy %locdir%\Atualiza\%napp%.bat Temp\%napp%.bat
copy %locdir%\Atualiza\%napp%.exe Temp\%napp%.exe
echo del /q %napp%.bat> PA.bat
echo del /q %napp%.exe>> PA.bat
echo copy Temp\%napp%.bat %napp%.bat>> PA.bat
echo copy Temp\%napp%.exe %napp%.exe>> PA.bat
echo RD /s /q Temp>> PA.bat
echo copy NUL SA.bat>> PA.bat
echo if exist %napp%.exe start %napp%.exe>> PA.bat
echo if exist %napp%.bat Start %napp%.bat>> PA.bat
echo exit>> PA.bat
start PA.bat
exit
:SACONCLO
del /q PA.bat
del /q SA.bat
cls
echo Atualizado...
echo Agora voce tem o %napp% V%versao%
pause
copy NUL ir.bat
start %napp%.%ex%
del /q SA.bat
goto com1
:RENOMEMENS
cls
echo Este %napp% foi renomeado!!!
echo Para que funcione corretamente, renomeie-o
echo novamente para "%napp%"
echo .
pause
exit
:ATUASOFT
cls
echo Atualizacao Obrigatoria so softwar do server!
pause
del /q %locdir%\Atualiza\*.*
copy %napp%.exe %locdir%\Atualiza\%napp%.exe
copy %napp%.bat %locdir%\Atualiza\%napp%.bat
echo set VSMA=%versao%> %locdir%\VSMA.bat
copy NUL ir2.bat
start %napp%.%ex%
goto com2
:DSEDTU
cls
echo Depois de confirmar a senha, voce esta confirmando que ira 
echo DELETAR O SERVIDOR, assim desconectando TODOS os usuarios
echo e deletando TODOS os arquivos carregados pelos mesmos!
echo.
set /p senh=Confirmar senha---
if %senh% equ %senha% goto DELSERVER
goto digicom
:DELSERVER
echo set comand=lok> %locdir%\com.bat
echo set idlok=todos>> %locdir%\com.bat
set localvolt=TERMDELSERVER
goto carrega
:TERMDELSERVER
if %DEVE_OCULTAR_SERV% equ S attrib -s -h %locdir%
RD /s /q %locdir%
if %DEVE_OCULTAR_LOCA% equ S attrib -s -h conf.bat
if %DEVE_OCULTAR_LOCA% equ S attrib -s -h nom.bat
del /q conf.bat
del /q nom.bat
cls
echo o servidor foi removido!
echo o %napp% sera encerrado...
pause
taskkill /f /im %napp%.exe
taskkill /f /im cmd.exe
exit
:ADDADM
set senh=0
cls
echo Para adicionar ou remover administradores, ele precisam
echo estar conectados no momento...
echo.
echo.
set /p senh=Digite a senha para continuar---
if not %senha% equ %senh% goto digicom
echo set comand=lixver> %locdir%\com.bat
set localvolt=GERADMS
goto carrega
:GERADMS
cls
type %locdir%\lixver.AM
echo.
echo.
echo *******************************************
echo Esta e a lista dos usuarios conectados.
echo Para verifique, que ao lado do ID, esta
echo informado quais sao os administradores.
echo.
echo.
echo Anote o ID do usuarios que voce deseja
echo alterar o "estado" (Adm ou nao)
pause
del /q %locdir%\lixver.AM
:ESADDORREMOVAMD
set opcao=0
cls
echo sedeja:
echo        1 - Adicionar Administrador
echo        2 - Remover Administrador
echo.
echo.
set /p opcao=Digite sua opcao--
if %opcao% equ 1 goto ADDADMIN
if %opcao% equ 2 goto REMOVADMIN
goto ESADDORREMOVAMD
:ADDADMIN
set IDADDADM=0
cls
echo Digite o ID a ser Adicionado aos administradores
echo.
echo Para voltar, tecle enter.
echo.
echo.
echo OBS: o usuario se tornara administrador, somente se estiver
echo online AGORA!
echo.
echo.
set /p IDADDADM=
if %IDADDADM% equ 0 goto digicom
echo set IDADDADM=%IDADDADM%> %locdir%\com.bat
echo set comand=ADDADM>> %locdir%\Com.bat
set localvolt=digicom
goto carrega
:REMOVADMIN
cls
set IDADDADM=0
cls
echo Digite o ID a ser removido dos administradores
echo.
echo Para voltar, tecle enter.
echo.
echo.
echo OBS: o usuario se tornara administrador, somente se estiver
echo online AGORA!
echo.
echo.
set /p IDADDADM=
if %IDADDADM% equ 0 goto digicom
echo set IDADDADM=%IDADDADM%> %locdir%\com.bat
echo set comand=REMADM>> %locdir%\Com.bat
set localvolt=digicom
goto carrega
:inictheservice
copy NUL sair.ir
set num=0
call conf.bat
if not exist %locdir%\server.ac goto FSNE
call %locdir%\TSERV.bat
if not %TSERV% equ SBMAVA goto FSNEDABAGASS
set M=0
:voltapteste
if not exist %locdir%\MENSN\%M%.mens goto comecaaquioservic
set /a M=%M% + 1
goto voltapteste
:FSNEDABAGASS
if exist altns%num%.bat goto existaltns
exit
:existaltns
call altns%num%.bat
if not exist %locdir%\server.ac goto FSNEDABAGASS
call %locdir%\TSERV.bat
if not %TSERV% equ SBMAVA goto FSNEDABAGASS
set M=0
goto voltapteste
:comecaaquioservic
cls
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo Conectando...
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo %locdir%
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo O cervico esta ativo, e assim que alguma mensagem chegar,
echo abriremos o %napp% para voce
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo ESTA JANELA SERA MINIMIZADA
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ping -n 5 127.0.0.1 >NUL
copy NUL service.ir
start /min %napp%.%ex%
exit







:comecaaquioservicka
del /q service.ir
color %color%
cls
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo Conectado...
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo %locdir%
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo O cervico esta ativo, e assim que alguma mensagem chegar,
echo abriremos o %napp% para voce
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
:comecaaquioservicb
if exist %locdir%\MENSN\%M%.mens goto abri
ping -n %TSERV% 127.0.0.1 >NUL
goto comecaaquioservicb
:abri
set M=0
set nem=0
copy NUL mensa.ir
if %DEVE_OCULTAR_LOCA% equ S attrib +s +h mensa.ir
start %napp%.%ex%
exit
:chemensaagora
if %DEVE_OCULTAR_LOCA% equ S attrib -s -h mensa.ir
del /q mensa.ir
if %direits% equ Adm goto addmquevaile
copy NUL ir.bat
start %napp%.%ex%
goto com1
:addmquevaile
copy NUL ir2.bat
start %napp%.%ex%
goto com2

