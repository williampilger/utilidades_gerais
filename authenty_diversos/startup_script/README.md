# Script de Startup - Windows

Este script (primeira versão em `.bat` e a atual em `python`) limpa diretórios do SCIA e lembra o usuário a excluir arquivos das pastas de downloads.

Para instalar no Startup Global (todos usuários) use:
```ps1
$startupPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
$url = "https://raw.githubusercontent.com/williampilger/utilidades_gerais/master/authenty_diversos/startup_script/clear_temp.pyw"
$destFile = Join-Path $startupPath "clear_temp.pyw"
Invoke-WebRequest -Uri $url -OutFile $destFile -UseBasicParsing
```

Caso a ideia seja instalar apenas para um usuário, se deve usar o diretório `C:\Users\<usuario>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`.

Para BAIXAR o arquivo pelo PowerShell use:
```p1
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/williampilger/utilidades_gerais/master/authenty_diversos/startup_script/clear_temp.pyw" -OutFile "clear_temp.pyw"
```
