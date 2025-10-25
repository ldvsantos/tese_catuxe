# 📦 Mapeamento de Arquivos Transportados e Conexões do Projeto

**Data de criação:** 25/10/2025  
**Objetivo:** Documentar a integração dos arquivos transportados do projeto anterior e suas conexões com a estrutura atual da tese.

---

## 📋 Estrutura Hierárquica do Projeto

### 1️⃣ **Arquivo Principal (Raiz da Tese)**
```
Tese-Catuxe-PPGPI.tex  ← DOCUMENTO PRINCIPAL
```

**Função:** Arquivo mestre que compila toda a tese. Inclui todos os capítulos e seções.

**Conexões importantes:**
- `\documentclass[brazil,msc]{ppgpi-abntex2}` - Usa a classe customizada
- `\bibliography{references}` - Usa o arquivo de referências bibliográficas
- Inclui elementos pré-textuais de `Pre_Textual/`
- Inclui conteúdos de `CONTEUDOS/`
- Inclui elementos pós-textuais de `Pos_Textual/`

---

## 2️⃣ **Arquivos de Metodologia (Transportados)**

### 📂 Localização: `CONTEUDOS/METODOLOGIA/`

#### **Arquivo de integração:**
- **`Metodologia.tex`** - Arquivo principal do capítulo de Metodologia
  - Inclui 6 submódulos metodológicos via `\input{}`
  - Define o fluxo de integração da pesquisa
  - Referencia figuras em `Imagens/`

#### **Submódulos metodológicos incluídos:**

1. **`Met_rs.tex`** - Revisão Sistemática da Literatura
   - Relacionado aos objetivos OE1 (fundamentos teóricos)
   - Metodologia para mapeamento do estado da arte

2. **`Met_psicometrica.tex`** - Análise Psicométrica
   - Relacionado ao OE2 (identificação de ativos intangíveis)
   - Validação de instrumentos de coleta

3. **`Met_machine_learning.tex`** - Machine Learning
   - Relacionado ao OE3 (valoração participativa)
   - Algoritmos de classificação e análise

4. **`Met_empreendedorismo.tex`** ⭐ **[NOVO TRANSPORTADO]**
   - Relacionado ao OE4 (empreendedorismo tecnológico)
   - Conteúdo: Modelagem de negócios, Business Model Canvas, transferência de tecnologia
   - Referências: Tidd2005, Bozeman2000, AroraEtAl2001, AdnerKapoor2010

5. **`Met_gestao_pi.tex`** ⭐ **[NOVO TRANSPORTADO]**
   - Relacionado ao OE1 e OE5 (gestão de PI e ecossistemas colaborativos)
   - Conteúdo: Mapeamento de atores, redes sociais (ARS), fluxos institucionais, BPMN
   - Instrumentos legais de proteção de conhecimentos tradicionais

6. **`Met_validacao.tex`** ⭐ **[NOVO TRANSPORTADO]**
   - Relacionado ao OE6 (validação do modelo integrado)
   - Conteúdo: Pesquisa-ação participativa, validação multinível, teoria da mudança
   - Referência: Tidd2005

---

## 3️⃣ **Documentação de Processo (Transportada)**

### 📂 Localização: `CONTEUDOS/METODOLOGIA/PROCESSO/`

#### **Arquivos de documentação principal:**

1. **`README.md`** - Índice geral da documentação
2. **`INDICE_DOCUMENTOS_FLUXO.md`** - Navegação estruturada
3. **`RESUMO_EXECUTIVO_FLUXO.md`** - Visão geral de 60 segundos
4. **`FLUXO_PROCESSO_EXPLICADO.md`** - Explicação detalhada completa
5. **`DIAGRAMA_VISUAL_FLUXO.md`** - Diagramas e fluxogramas
6. **`ATUALIZACOES_RECENTES.md`** - Histórico de mudanças

#### **Subpasta de Diagramas:**
📂 `CONTEUDOS/METODOLOGIA/PROCESSO/diagramas/`

Arquivos principais:
- `INDEX.md` - Índice central de todos os diagramas
- `fluxo-6-etapas.md` - Visualização das 6 etapas principais
- `modulos-integrados.md` - Arquitetura dos 5 módulos
- `objetivos-especificos.mmd` - Alinhamento OE-Q-H (Mermaid)
- `timeline-projeto.md` - Cronograma de 36 meses
- `cronograma.mmd` - Cronograma em formato Mermaid
- `README.md` - Guia de uso dos diagramas
- `gerar-diagramas.ps1` - Script PowerShell para exportar diagramas

