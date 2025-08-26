# Script de Startup - Windows

Este script (primeira versão em `.bat` e a atual em `python`) limpa diretórios do SCIA e lembra o usuário a excluir arquivos das pastas de downloads.

---

## Instalando dependências

Para instalar o Python use:
```ps1
winget install --id Python.Python.3 --scope machine --source winget --silent --accept-package-agreements --accept-source-agreements
```

## Instalando o Script

### Método 1: "Manual"

Para instalar no Startup Global (todos usuários) use:
```ps1
$startupPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
$url = "https://raw.githubusercontent.com/williampilger/utilidades_gerais/master/authenty_diversos/startup_script/clear_temp.pyw"
$destFile = Join-Path $startupPath "clear_temp.pyw"
Invoke-WebRequest -Uri $url -OutFile $destFile -UseBasicParsing
```

Caso a ideia seja instalar apenas para um usuário, se deve usar o diretório `C:\Users\<usuario>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`.

### Método 2: NÃO TESTADO! (usando um atalho, segundo o chat, é mais garantido)

```ps1
# === Executar no PowerShell como Administrador ===

# 1) Definições
$Url = "https://raw.githubusercontent.com/williampilger/utilidades_gerais/master/authenty_diversos/startup_script/clear_temp.pyw"
$StartupGlobal = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
$ScriptPath = Join-Path $StartupGlobal "clear_temp.pyw"
$ShortcutPath = Join-Path $StartupGlobal "ClearTemp.lnk"

# Ajuste o caminho do pythonw.exe se a versão for diferente
$PythonwCandidates = @(
  "C:\Program Files\Python313\pythonw.exe",
  "C:\Program Files\Python312\pythonw.exe",
  "C:\Program Files\Python311\pythonw.exe",
  "C:\Users\$env:USERNAME\AppData\Local\Programs\Python\Python312\pythonw.exe"
) | Where-Object { Test-Path $_ }

if (-not $PythonwCandidates) {
  Write-Host "pythonw.exe não encontrado. Instale o Python (ex.: winget install --id Python.Python.3.12 --scope machine) e rode este script novamente." -ForegroundColor Yellow
  return
}
$Pythonw = $PythonwCandidates[0]

# 2) Baixar (com Marca da Web) e em seguida tirar a marca (Unblock-File)
try {
  Invoke-WebRequest -Uri $Url -OutFile $ScriptPath -UseBasicParsing
} catch {
  Write-Error "Falha ao baixar o script: $($_.Exception.Message)"
  return
}

# Remove a 'Mark-of-the-Web' que pode bloquear execução no Startup
try { Unblock-File -Path $ScriptPath } catch {}

# 4) Criar atalho (forma mais confiável de inicialização)
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $Pythonw
$Shortcut.Arguments  = $ScriptPath
$Shortcut.WorkingDirectory = Split-Path $ScriptPath
$Shortcut.Description = "Executa clear_temp.pyw no logon (todos os usuários)"
$Shortcut.WindowStyle = 7
$Shortcut.Save()

Write-Host "Script salvo em: $ScriptPath"
Write-Host "Atalho criado em: $ShortcutPath"
Write-Host "Pronto. Faça logoff/logon e depois confira (se existir) o log: $LogFile"

```

---

## Apenas Baixar

Para BAIXAR o arquivo pelo PowerShell use:

```p1
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/williampilger/utilidades_gerais/master/authenty_diversos/startup_script/clear_temp.pyw" -OutFile "clear_temp.pyw"
```
