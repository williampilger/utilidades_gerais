param(
  [int]$Interval = 2,      # segundos entre leituras
  [int]$TopN = 10          # quantas threads do PID 4 mostrar
)

$ErrorActionPreference = 'SilentlyContinue'

function Get-SystemThreads {
  # Threads do processo System (PID 4) com maior uso de CPU
  Get-CimInstance Win32_PerfFormattedData_PerfProc_Thread |
    Where-Object { $_.IDProcess -eq 4 } |
    Sort-Object PercentProcessorTime -Descending |
    Select-Object -First $TopN `
      @{n='ThreadId';e={$_.IDThread}},
      @{n='%CPU';e={[int]$_.PercentProcessorTime}},
      @{n='CtxSw/s';e={[int]$_.ContextSwitchesPersec}},
      @{n='Priority';e={$_.PriorityBase}}
}

function Get-CpuHealth {
  # Métricas globais: CPU total, DPC e Interrupções
  $c = Get-Counter -ErrorAction SilentlyContinue -SampleInterval 1 -MaxSamples 1 `
    -Counter '\Processor(_Total)\% Processor Time',
             '\Processor(_Total)\% DPC Time',
             '\Processor(_Total)\% Interrupt Time',
             '\Processor(_Total)\DPCs Queued/sec',
             '\Processor(_Total)\Interrupts/sec'

  $vals = @{}
  for ($i=0; $i -lt $c.CounterSamples.Count; $i++) {
    $name = $c.CounterSamples[$i].Path.Split('\')[-1]
    $vals[$name] = [math]::Round($c.CounterSamples[$i].CookedValue,2)
  }
  [pscustomobject]@{
    'CPU %'          = $vals['% Processor Time']
    'DPC %'          = $vals['% DPC Time']
    'Interrupt %'    = $vals['% Interrupt Time']
    'DPCs/s'         = $vals['DPCs Queued/sec']
    'Interrupts/s'   = $vals['Interrupts/sec']
  }
}

function Get-KernelTop {
  # Top processos por tempo de kernel (privileged)
  Get-Process |
    Select-Object Id, ProcessName,
                  @{n='Kernel_s';e={$_.PrivilegedProcessorTime.TotalSeconds}},
                  @{n='User_s';e={$_.UserProcessorTime.TotalSeconds}} |
    Sort-Object Kernel_s -Descending |
    Select-Object -First 10
}

# Loop de monitoramento
while ($true) {
  Clear-Host
  Write-Host "=== Monitor System (PID 4) — $(Get-Date -Format 'HH:mm:ss') ===`n"

  # Saúde da CPU (Total/DPC/Interrupt)
  $cpu = Get-CpuHealth
  $cpu | Format-Table -AutoSize
  Write-Host ""

  # Threads do System mais quentes
  Write-Host "Top $TopN threads do PID 4 por %CPU:"
  Get-SystemThreads | Format-Table -AutoSize
  Write-Host ""

  # Se DPC/Interrupt estiverem altos, geralmente é driver
  if ($cpu.'DPC %' -ge 5 -or $cpu.'Interrupt %' -ge 5) {
    Write-Host "⚠ DPC/Interrupt altos sugerem driver (rede, disco, áudio, vídeo etc.)."
  }

  # (Opcional) ver quem mais gasta kernel no sistema
  Write-Host "`nTop processos por tempo de KERNEL (s):"
  Get-KernelTop | Format-Table -AutoSize

  Start-Sleep -Seconds $Interval
}