**⚠️ Importante:** Os arquivos `.mmd` (Mermaid) precisam ser convertidos para `.png` ou `.pdf` para inclusão no LaTeX.

---

## 4️⃣ **Material de Consulta e Referências (Transportado)**

### 📂 Localização: `CONSULTA/`

#### **Estrutura:**

```
CONSULTA/
├── REDACOES/
│   └── MARKDOWN/
│       ├── arquivo_matriz.md ← Temas de concurso (1-10)
│       ├── Redacao_Tema_01.md ← Gestão da Inovação Tecnológica
│       ├── Redacao_Tema_02.md ← PI como Ativo Estratégico
│       ├── Redacao_Tema_03.md ← Empreendedorismo Tecnológico
│       ├── Redacao_Tema_04.md ← Políticas de Inovação
│       ├── Redacao_Tema_05.md ← Gestão de Projetos de Inovação
│       ├── Redacao_Tema_06.md ← Valoração de Ativos Intangíveis
│       ├── Redacao_Tema_07.md ← Transferência de Tecnologia
│       ├── Redacao_Tema_08.md ← Gestão Estratégica de PI
│       ├── Redacao_Tema_09.md ← EBCT
│       └── Redacao_Tema_10.md ← Aspectos Éticos e Legais
│
└── REFERENCIAS/
    ├── TEMA 1 - Gestão da Inovação Tecnológica/
    │   ├── Markdown/ (artigos convertidos)
    │   └── PDF/ (artigos originais)
    ├── Tema 2 - PI como ativo/
    ├── TEMA 3 - Empreendedorismo tecnológico/
    ├── TEMA 4 - Politicas de inovação/
    ├── TEMA 5/
    └── TEMA 6 - Valoração de ativos/
```

#### **Uso deste material:**

- **`arquivo_matriz.md`**: Documento consolidado com fundamentação teórica para 10 temas
  - Contém conceitos-chave, argumentos, dados estatísticos
  - 1343 linhas de conteúdo estruturado
  - **Pode ser usado como fonte para o Referencial Teórico**

- **Redações temáticas**: Material complementar para aprofundamento em temas específicos
  - Tema 2, 3, 6, 7, 8 são especialmente relevantes para a tese
  
