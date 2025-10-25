# Script de Verificação da Integração dos Arquivos Transportados
# Data: 25/10/2025

Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "  VERIFICAÇÃO DE INTEGRAÇÃO - ARQUIVOS TRANSPORTADOS" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

$basePath = $PSScriptRoot
$erros = 0
$avisos = 0

# Função para verificar existência de arquivo
function Test-FileExists {
    param (
        [string]$FilePath,
        [string]$Description
    )
    
    if (Test-Path $FilePath) {
        Write-Host "[OK]" -ForegroundColor Green -NoNewline
        Write-Host " $Description"
        return $true
    } else {
        Write-Host "[ERRO]" -ForegroundColor Red -NoNewline
        Write-Host " $Description - Arquivo não encontrado: $FilePath"
        $script:erros++
        return $false
    }
}

# Função para verificar citação no arquivo
function Test-Citation {
    param (
        [string]$FilePath,
        [string]$Citation
    )
    
    if (Test-Path $FilePath) {
        $content = Get-Content $FilePath -Raw
        if ($content -match $Citation) {
            return $true
        }
    }
    return $false
}

Write-Host "1. VERIFICANDO ARQUIVOS DE METODOLOGIA TRANSPORTADOS" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray

Test-FileExists "$basePath\CONTEUDOS\METODOLOGIA\Met_empreendedorismo.tex" "Met_empreendedorismo.tex"
Test-FileExists "$basePath\CONTEUDOS\METODOLOGIA\Met_gestao_pi.tex" "Met_gestao_pi.tex"
Test-FileExists "$basePath\CONTEUDOS\METODOLOGIA\Met_validacao.tex" "Met_validacao.tex"

Write-Host ""
Write-Host "2. VERIFICANDO INTEGRAÇÃO NO METODOLOGIA.TEX" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray

$metodologiaPath = "$basePath\CONTEUDOS\METODOLOGIA\Metodologia.tex"
if (Test-Path $metodologiaPath) {
    $metodologiaContent = Get-Content $metodologiaPath -Raw
    
    $includes = @(
        "Met_rs",
        "Met_psicometrica",
        "Met_machine_learning",
        "Met_empreendedorismo",
        "Met_gestao_pi",
        "Met_validacao"
    )
    
    foreach ($include in $includes) {
        if ($metodologiaContent -match "\\input\{[^}]*$include") {
            Write-Host "[OK]" -ForegroundColor Green -NoNewline
            Write-Host " $include.tex incluído"
        } else {
            Write-Host "[ERRO]" -ForegroundColor Red -NoNewline
            Write-Host " $include.tex NÃO está incluído no Metodologia.tex"
            $script:erros++
        }
    }
} else {
    Write-Host "[ERRO]" -ForegroundColor Red -NoNewline
    Write-Host " Metodologia.tex não encontrado"
    $script:erros++
}

Write-Host ""
Write-Host "3. VERIFICANDO IMAGENS" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray

Test-FileExists "$basePath\Imagens\objetivos-especificos.png" "objetivos-especificos.png"
Test-FileExists "$basePath\Imagens\territorio.png" "territorio.png"

Write-Host ""
Write-Host "4. VERIFICANDO REFERÊNCIAS BIBLIOGRÁFICAS" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray

$refPath = "$basePath\references.bib"
if (Test-Path $refPath) {
    $citations = @("Tidd2005", "Bozeman2000", "AroraEtAl2001", "AdnerKapoor2010")
    
    foreach ($citation in $citations) {
        if (Test-Citation $refPath $citation) {
            Write-Host "[OK]" -ForegroundColor Green -NoNewline
            Write-Host " Citação $citation encontrada"
        } else {
            Write-Host "[AVISO]" -ForegroundColor Yellow -NoNewline
            Write-Host " Citação $citation NÃO encontrada"
            $script:avisos++
        }
    }
} else {
    Write-Host "[ERRO]" -ForegroundColor Red -NoNewline
    Write-Host " references.bib não encontrado"
    $script:erros++
}

