#!/usr/bin/env pwsh
# Script para gerar PNG e SVG a partir de arquivos Mermaid (.mmd)
# Uso: .\gerar-diagramas.ps1
# ou: .\gerar-diagramas.ps1 -Arquivo "meu-diagrama.mmd"
# cd "c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\projeto-concurso-dell-catuxe\CONTEUDOS\METODOLOGIA\PROCESSO\diagramas" ; .\gerar-diagramas.ps1

param(
    [string]$Arquivo = "objetivos-especificos.mmd",
    [int]$Largura = 1400,
    [int]$Altura = 1600,
    [switch]$AbrirResultado
)

Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  📊 GERADOR DE DIAGRAMAS MERMAID" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Verificar se arquivo existe
if (-not (Test-Path $Arquivo)) {
    Write-Host "❌ ERRO: Arquivo '$Arquivo' não encontrado!" -ForegroundColor Red
    Write-Host "   Verifique o caminho e tente novamente." -ForegroundColor Yellow
    exit 1
}

# Verificar se Mermaid CLI está instalado
Write-Host "✓ Verificando Mermaid CLI..." -ForegroundColor Green
try {
    $versao = mmdc --version 2>$null
    Write-Host "  Versão: $versao" -ForegroundColor Green
} catch {
    Write-Host "❌ ERRO: Mermaid CLI não está instalado!" -ForegroundColor Red
    Write-Host "   Instale com: npm install -g @mermaid-js/mermaid-cli" -ForegroundColor Yellow
    exit 1
}

# Extrair nome base do arquivo
$nomeBase = [System.IO.Path]::GetFileNameWithoutExtension($Arquivo)
$arquivoPNG = "$nomeBase.png"
$arquivoSVG = "$nomeBase.svg"

Write-Host "`n📝 Arquivo de entrada: $Arquivo" -ForegroundColor Yellow
Write-Host "📏 Dimensões PNG: ${Largura}x${Altura}px" -ForegroundColor Yellow

# Gerar PNG
Write-Host "`n⏳ Gerando PNG..." -ForegroundColor Cyan
try {
    mmdc -i $Arquivo -o $arquivoPNG -w $Largura -H $Altura
    if (Test-Path $arquivoPNG) {
        $tamanhoPNG = [math]::Round((Get-Item $arquivoPNG).Length / 1KB, 1)
        Write-Host "✅ PNG gerado com sucesso: $arquivoPNG ($tamanhoPNG KB)" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Erro ao gerar PNG: $_" -ForegroundColor Red
    exit 1
}

# Gerar SVG
Write-Host "⏳ Gerando SVG..." -ForegroundColor Cyan
try {
    mmdc -i $Arquivo -o $arquivoSVG
    if (Test-Path $arquivoSVG) {
        $tamanhoSVG = [math]::Round((Get-Item $arquivoSVG).Length / 1KB, 1)
        Write-Host "✅ SVG gerado com sucesso: $arquivoSVG ($tamanhoSVG KB)" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Erro ao gerar SVG: $_" -ForegroundColor Red
    exit 1
}

# Resumo
Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✅ GERAÇÃO CONCLUÍDA COM SUCESSO" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host "`n📊 Arquivos gerados:" -ForegroundColor Yellow
Write-Host "  🖼️  $arquivoPNG" -ForegroundColor Cyan
Write-Host "  🎨 $arquivoSVG" -ForegroundColor Cyan

# Abrir resultado se solicitado
if ($AbrirResultado) {
    Write-Host "`n📂 Abrindo arquivos..." -ForegroundColor Cyan
    if (Test-Path $arquivoPNG) {
        Invoke-Item $arquivoPNG
    }
    Start-Sleep -Seconds 1
    if (Test-Path $arquivoSVG) {
        Invoke-Item $arquivoSVG
    }
}

Write-Host "`n✨ Pronto!" -ForegroundColor Green
