# 📊 GUIA: Como Exportar Diagramas Mermaid no PowerShell

> **Localização dos diagramas:** `CONTEUDOS/METODOLOGIA/PROCESSO/diagramas/`

---

## 🚀 Requisitos Iniciais

### Instalar Mermaid CLI (uma única vez)

```powershell
npm install -g @mermaid-js/mermaid-cli
```

**Verificar instalação:**
```powershell
mmdc --version
```

---

## 📁 Navegação Inicial

Todos os comandos devem ser executados nesta pasta:

```powershell
cd "c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\projeto-concurso-dell-catuxe\CONTEUDOS\METODOLOGIA\PROCESSO\diagramas"
```

**Verificar que está no diretório correto:**
```powershell
pwd
# Deve retornar: .../diagramas
```

---

## 🎨 Figura 1: Fluxo das 6 Etapas

### Descrição
Mostra o fluxograma sequencial das 6 etapas principais da pesquisa.

**Arquivo:** `fluxo-6-etapas.md`

### Exportar para SVG (melhor para LaTeX)

```powershell
mmdc --input fluxo-6-etapas.md --output fluxo-6-etapas.svg
```

**Resultado:** Gera 3 arquivos (3 diagramas diferentes)
- `fluxo-6-etapas-1.svg` - Diagrama principal
- `fluxo-6-etapas-2.svg` - Variação simplificada
- `fluxo-6-etapas-3.svg` - Variação iterativa

### Exportar para PNG (melhor para slides)

```powershell
mmdc --input fluxo-6-etapas.md --output fluxo-6-etapas.png
```

**Resultado:** Gera 3 arquivos PNG
- `fluxo-6-etapas-1.png`
- `fluxo-6-etapas-2.png`
- `fluxo-6-etapas-3.png`

### Usar na LaTeX

```latex
\begin{figure}[H]
    \centering
    \includegraphics[width=0.85\textwidth]{CONTEUDOS/METODOLOGIA/PROCESSO/diagramas/fluxo-6-etapas-1.svg}
    \caption{Fluxograma das seis etapas principais do projeto}
    \label{fig:fluxo-etapas-principais}
\end{figure}
```

---

## 🔄 Figura 2: Módulos Integrados

### Descrição
Arquitetura dos 5 módulos metodológicos e integração entre eles.

**Arquivo:** `modulos-integrados.md`

### Exportar para SVG

```powershell
mmdc --input modulos-integrados.md --output modulos-integrados.svg
```

**Resultado:** Gera 2 arquivos
- `modulos-integrados-1.svg` - Diagrama principal (módulos × etapas)
- `modulos-integrados-2.svg` - Fluxo de dados integrado

### Exportar para PNG

```powershell
mmdc --input modulos-integrados.md --output modulos-integrados.png
```

**Resultado:** Gera 2 arquivos PNG
- `modulos-integrados-1.png`
- `modulos-integrados-2.png`

### Usar na LaTeX

```latex
\begin{figure}[H]
    \centering
    \includegraphics[width=0.9\textwidth]{CONTEUDOS/METODOLOGIA/PROCESSO/diagramas/modulos-integrados-1.svg}
    \caption{Integração dos cinco módulos metodológicos}
    \label{fig:modulos-integrados}
\end{figure}
```

---

## 🎯 Figura 3: Objetivos, Questões e Hipóteses

### Descrição
Alinhamento entre 6 Objetivos Específicos, 6 Questões de Pesquisa e 6 Hipóteses.

**Arquivo:** `objetivos-especificos.md`

### Exportar para SVG

```powershell
mmdc --input objetivos-especificos.md --output objetivos-especificos.svg
```

**Resultado:**
- `objetivos-especificos-1.svg` - Diagrama principal de alinhamento

### Exportar para PNG

```powershell
mmdc --input objetivos-especificos.md --output objetivos-especificos.png
```

**Resultado:**
- `objetivos-especificos-1.png`

### Usar na LaTeX

```latex
\begin{figure}[H]
    \centering
    \includegraphics[width=0.9\textwidth]{CONTEUDOS/METODOLOGIA/PROCESSO/diagramas/objetivos-especificos-1.svg}
    \caption{Alinhamento entre objetivos, questões de pesquisa e hipóteses}
    \label{fig:alinhamento-obj-q-h}
\end{figure}
```

