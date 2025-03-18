function Show-Menu {
    Clear-Host
    Write-Host "===== GERENCIADOR DE PROCESSOS =====" -ForegroundColor Cyan
    Write-Host "1: Listar todos os processos" -ForegroundColor Green
    Write-Host "2: Listar os processos que mais consomem memória" -ForegroundColor Green
    Write-Host "3: Listar os processos que mais consomem CPU" -ForegroundColor Green
    Write-Host "4: Buscar processo por nome" -ForegroundColor Green
    Write-Host "5: Encerrar processo por ID" -ForegroundColor Green
    Write-Host "6: Encerrar processo por nome" -ForegroundColor Green
    Write-Host "7: Exportar lista de processos para CSV" -ForegroundColor Green
    Write-Host "0: Sair" -ForegroundColor Red
    Write-Host "===================================" -ForegroundColor Cyan
}

function List-AllProcesses {
    Get-Process | Sort-Object -Property CPU -Descending | 
        Format-Table -Property Id, ProcessName, CPU, WorkingSet, Description -AutoSize
    
    Write-Host "`nTotal de processos: $((Get-Process).Count)" -ForegroundColor Yellow
    Write-Host "Pressione qualquer tecla para continuar..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function List-MemoryIntensiveProcesses {
    Get-Process | Sort-Object -Property WorkingSet -Descending | 
        Select-Object -First 10 | 
        Format-Table -Property Id, ProcessName, @{Name="Memory (MB)"; Expression={[math]::Round($_.WorkingSet / 1MB, 2)}}, Description -AutoSize
    
    Write-Host "`nPressione qualquer tecla para continuar..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function List-CPUIntensiveProcesses {
    Get-Process | Sort-Object -Property CPU -Descending | 
        Select-Object -First 10 | 
        Format-Table -Property Id, ProcessName, CPU, Description -AutoSize
    
    Write-Host "`nPressione qualquer tecla para continuar..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Search-ProcessByName {
    $processName = Read-Host "Digite o nome do processo (ou parte dele)"
    
    $foundProcesses = Get-Process | Where-Object { $_.ProcessName -like "*$processName*" }
    
    if ($foundProcesses) {
        $foundProcesses | Format-Table -Property Id, ProcessName, CPU, WorkingSet, Description -AutoSize
        Write-Host "`nEncontrados $($foundProcesses.Count) processo(s)" -ForegroundColor Green
    } else {
        Write-Host "`nNenhum processo encontrado com o termo '$processName'" -ForegroundColor Red
    }
    
    Write-Host "`nPressione qualquer tecla para continuar..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Stop-ProcessById {
    $processId = Read-Host "Digite o ID do processo que deseja encerrar"
    
    try {
        $process = Get-Process -Id $processId -ErrorAction Stop
        $processName = $process.ProcessName
        
        $confirmation = Read-Host "Tem certeza que deseja encerrar o processo '$processName' (ID: $processId)? (S/N)"
        
        if ($confirmation -eq 'S' -or $confirmation -eq 's') {
            Stop-Process -Id $processId -Force -ErrorAction Stop
            Write-Host "`nProcesso '$processName' (ID: $processId) encerrado com sucesso!" -ForegroundColor Green
        } else {
            Write-Host "`nOperação cancelada pelo usuário." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "`nErro: Não foi possível encontrar ou encerrar o processo com ID '$processId'" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
    
    Write-Host "`nPressione qualquer tecla para continuar..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Stop-ProcessByName {
    $processName = Read-Host "Digite o nome do processo que deseja encerrar"
    
    try {
        $processes = Get-Process -Name $processName -ErrorAction Stop
        
        Write-Host "`nProcessos encontrados:" -ForegroundColor Cyan
        $processes | Format-Table -Property Id, ProcessName, CPU, WorkingSet -AutoSize
        
        $confirmation = Read-Host "Tem certeza que deseja encerrar TODOS os processos '$processName'? (S/N)"
        
        if ($confirmation -eq 'S' -or $confirmation -eq 's') {
            Stop-Process -Name $processName -Force -ErrorAction Stop
            Write-Host "`nTodos os processos '$processName' foram encerrados com sucesso!" -ForegroundColor Green
        } else {
            Write-Host "`nOperação cancelada pelo usuário." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "`nErro: Não foi possível encontrar ou encerrar processos com o nome '$processName'" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
    
    Write-Host "`nPressione qualquer tecla para continuar..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Export-ProcessesToCSV {
    $defaultPath = [Environment]::GetFolderPath("Desktop")
    $filePath = "$defaultPath\processos_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
    
    try {
        Get-Process | Select-Object Id, ProcessName, CPU, @{Name="Memory (MB)"; Expression={[math]::Round($_.WorkingSet / 1MB, 2)}}, Description |
            Export-Csv -Path $filePath -NoTypeInformation -Encoding UTF8
        
        Write-Host "`nProcessos exportados com sucesso para: $filePath" -ForegroundColor Green
    } catch {
        Write-Host "`nErro ao exportar processos: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host "`nPressione qualquer tecla para continuar..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

do {
    Show-Menu
    $choice = Read-Host "Digite sua opção"
    
    switch ($choice) {
        '1' { List-AllProcesses }
        '2' { List-MemoryIntensiveProcesses }
        '3' { List-CPUIntensiveProcesses }
        '4' { Search-ProcessByName }
        '5' { Stop-ProcessById }
        '6' { Stop-ProcessByName }
        '7' { Export-ProcessesToCSV }
        '0' { 
            Write-Host "`nSaindo do Gerenciador de Processos..." -ForegroundColor Cyan
            return 
        }
        default {
            Write-Host "`nOpção inválida. Por favor, tente novamente." -ForegroundColor Red
            Write-Host "Pressione qualquer tecla para continuar..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
    }
} while ($true)