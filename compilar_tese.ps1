# Script de Compilacao Automatica - Tese de Doutorado
# Catuxe Varjao de Santana Oliveira - PPGPI/UFS
# Criado em: 12 de outubro de 2025

param(
    [switch]$Rapida,     # Compilacao rapida (apenas 1 passo)
    [switch]$Limpar,     # Limpar arquivos auxiliares antes de compilar
    [switch]$Silenciosa  # Compilacao sem output detalhado
)

# Configuracoes
$ArquivoPrincipal = "Tese-Catuxe-PPGPI.tex"
$ArquivoPDF = "Tese-Catuxe-PPGPI.pdf"

# Funcao para exibir mensagens coloridas
function Write-ColorMessage($Message, $Color = "White") {
    if (-not $Silenciosa) {
        Write-Host $Message -ForegroundColor $Color
    }
}

# Funcao para limpar arquivos auxiliares
function Clear-AuxFiles {
    Write-ColorMessage "Limpando arquivos auxiliares..." "Yellow"
    
    $auxFiles = @("*.aux", "*.log", "*.bbl", "*.blg", "*.brf", "*.fdb_latexmk", 
                  "*.fls", "*.synctex.gz", "*.idx", "*.ilg", "*.ind", 
                  "*.lof", "*.lot", "*.toc", "*.out")
    
    foreach ($pattern in $auxFiles) {
        Get-ChildItem -Recurse -File -Filter $pattern | Remove-Item -Force -ErrorAction SilentlyContinue
    }
    
    Write-ColorMessage "Arquivos auxiliares removidos" "Green"
}

# Funcao para verificar se arquivo existe
function Test-FileExists($FilePath) {
    if (-not (Test-Path $FilePath)) {
        Write-ColorMessage "ERRO: Arquivo nao encontrado: $FilePath" "Red"
        Write-ColorMessage "Verifique se voce esta no diretorio correto da tese." "Yellow"
        exit 1
    }
}

# Funcao para compilacao LaTeX
function Invoke-LaTeX {
    param($StepName, $StepNumber, $TotalSteps)
    
    Write-ColorMessage "Passo $StepNumber/$TotalSteps - $StepName..." "Cyan"
    
    if ($Silenciosa) {
        pdflatex -interaction=nonstopmode $ArquivoPrincipal > $null 2>&1
    } else {
        pdflatex -interaction=nonstopmode $ArquivoPrincipal | Out-Null
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorMessage "$StepName concluido" "Green"
    } else {
        Write-ColorMessage "ERRO durante $StepName" "Red"
        Write-ColorMessage "Verifique o arquivo .log para detalhes do erro." "Yellow"
        exit 1
    }
}

# Funcao para processar bibliografia
function Invoke-BibTeX {
    Write-ColorMessage "Passo 2/4 - Processando bibliografia..." "Cyan"
    
    $bibName = $ArquivoPrincipal -replace "\.tex$", ""
    
    if ($Silenciosa) {
        bibtex $bibName > $null 2>&1
    } else {
        bibtex $bibName | Out-Null
    }
    
    # BibTeX pode retornar 1 com warnings, mas ainda funcionar
    if ($LASTEXITCODE -le 1) {
        Write-ColorMessage "Bibliografia processada" "Green"
    } else {
        Write-ColorMessage "ERRO no processamento da bibliografia" "Red"
        exit 1
    }
}

# SCRIPT PRINCIPAL
Write-ColorMessage "COMPILADOR AUTOMATICO - TESE DE DOUTORADO" "Magenta"
Write-ColorMessage "===============================================" "Magenta"

# Verificar arquivo principal
Test-FileExists $ArquivoPrincipal

# Limpar arquivos auxiliares se solicitado
if ($Limpar) {
    Clear-AuxFiles
}

# Determinar tipo de compilacao
if ($Rapida) {
    Write-ColorMessage "Modo: Compilacao Rapida (1 passo)" "Yellow"
    Write-ColorMessage "===============================================" "Yellow"
    
    Invoke-LaTeX "Compilacao Rapida" 1 1
    
} else {
    Write-ColorMessage "Modo: Compilacao Completa (4 passos)" "Yellow"
    Write-ColorMessage "===============================================" "Yellow"
    
    # Processo completo de 4 etapas
    Invoke-LaTeX "Primeira compilacao LaTeX" 1 4
    Invoke-BibTeX
    Invoke-LaTeX "Segunda compilacao LaTeX" 3 4
    Invoke-LaTeX "Compilacao final" 4 4
}

# Verificar resultado final
if (Test-Path $ArquivoPDF) {
    $pdfInfo = Get-Item $ArquivoPDF
    $sizeKB = [math]::Round($pdfInfo.Length / 1KB, 1)
    $sizeMB = [math]::Round($pdfInfo.Length / 1MB, 2)
    
    Write-ColorMessage "===============================================" "Green"
    Write-ColorMessage "COMPILACAO FINALIZADA COM SUCESSO!" "Green"
    Write-ColorMessage "===============================================" "Green"
    Write-ColorMessage "Arquivo: $($pdfInfo.Name)" "Cyan"
    Write-ColorMessage "Tamanho: $sizeMB MB ($sizeKB KB)" "Cyan"
    Write-ColorMessage "Atualizado: $($pdfInfo.LastWriteTime)" "Cyan"
    
} else {
    Write-ColorMessage "ERRO: PDF nao foi gerado!" "Red"
    Write-ColorMessage "Verifique os logs de erro para mais detalhes." "Yellow"
    exit 1
}

Write-ColorMessage "===============================================" "Green"

# EXEMPLOS DE USO:
# 1. Compilacao completa: .\compilar_tese.ps1
# 2. Compilacao rapida: .\compilar_tese.ps1 -Rapida
# 3. Limpar e compilar: .\compilar_tese.ps1 -Limpar
# 4. Compilacao silenciosa: .\compilar_tese.ps1 -Silenciosa