Write-Host ""
Write-Host "5. VERIFICANDO DOCUMENTAÇÃO DE PROCESSO" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray

Test-FileExists "$basePath\CONTEUDOS\METODOLOGIA\PROCESSO\README.md" "PROCESSO/README.md"
Test-FileExists "$basePath\CONTEUDOS\METODOLOGIA\PROCESSO\INDICE_DOCUMENTOS_FLUXO.md" "INDICE_DOCUMENTOS_FLUXO.md"
Test-FileExists "$basePath\CONTEUDOS\METODOLOGIA\PROCESSO\FLUXO_PROCESSO_EXPLICADO.md" "FLUXO_PROCESSO_EXPLICADO.md"
Test-FileExists "$basePath\CONTEUDOS\METODOLOGIA\PROCESSO\diagramas\INDEX.md" "diagramas/INDEX.md"

Write-Host ""
Write-Host "6. VERIFICANDO PASTA CONSULTA" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray

Test-FileExists "$basePath\CONSULTA\REDACOES\MARKDOWN\arquivo_matriz.md" "arquivo_matriz.md"

$redacoes = 1..10
$redacoesEncontradas = 0
foreach ($num in $redacoes) {
    $numFormatado = "{0:D2}" -f $num
    if (Test-Path "$basePath\CONSULTA\REDACOES\MARKDOWN\Redacao_Tema_$numFormatado.md") {
        $redacoesEncontradas++
    }
}

Write-Host "[OK]" -ForegroundColor Green -NoNewline
Write-Host " $redacoesEncontradas/10 redações encontradas"

Write-Host ""
Write-Host "7. VERIFICANDO DIAGRAMAS MERMAID" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray

$diagramas = @(
    "objetivos-especificos.mmd",
    "cronograma.mmd",
    "modulos-integrados.mmd"
)

foreach ($diagrama in $diagramas) {
    $path = "$basePath\CONTEUDOS\METODOLOGIA\PROCESSO\diagramas\$diagrama"
    if (Test-Path $path) {
        Write-Host "[OK]" -ForegroundColor Green -NoNewline
        Write-Host " $diagrama encontrado"
        
        # Verificar se existe PNG correspondente
        $pngName = $diagrama -replace "\.mmd$", ".png"
        $pngPath = "$basePath\Imagens\$pngName"
        if (-not (Test-Path $pngPath)) {
            Write-Host "    [AVISO]" -ForegroundColor Yellow -NoNewline
            Write-Host " PNG correspondente não encontrado em Imagens/"
            $script:avisos++
        }
    } else {
        Write-Host "[AVISO]" -ForegroundColor Yellow -NoNewline
        Write-Host " $diagrama não encontrado"
        $script:avisos++
    }
}

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "  RESUMO DA VERIFICAÇÃO" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan

if ($erros -eq 0 -and $avisos -eq 0) {
    Write-Host ""
    Write-Host "✅ TUDO OK! Todos os arquivos foram integrados corretamente." -ForegroundColor Green
    Write-Host ""
} elseif ($erros -eq 0) {
    Write-Host ""
    Write-Host "⚠️  Integração concluída com $avisos aviso(s)." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "AÇÕES RECOMENDADAS:" -ForegroundColor Yellow
    Write-Host "- Converter diagramas .mmd para .png usando:" -ForegroundColor White
    Write-Host "  .\CONTEUDOS\METODOLOGIA\PROCESSO\diagramas\gerar-diagramas.ps1" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "❌ Integração com problemas: $erros erro(s) e $avisos aviso(s)." -ForegroundColor Red
    Write-Host ""
    Write-Host "AÇÃO NECESSÁRIA:" -ForegroundColor Red
    Write-Host "- Revise os erros acima e corrija antes de compilar a tese." -ForegroundColor White
    Write-Host ""
}

Write-Host "Para mais detalhes, consulte: MAPEAMENTO_ARQUIVOS_TRANSPORTADOS.md" -ForegroundColor Cyan
Write-Host ""