---

## 📅 Figura 4: Timeline do Projeto

### Descrição
Cronograma de Gantt mostrando 36 meses de projeto com milestones críticos.

**Arquivo:** `timeline-projeto.md`

### Exportar para SVG

```powershell
mmdc --input timeline-projeto.md --output timeline-projeto.svg
```

**Resultado:**
- `timeline-projeto-1.svg` - Diagrama de Gantt

### Exportar para PNG

```powershell
mmdc --input timeline-projeto.md --output timeline-projeto.png
```

**Resultado:**
- `timeline-projeto-1.png`

### Usar na LaTeX

```latex
\begin{figure}[H]
    \centering
    \includegraphics[width=0.95\textwidth]{CONTEUDOS/METODOLOGIA/PROCESSO/diagramas/timeline-projeto-1.svg}
    \caption{Timeline de 36 meses do projeto de pesquisa}
    \label{fig:timeline-projeto}
\end{figure}
```

---

## ⚡ Comandos em Lote (Exportar Tudo de Uma Vez)

### Exportar TODOS para SVG

```powershell
mmdc --input fluxo-6-etapas.md --output fluxo-6-etapas.svg; `
mmdc --input modulos-integrados.md --output modulos-integrados.svg; `
mmdc --input objetivos-especificos.md --output objetivos-especificos.svg; `
mmdc --input timeline-projeto.md --output timeline-projeto.svg
```

### Exportar TODOS para PNG

```powershell
mmdc --input fluxo-6-etapas.md --output fluxo-6-etapas.png; `
mmdc --input modulos-integrados.md --output modulos-integrados.png; `
mmdc --input objetivos-especificos.md --output objetivos-especificos.png; `
mmdc --input timeline-projeto.md --output timeline-projeto.png
```

### Exportar TODOS para SVG E PNG

```powershell
# SVG
mmdc --input fluxo-6-etapas.md --output fluxo-6-etapas.svg; `
mmdc --input modulos-integrados.md --output modulos-integrados.svg; `
mmdc --input objetivos-especificos.md --output objetivos-especificos.svg; `
mmdc --input timeline-projeto.md --output timeline-projeto.svg; `
# PNG
mmdc --input fluxo-6-etapas.md --output fluxo-6-etapas.png; `
mmdc --input modulos-integrados.md --output modulos-integrados.png; `
mmdc --input objetivos-especificos.md --output objetivos-especificos.png; `
mmdc --input timeline-projeto.md --output timeline-projeto.png
```

---

## 📋 Script Completo (Copiar e Colar)

Crie um arquivo `export-diagramas.ps1`:

```powershell
# Script para exportar todos os diagramas Mermaid
# Uso: .\export-diagramas.ps1

Write-Host "🎨 Exportando diagramas Mermaid..." -ForegroundColor Green

# Navegar para pasta de diagramas
$diagramsPath = "c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\projeto-concurso-dell-catuxe\CONTEUDOS\METODOLOGIA\PROCESSO\diagramas"
cd $diagramsPath

# Arrays com nomes de arquivos
$diagramas = @(
    "fluxo-6-etapas",
    "modulos-integrados",
    "objetivos-especificos",
    "timeline-projeto"
)

# Exportar para SVG
Write-Host "`n📦 Exportando para SVG..." -ForegroundColor Cyan
foreach ($diagrama in $diagramas) {
    Write-Host "  ✓ $diagrama.md → SVG" -ForegroundColor Yellow
    mmdc --input "$diagrama.md" --output "$diagrama.svg"
}

# Exportar para PNG
Write-Host "`n🖼️  Exportando para PNG..." -ForegroundColor Cyan
foreach ($diagrama in $diagramas) {
    Write-Host "  ✓ $diagrama.md → PNG" -ForegroundColor Yellow
    mmdc --input "$diagrama.md" --output "$diagrama.png"
}

Write-Host "`n✅ Exportação concluída!" -ForegroundColor Green
Write-Host "📁 Arquivos salvos em: $diagramsPath" -ForegroundColor Green

