# Este script está explicado aqui: https://github.com/williampilger/tutoriais/blob/master/windows/limitar-uso-cpu-por-processo.md
#
# Isso serve para Alterar a AFINIDADE DE CPUS POR PROCESSOS
# Não limita efetivamente o uso da CPU, mas limitando os núcleos, se obtém um resusltado bem parecido.

$TotalCores = (Get-CimInstance Win32_Processor).NumberOfLogicalProcessors # obtem o numero total de nucleos disponiveis no sistema

while ($true) {
    $ProcessName = Read-Host "Digite o nome do processo"
    $Process = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
    if ($Process) { break }
    Write-Host "Processo nao encontrado. Tente novamente."
}
$Process = Get-Process -Name $ProcessName -ErrorAction Stop
$CurrentAffinity = $Process.ProcessorAffinity
$CurrentCores = ([Convert]::ToString([int]$CurrentAffinity, 2).ToCharArray() -match '1').Count

Write-Host "Total de nucleos disponiveis: $TotalCores"
Write-Host "Nucleos atualmente em afinidade com o processo: $CurrentCores"

# solicita um novo numero de nucleos
$NewCoreCount = Read-Host "Quantos nucleos deseja conceder ao processo? (1 - $TotalCores)"
$NewCoreCount = [int]$NewCoreCount
if ($NewCoreCount -lt 1 -or $NewCoreCount -gt $TotalCores) {
    Write-Host "Numero invalido de nucleos. Saindo..."
    Start-Sleep -Seconds 5
    exit
}
$NewAffinity = [int]([math]::Pow(2, $NewCoreCount) - 1)
$Process.ProcessorAffinity = $NewAffinity

Write-Host "Afinidade do processo atualizada com sucesso para $NewCoreCount nucleo(s)!"
Start-Sleep -Seconds 5
