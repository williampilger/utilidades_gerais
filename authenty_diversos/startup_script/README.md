# Script de Startup - Windows

Este script (primeira versão em `.bat` e a atual em `python`) limpa diretórios do SCIA e lembra o usuário a excluir arquivos das pastas de downloads.

---

## Instalando dependências

Para instalar o Python use:
```ps1
winget install --id Python.Python.3 --scope machine --source winget --silent --accept-package-agreements --accept-source-agreements
```

## Instalando o Script

### Método 1: Deixando o script diretamente no startup

Para instalar no Startup Global (todos usuários) use:
```ps1
$startupPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
$url = "https://raw.githubusercontent.com/williampilger/utilidades_gerais/master/authenty_diversos/startup_script/clear_temp.pyw"
$destFile = Join-Path $startupPath "clear_temp.pyw"
Invoke-WebRequest -Uri $url -OutFile $destFile -UseBasicParsing
```

Caso a ideia seja instalar apenas para um usuário, se deve usar o diretório `C:\Users\<usuario>\AppData\Roaming\Microsoft\Windows\'Start Menu'\Programs\Startup`.

### Método 2: NÃO TESTADO ⚠️ (usando um atalho, segundo alguns, é melhor prática)

```ps1
# === Executar no PowerShell como Administrador ===

$Url = "https://raw.githubusercontent.com/williampilger/utilidades_gerais/master/authenty_diversos/startup_script/clear_temp.pyw"
$ScriptFolder = "C:\scripts"
New-Item -Path $ScriptFolder -ItemType Directory -Force | Out-Null
$ScriptPath = Join-Path $ScriptFolder "clear_temp.pyw"
$StartupGlobal = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
$ShortcutPath = Join-Path $StartupGlobal "ClearTemp.lnk"
$Pythonw = @(
  "C:\Program Files\Python313\pythonw.exe",
  "C:\Program Files\Python312\pythonw.exe",
  "C:\Program Files\Python311\pythonw.exe",
  "C:\Users\$env:USERNAME\AppData\Local\Programs\Python\Python312\pythonw.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1
Invoke-WebRequest -Uri $Url -OutFile $ScriptPath
Unblock-File -Path $ScriptPath
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $Pythonw
$Shortcut.Arguments = "`"$ScriptPath`""
$Shortcut.WorkingDirectory = $ScriptFolder
$Shortcut.Description = "Executa clear_temp.pyw no logon (todos os usuários)"
$Shortcut.WindowStyle = 7
$Shortcut.Save()

```

---

## Apenas Baixar

Para BAIXAR o arquivo pelo PowerShell use:

```p1
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/williampilger/utilidades_gerais/master/authenty_diversos/startup_script/clear_temp.pyw" -OutFile "clear_temp.pyw"
```
