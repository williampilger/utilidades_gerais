#Requires -Version 5.1
<#
=============================================================================
  llamafile.ps1 — LLM local portátil para programação (Windows 10/11)

  Uso:   powershell -ExecutionPolicy Bypass -File .\llamafile.ps1
         powershell -ExecutionPolicy Bypass -File .\llamafile.ps1 -Model 4

  Variáveis opcionais (ambiente):
     LLAMAFILE_HOME  pasta de dados (padrão: pasta do script)
     PORT            porta do servidor (padrão: 8080)
     CTX             contexto em tokens (padrão: 16384)
     HOST            bind (padrão: 127.0.0.1; use 0.0.0.0 p/ expor na rede)

  Ao encerrar o script (Ctrl+C, fechar a janela, matar o processo), o
  llamafile é encerrado junto (Job Object com KILL_ON_JOB_CLOSE).
=============================================================================
#>
param([int]$Model = 0)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# ---------------------------------------------------------------- config -----
$ScriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Join-Path (Get-Location) 'llamafile-portable' }
$Base      = if ($env:LLAMAFILE_HOME) { $env:LLAMAFILE_HOME } else { $ScriptDir }
$BinDir    = Join-Path $Base 'bin'
$ModelsDir = Join-Path $Base 'models'
$Bin       = Join-Path $BinDir 'llamafile.exe'
$LogOut    = Join-Path $Base 'llamafile.log'
$LogErr    = Join-Path $Base 'llamafile.err.log'

$Port  = if ($env:PORT) { [int]$env:PORT } else { 8080 }
$Ctx   = if ($env:CTX)  { [int]$env:CTX  } else { 16384 }
$BindHost = if ($env:HOST) { $env:HOST } else { '127.0.0.1' }
$Quant = 'Q4_K_M'

$LlamafileFallbackUrl = 'https://huggingface.co/mozilla-ai/llamafile_0.10/resolve/main/llamafile_0.10.1'

$Models = @(
  @{ Name='Qwen2.5-Coder 1.5B';              Repo='Qwen/Qwen2.5-Coder-1.5B-Instruct-GGUF';      Size='~1 GB';   Desc='autocomplete, PC fraco' }
  @{ Name='Qwen2.5-Coder 3B';                Repo='Qwen/Qwen2.5-Coder-3B-Instruct-GGUF';        Size='~2 GB';   Desc='notebook sem GPU' }
  @{ Name='Qwen3.5 4B';                      Repo='unsloth/Qwen3.5-4B-GGUF';                    Size='~3 GB';   Desc='generalista leve, tool calling' }
  @{ Name='Qwen2.5-Coder 7B  [recomendado]'; Repo='Qwen/Qwen2.5-Coder-7B-Instruct-GGUF';        Size='~4.7 GB'; Desc='TS/React/SQL, 16 GB RAM' }
  @{ Name='Qwen3.5 9B';                      Repo='unsloth/Qwen3.5-9B-GGUF';                    Size='~5.5 GB'; Desc='raciocínio / agente' }
  @{ Name='Qwen2.5-Coder 14B';               Repo='Qwen/Qwen2.5-Coder-14B-Instruct-GGUF';       Size='~9 GB';   Desc='GPU 12-16 GB' }
  @{ Name='Qwen3-Coder 30B-A3B (MoE)';       Repo='unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF';  Size='~18 GB';  Desc='32 GB RAM, roda até em CPU' }
)

# ---------------------------------------------------------------- utils ------
function Info($m) { Write-Host "==> $m" -ForegroundColor Green }
function Warn($m) { Write-Host "!!  $m" -ForegroundColor Yellow }
function Die($m)  { Write-Host "xx  $m" -ForegroundColor Red; exit 1 }

if (-not (Get-Command curl.exe -ErrorAction SilentlyContinue)) {
  Die 'curl.exe não encontrado (vem no Windows 10 1803+). Atualize o Windows.'
}

function Download([string]$Url, [string]$Out) {
  # curl.exe: progresso, retomada (-C -) e bem mais rápido que Invoke-WebRequest
  & curl.exe -L --fail --retry 3 -C - --progress-bar -o "$Out.part" $Url
  if ($LASTEXITCODE -ne 0) { return $false }
  Move-Item -Force "$Out.part" $Out
  return $true
}