- **Pasta REFERENCIAS/**: Artigos científicos em PDF e Markdown
  - Organizados por tema
  - Podem ser integrados ao `references.bib`

---

## 5️⃣ **Imagens (Transportadas)**

### 📂 Localização: `Imagens/`

Arquivos novos:
- ✅ `objetivos-especificos.png` - Já referenciada em `Metodologia.tex` (linha 17)
- ✅ `territorio.png` - Possivelmente para uso na Introdução ou Referencial

**Conexão LaTeX:**
```latex
\includegraphics[width=\textwidth]{Imagens/objetivos-especificos.png}
```

---

## 6️⃣ **Arquivo de Referências Bibliográficas**

### 📄 Arquivo: `references.bib`

**Status:** Modificado (M) - foi atualizado com novas referências

**Referências citadas nos arquivos transportados:**
- `Tidd2005` - Usado em `Met_empreendedorismo.tex` e `Met_validacao.tex`
- `Bozeman2000` - Usado em `Met_empreendedorismo.tex`
- `AroraEtAl2001` - Usado em `Met_empreendedorismo.tex`
- `AdnerKapoor2010` - Usado em `Met_empreendedorismo.tex`

**⚠️ Ação necessária:** Verificar se todas as citações existem no `references.bib`

---

## 7️⃣ **Fluxo de Compilação**

### Como os arquivos se conectam:

```
Tese-Catuxe-PPGPI.tex (RAIZ)
    ↓ \include
Pre_Textual/ (Dedicatória, Resumo, Abstract, etc.)
    ↓ \include
CONTEUDOS/INTRODUÇÃO/
    ├── Introducao.tex
    └── Referencial.tex
    ↓ \include
CONTEUDOS/METODOLOGIA/
    └── Metodologia.tex
          ↓ \input (6 submódulos)
          ├── Met_rs.tex
          ├── Met_psicometrica.tex
          ├── Met_machine_learning.tex
          ├── Met_empreendedorismo.tex ⭐ NOVO
          ├── Met_gestao_pi.tex ⭐ NOVO
          └── Met_validacao.tex ⭐ NOVO
    ↓ \include
CONTEUDOS/RESULTADOS/Resultados.tex
    ↓ \include
CONTEUDOS/CONCLUSAO/Consideracoes.tex
    ↓ \bibliography
references.bib
    ↓ \include
Pos_Textual/Apendices.tex
```

---

## 8️⃣ **Checklist de Integração**

### ✅ Já integrado:
- [x] `Met_empreendedorismo.tex` adicionado ao `Metodologia.tex`
- [x] `Met_gestao_pi.tex` adicionado ao `Metodologia.tex`
- [x] `Met_validacao.tex` adicionado ao `Metodologia.tex`
- [x] Imagem `objetivos-especificos.png` já referenciada
- [x] Documentação em `PROCESSO/` organizada

### 🔄 Requer atenção:

- [ ] **Verificar citações no `references.bib`**
  - Buscar por: `Tidd2005`, `Bozeman2000`, `AroraEtAl2001`, `AdnerKapoor2010`
  - Se não existirem, adicionar as entradas completas

- [ ] **Converter diagramas Mermaid para LaTeX**
  - Executar `PROCESSO/diagramas/gerar-diagramas.ps1`
  - Ou converter manualmente usando https://mermaid.live
  - Salvar PNGs de alta resolução em `Imagens/`

- [ ] **Integrar conteúdo de `arquivo_matriz.md` ao Referencial Teórico**
  - Avaliar quais seções são relevantes
  - Adaptar formato Markdown para LaTeX
  - Incluir citações apropriadas

- [ ] **Revisar uso da imagem `territorio.png`**
  - Identificar onde deve ser incluída
  - Adicionar legenda e referência apropriada

- [ ] **Compilar a tese para verificar erros**
  - Executar `.\compilar_tese.ps1` ou `pdflatex + bibtex`
  - Verificar erros de compilação, referências quebradas
  - Verificar se todas as imagens são encontradas

---

## 9️⃣ **Arquivos Deletados (Limpeza)**

Os seguintes arquivos foram removidos e não precisam ser considerados:
- `ANALISE_ARQUIVO_MATRIZ_RECOMENDACOES.md`
- `CONFIG_VSCODE_LATEX.md`
- `NOVA_ESTRUTURA_CAPITULOS_TESE.md`
- `OBJETIVO_PRINCIPAL_REFORMULADO.md`
- Pasta `dados/revisao_sistematica/` completa
- Pasta `OLD/` completa

---

## 🎯 Recomendações Finais

### Prioridade Alta:
1. **Compilar a tese** para identificar problemas de integração
2. **Verificar referências bibliográficas** faltantes
3. **Converter diagramas Mermaid** para formato compatível com LaTeX

### Prioridade Média:
4. Integrar conteúdo relevante de `arquivo_matriz.md`
5. Revisar coerência entre os 6 módulos metodológicos
6. Garantir que todas as figuras têm legendas e fontes adequadas

### Prioridade Baixa:
7. Organizar material de `CONSULTA/REFERENCIAS/` para uso futuro
8. Documentar decisões de estrutura para manutenção futura

---

## 📞 Contatos e Referências Cruzadas

**Para navegar na documentação de PROCESSO:**
- Comece em: `CONTEUDOS/METODOLOGIA/PROCESSO/README.md`
- Índice completo: `CONTEUDOS/METODOLOGIA/PROCESSO/INDICE_DOCUMENTOS_FLUXO.md`
- Diagramas visuais: `CONTEUDOS/METODOLOGIA/PROCESSO/diagramas/INDEX.md`

**Para consultar material teórico:**
- Matriz consolidada: `CONSULTA/REDACOES/MARKDOWN/arquivo_matriz.md`
- Redações específicas: `CONSULTA/REDACOES/MARKDOWN/Redacao_Tema_XX.md`
- Referências PDF: `CONSULTA/REFERENCIAS/TEMA X/PDF/`

---

**Documento criado automaticamente pelo assistente de integração.**  
**Última atualização:** 25/10/2025