# Listar arquivos gerados
Write-Host "`n📊 Arquivos gerados:" -ForegroundColor Cyan
Get-ChildItem *.svg | Select-Object Name
Get-ChildItem *.png | Select-Object Name
```

**Para executar:**
```powershell
cd "c:\Users\vidal\OneDrive\Documentos\13 - CLONEGIT\projeto-concurso-dell-catuxe\CONTEUDOS\METODOLOGIA\PROCESSO\diagramas"
.\export-diagramas.ps1
```

---

## 🎨 Opções Adicionais de Temas

Mermaid suporta múltiplos temas. Você pode editá-los adicionando no arquivo `.md`:

### Tema Padrão (já configurado)
```mermaid
%%{init: {'theme':'default'}}%%
```

### Tema Escuro
Edite o arquivo `.md` e altere para:
```mermaid
%%{init: {'theme':'dark'}}%%
```

### Tema Forest
```mermaid
%%{init: {'theme':'forest'}}%%
```

### Tema Neutral
```mermaid
%%{init: {'theme':'neutral'}}%%
```

---

## 📍 Estrutura de Arquivos Gerados

Após executar os comandos, você terá:

```
diagramas/
├── fluxo-6-etapas.md
├── fluxo-6-etapas-1.svg
├── fluxo-6-etapas-2.svg
├── fluxo-6-etapas-3.svg
├── fluxo-6-etapas-1.png
├── fluxo-6-etapas-2.png
├── fluxo-6-etapas-3.png
│
├── modulos-integrados.md
├── modulos-integrados-1.svg
├── modulos-integrados-2.svg
├── modulos-integrados-1.png
├── modulos-integrados-2.png
│
├── objetivos-especificos.md
├── objetivos-especificos-1.svg
├── objetivos-especificos-1.png
│
├── timeline-projeto.md
├── timeline-projeto-1.svg
├── timeline-projeto-1.png
│
└── [outros arquivos...]
```

---

## 🐛 Troubleshooting

### Erro: "mmdc is not recognized"

**Solução:** Instale Mermaid CLI globalmente:
```powershell
npm install -g @mermaid-js/mermaid-cli
```

### Erro: "Cannot find path"

**Solução:** Verifique se está no diretório correto:
```powershell
pwd  # Deve mostrar o caminho de diagramas
cd "CONTEUDOS\METODOLOGIA\PROCESSO\diagramas"
```

### Arquivos não aparecem

**Solução:** Atualize a visualização da pasta:
```powershell
ls *.svg
ls *.png
```

### Permissão negada ao executar script

**Solução:** Execute com política menos restritiva:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\export-diagramas.ps1
```

---

## 💡 Dicas Profissionais

### 1. Automatizar Exportação
Crie uma tarefa agendada que exporte os diagramas diariamente:
```powershell
# Adicione ao seu script PowerShell
$trigger = New-JobTrigger -Daily -At 8:00AM
Register-ScheduledJob -Name "ExportarDiagramas" -ScriptBlock { .\export-diagramas.ps1 } -Trigger $trigger
```

### 2. Copiar para Pasta Específica
```powershell
Copy-Item "*-1.svg" -Destination "..\..\..\..\Imagens\" -Force
Copy-Item "*-1.png" -Destination "..\..\..\..\Imagens\" -Force
```

### 3. Renomear Arquivos Mais Legíveis
```powershell
# Renomear para nomes sem "-1"
Get-ChildItem "*-1.svg" | Rename-Item -NewName { $_.Name -replace "-1", "" }
Get-ChildItem "*-1.png" | Rename-Item -NewName { $_.Name -replace "-1", "" }
```

---

## ✅ Checklist de Uso

- [ ] Mermaid CLI instalado (`npm install -g @mermaid-js/mermaid-cli`)
- [ ] No diretório correto: `CONTEUDOS/METODOLOGIA/PROCESSO/diagramas`
- [ ] Executar comando de exportação (SVG ou PNG)
- [ ] Verificar se arquivos foram gerados (`ls *.svg` ou `ls *.png`)
- [ ] Copiar arquivos para pasta de imagens se necessário
- [ ] Incluir em LaTeX com `\includegraphics`
- [ ] Testar compilação LaTeX
- [ ] Fazer commit e push dos PDFs finais

---

**Última atualização:** 2025-10-23  
**Versão:** 1.0  
**Status:** Ativo ✅

Qualquer dúvida, execute: `mmdc --help`