# Job Object: quando o PowerShell morrer (inclusive janela fechada no X),
# o Windows fecha o handle do job e mata os processos associados.
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class LfJob {
  [StructLayout(LayoutKind.Sequential)] struct BASIC {
    public long PerProcessUserTimeLimit; public long PerJobUserTimeLimit; public uint LimitFlags;
    public UIntPtr MinimumWorkingSetSize; public UIntPtr MaximumWorkingSetSize; public uint ActiveProcessLimit;
    public UIntPtr Affinity; public uint PriorityClass; public uint SchedulingClass; }
  [StructLayout(LayoutKind.Sequential)] struct IO { public ulong a, b, c, d, e, f; }
  [StructLayout(LayoutKind.Sequential)] struct EXT {
    public BASIC Basic; public IO Io; public UIntPtr ProcessMemoryLimit; public UIntPtr JobMemoryLimit;
    public UIntPtr PeakProcessMemoryUsed; public UIntPtr PeakJobMemoryUsed; }
  [DllImport("kernel32.dll", CharSet = CharSet.Unicode)] static extern IntPtr CreateJobObject(IntPtr a, string n);
  [DllImport("kernel32.dll")] static extern bool SetInformationJobObject(IntPtr h, int c, ref EXT i, uint l);
  [DllImport("kernel32.dll")] static extern bool AssignProcessToJobObject(IntPtr j, IntPtr p);
  static IntPtr job = IntPtr.Zero;
  public static bool Attach(IntPtr process) {
    if (job == IntPtr.Zero) {
      job = CreateJobObject(IntPtr.Zero, null);
      EXT e = new EXT(); e.Basic.LimitFlags = 0x2000; // JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE
      SetInformationJobObject(job, 9, ref e, (uint)Marshal.SizeOf(typeof(EXT)));
    }
    return AssignProcessToJobObject(job, process);
  }
}
'@

# ---------------------------------------------------------------- binário ----
function Ensure-Llamafile {
  if (Test-Path $Bin) { return }
  New-Item -ItemType Directory -Force $BinDir | Out-Null
  Info 'Baixando llamafile (última release)...'
  $url = $null
  try {
    $rel = Invoke-RestMethod 'https://api.github.com/repos/mozilla-ai/llamafile/releases/latest'
    $url = ($rel.assets | Where-Object { $_.name -match '^llamafile(-[0-9][0-9.]*)?$' } |
            Select-Object -First 1).browser_download_url
  } catch { }
  if (-not $url) { Warn 'Não consegui consultar o GitHub; usando fallback.'; $url = $LlamafileFallbackUrl }
  Write-Host "   $url"
  if (-not (Download $url $Bin)) { Die 'Falha ao baixar o llamafile.' }
  Unblock-File $Bin -ErrorAction SilentlyContinue
}

# ---------------------------------------------------------------- modelos ----
function Get-ModelDir($repo) { Join-Path $ModelsDir ($repo -replace '/', '__') }

function Get-FirstGguf($dir) {
  Get-ChildItem -Path $dir -Filter *.gguf -File -ErrorAction SilentlyContinue |
    Sort-Object Name | Select-Object -First 1 -ExpandProperty FullName
}

function Ensure-Model($repo) {
  $dir = Get-ModelDir $repo
  New-Item -ItemType Directory -Force $dir | Out-Null
  if (Test-Path (Join-Path $dir '.complete')) { return Get-FirstGguf $dir }

  Info "Listando arquivos de $repo ..."
  $tree = Invoke-RestMethod "https://huggingface.co/api/models/$repo/tree/main?recursive=true"
  $all  = $tree | Where-Object { $_.type -eq 'file' } | ForEach-Object { $_.path } |
          Where-Object { $_ -match "(^|[/_.-])$Quant(-\d{5}-of-\d{5})?\.gguf$" -and $_ -notmatch 'mmproj' } |
          Sort-Object
  $files = @($all | Where-Object { $_ -notmatch 'UD-' })   # prefere a quantização "padrão"
  if ($files.Count -eq 0) { $files = @($all) }              # senão aceita a Unsloth Dynamic
  if ($files.Count -eq 0) { Die "Nenhum arquivo $Quant encontrado em $repo." }

  foreach ($f in $files) {
    $name = Split-Path $f -Leaf
    Info "Baixando $name"
    if (-not (Download "https://huggingface.co/$repo/resolve/main/$f" (Join-Path $dir $name))) {
      Die "Falha no download de $f"
    }
  }
  New-Item -ItemType File -Force (Join-Path $dir '.complete') | Out-Null
  return Get-FirstGguf $dir
}

