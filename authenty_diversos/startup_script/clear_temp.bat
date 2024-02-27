@echo off
title Limpando arquivos temporarios


:ini
	cls
	echo Limpando arquivos temporarios
	call :limpaDiretorio "%userprofile%\ESA22.1\Temp"
	call :limpaDiretorio "%userprofile%\Documents\ESA22.1\Autosave"
	call :forcaLimpezaPasta "%userprofile%\Downloads"
	call :forcaLimpezaPasta "%userprofile%\Desktop"
	exit


:forcaLimpezaPasta
	if exist %1 (
		set "encontrouArquivos="
		for %%i in (%1\*) do (
			if "%%~xi" neq ".lnk" (
				set "encontrouArquivos=1"
			)
		)
		if defined encontrouArquivos (
    			cls
			color 4E
			echo ########################
			echo #                      #
			echo #     @                #
			echo #    @ @               #
			echo #   @ ! @     Atencao! #
			echo #  @  !  @             #
			echo # @@@@@@@@@            #
			echo #                      #
			echo ########################
			echo.
			echo Existem arquivos na pasta %1 !!
			echo Favor excluir ou salvar em local adequado!
			echo.
			echo.
			pause
			color
			goto forcaLimpezaPasta
		)
	) else (
		echo O diretorio %1 nao existe
	)
	goto :eof


:limpaDiretorio
	if exist %1 (
		echo Limpando o diretorio %1
		for /D %%i in (%1\*) do (
			rd /Q /S "%%i"
		)
		del /Q /S %1\*.*
	) else (
		echo O diretorio %1 nao existe
	)
	goto :eof