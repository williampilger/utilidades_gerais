# Rodar com:
#    powershell -NoProfile -ExecutionPolicy Bypass -File .\script_name.ps1 -Interval 2 -TopN 12

param(
  [int]$Interval = 10,   # segundos entre leituras
  [int]$TopN = 12       # quantas threads do PID 4 mostrar
)

$ErrorActionPreference = 'SilentlyContinue'

function Get-SystemThreads {
  # Threads do processo System (PID 4) com maior uso de CPU
  Get-CimInstance -ClassName Win32_PerfFormattedData_PerfProc_Thread |
    Where-Object { $_.IDProcess -eq 4 } |
    Sort-Object PercentProcessorTime -Descending |
    Select-Object -First $TopN `
      @{Name='ThreadId'; Expression = { $_.IDThread }},
      @{Name='CPU_Percent'; Expression = { [int]$_.PercentProcessorTime }},
      @{Name='CtxSw_per_sec'; Expression = { [int]$_.ContextSwitchesPersec }},
      @{Name='PriorityBase'; Expression = { $_.PriorityBase }}
}

function Get-CpuHealth {
  # Metricas globais: CPU total, DPC e Interrupcoes
  $paths = '\Processor(_Total)\% Processor Time',
           '\Processor(_Total)\% DPC Time',
           '\Processor(_Total)\% Interrupt Time',
           '\Processor(_Total)\DPCs Queued/sec',
           '\Processor(_Total)\Interrupts/sec'

  $c = Get-Counter -Counter $paths -SampleInterval 1 -MaxSamples 1 -ErrorAction SilentlyContinue

  $vals = @{}
  foreach ($s in $c.CounterSamples) {
    $name = ($s.Path -split '\\')[-1]
    $vals[$name] = [math]::Round($s.CookedValue, 2)
  }

  [pscustomobject]@{
    CPU_Percent        = $vals['% Processor Time']
    DPC_Percent        = $vals['% DPC Time']
    Interrupt_Percent  = $vals['% Interrupt Time']
    DPCs_per_sec       = $vals['DPCs Queued/sec']
    Interrupts_per_sec = $vals['Interrupts/sec']
  }
}

function Get-KernelTop {
  # Top processos por tempo de kernel (privileged)
  Get-Process |
    Select-Object Id, ProcessName,
      @{Name='Kernel_s'; Expression = { $_.PrivilegedProcessorTime.TotalSeconds }},
      @{Name='User_s';   Expression = { $_.UserProcessorTime.TotalSeconds }} |
    Sort-Object Kernel_s -Descending |
    Select-Object -First 10
}

Clear-Host
Write-Host ("Analizando...")

while ($true) {
  
  $cpu = Get-CpuHealth
  $sysThr = Get-SystemThreads

  Clear-Host
  Write-Host ("Analizando...")
  
  Write-Host ("=== Monitor System (PID 4) : {0} ===" -f (Get-Date -Format 'HH:mm:ss'))
  Write-Host

  $cpu | Format-Table -AutoSize
  Write-Host

  Write-Host ("Top {0} threads do PID 4 por CPU_%" -f $TopN)
  $sysThr | Format-Table -AutoSize
  Write-Host

  if ($cpu.DPC_Percent -ge 5 -or $cpu.Interrupt_Percent -ge 5) {
    Write-Host "ALERTA: DPC/Interrupt altos sugerem driver (rede, disco, audio, video)."
  }

  Write-Host
  Write-Host "Top processos por tempo de KERNEL (s):"
  Get-KernelTop | Format-Table -AutoSize

  Start-Sleep -Seconds $Interval
}