function Choose-Model([int]$choice) {
  if ($choice -eq 0) {
    Write-Host ''
    Write-Host "Modelos disponíveis ($Quant):" -ForegroundColor White
    for ($i = 0; $i -lt $Models.Count; $i++) {
      $m = $Models[$i]
      $done = Test-Path (Join-Path (Get-ModelDir $m.Repo) '.complete')
      $mark = if ($done) { ' ✓ ' } else { '   ' }
      Write-Host $mark -NoNewline -ForegroundColor Green
      Write-Host ('{0,2}) {1,-32} {2,-8} {3}' -f ($i + 1), $m.Name, $m.Size, $m.Desc)
    }
    Write-Host '     (✓ = já baixado)'
    Write-Host ''
    $ans = Read-Host "Escolha [1-$($Models.Count)] (padrão 4)"
    if (-not $ans) { $choice = 4 }
    elseif (-not [int]::TryParse($ans, [ref]$choice)) { Die "Opção inválida: $ans" }
  }
  if ($choice -lt 1 -or $choice -gt $Models.Count) { Die "Opção inválida: $choice" }
  return $Models[$choice - 1]
}

function Test-Health {
  try {
    $r = Invoke-WebRequest -UseBasicParsing -TimeoutSec 2 "http://127.0.0.1:$Port/health"
    return ($r.StatusCode -eq 200)
  } catch { return $false }
}

# ---------------------------------------------------------------- execução ---
New-Item -ItemType Directory -Force $Base | Out-Null
Ensure-Llamafile
$sel  = Choose-Model $Model
$gguf = Ensure-Model $sel.Repo

if (Test-Health) { Die "Já existe algo respondendo na porta $Port. Defina `$env:PORT=8081 e rode de novo." }

Info "Iniciando $($sel.Name) (ctx $Ctx, porta $Port)"
$argList = "--server -m `"$gguf`" -c $Ctx -ngl 999 --host $BindHost --port $Port --alias `"$($sel.Name -replace '\s*\[.*\]\s*$', '')`""
$proc = Start-Process -FilePath $Bin -ArgumentList $argList -NoNewWindow -PassThru `
          -RedirectStandardOutput $LogOut -RedirectStandardError $LogErr
if (-not [LfJob]::Attach($proc.Handle)) { Warn 'Não consegui vincular ao Job Object; fechar a janela no X pode deixar o processo vivo.' }

try {
  Write-Host -NoNewline '   carregando modelo'
  while (-not (Test-Health)) {
    if ($proc.HasExited) {
      Write-Host ''
      Get-Content $LogErr -Tail 30 -ErrorAction SilentlyContinue
      Die 'llamafile encerrou ao iniciar (log acima).'
    }
    Write-Host -NoNewline '.'
    Start-Sleep -Seconds 1
  }
  Write-Host ''
  Write-Host ''
  Write-Host 'Pronto!' -ForegroundColor White
  Write-Host "  Chat (navegador) : http://localhost:$Port"
  Write-Host "  API OpenAI       : http://localhost:$Port/v1   (api key: qualquer)"
  Write-Host "  Logs             : $LogOut / $LogErr"
  Write-Host ''
  Write-Host '  Ctrl+C (ou fechar esta janela) encerra tudo.' -ForegroundColor Yellow
  Write-Host ''
  Start-Process "http://localhost:$Port"

  while (-not $proc.HasExited) { Start-Sleep -Milliseconds 500 }
  Warn 'llamafile terminou sozinho. Últimas linhas do log:'
  Get-Content $LogErr -Tail 15 -ErrorAction SilentlyContinue
}
finally {
  if (-not $proc.HasExited) {
    Write-Host ''
    Info "Encerrando llamafile (PID $($proc.Id))..."
    Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
  }
}
