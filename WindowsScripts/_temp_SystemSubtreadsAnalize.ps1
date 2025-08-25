param(
  [int]$Interval = 2,   # segundos entre leituras
  [int]$TopN = 12       # quantas threads do PID 4 mostrar
)

$ErrorActionPreference = 'SilentlyContinue'

function Get-SystemThreads {
  Get-CimInstance Win32_PerfFormattedData_PerfProc_Thread |
    Where-Object { $_.IDProcess -eq 4 } |
    Sort-Object PercentProcessorTime -Descending |
    Select-Object -First $TopN `
      @{n='ThreadId';e={$_.IDThread}},
      @{n='CPU_%';e={[int]$_.PercentProcessorTime}},
      @{n='CtxSw_s';e={[int]$_.ContextSwitchesPersec}},
      @{n='Priority';e={$_.PriorityBase}}
}

function Get-CpuHealth {
  $c = Get-Counter -ErrorAction SilentlyContinue -SampleInterval 1 -MaxSamples 1 `
    -Counter '\Processor(_Total)\% Processor Time',
             '\Processor(_Total)\% DPC Time',
             '\Processor(_Total)\% Interrupt Time',
             '\Processor(_Total)\DPCs Queued/sec',
             '\Processor(_Total)\Interrupts/sec'

  $vals = @{}
  for ($i=0; $i -lt $c.CounterSamples.Count; $i++) {
    $name = $c.CounterSamples[$i].Path.Split('\')[-1]
    $vals[$name] = [math]::Round($c.CounterSamples[$i].CookedValue, 2)
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
  Get-Process |
    Select-Object Id, ProcessName,
      @{n='Kernel_s';e={$_.PrivilegedProcessorTime.TotalSeconds}},
      @{n='User_s';e={$_.UserProcessorTime.TotalSeconds}} |
    Sort-Object Kernel_s -Descending |
    Select-Object -First 10
}

while ($true) {
  Clear-Host
  Write-Host "=== Monitor System (PID 4) — $(Get-Date -Format 'HH:mm:ss') ===n"

  $cpu = Get-CpuHealth
  $cpu | Format-Table -AutoSize
  Write-Host ""

  Write-Host ("Top {0} threads do PID 4 por CPU_%" -f $TopN)
  Get-SystemThreads | Format-Table -AutoSize
  Write-Host ""

  if ($cpu.DPC_Percent -ge 5 -or $cpu.Interrupt_Percent -ge 5) {
    Write-Host "ALERTA: DPC/Interrupt altos sugerem driver (rede disco audio video etc.)."
  }

  Write-Host "nTop processos por tempo de KERNEL (s):"
  Get-KernelTop | Format-Table -AutoSize

  Start-Sleep -Seconds $Interval
}
