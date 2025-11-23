# 📁 PASTA SCRIPTS - ORGANIZAÇÃO

Organização dos scripts para busca bibliográfica, processamento e análise de dados da tese.

**Última atualização:** 23 de novembro de 2025

---

## 📂 ESTRUTURA DE PASTAS

```
scripts/
├── 1-busca/                        # Scripts de busca bibliográfica
├── 2-processamento/                # Scripts de processamento de dados
├── 3-prisma/                       # Scripts e resultados do fluxograma PRISMA
├── 4-resultados/                   # Resultados salvos (.rds, gráficos)
├── OLD_arquivos_originais/         # Arquivos antigos/temporários
└── README.md                       # Este arquivo
```

---

## 🔍 1-busca/

Scripts para realizar buscas em bases de dados bibliográficas.

### Arquivos:

- **`busca_otimizada_ml_etnografia.R`**
  - **Descrição:** Script principal para busca otimizada em Scopus/Web of Science
  - **Tema:** Machine Learning + Etnografia + Conhecimentos Tradicionais
  - **Output:** 
    - `query_scopus_otimizada.txt` (query pronta para copiar)
    - `queries_tematicas_complementares.txt` (5 queries específicas)
    - `validar_busca_rapida.R` (validação dos resultados)
  - **Data:** 23/11/2025
  - **Status:** ✅ Pronto para uso
  - **Uso:** 
    ```r
    source("1-busca/busca_otimizada_ml_etnografia.R")
    ```

- **`busca_webofscience_auto.R`**
  - **Descrição:** Script para busca automatizada no Web of Science
  - **Status:** ⚠️ Legado (substituído por busca_otimizada)
  - **Uso:** Consultar apenas para referência histórica

- **`busca_otimizada_ml_etnografia.Rout`**
  - **Descrição:** Log de execução do script principal
  - **Função:** Verificar se script executou corretamente

### Instruções de Uso:

1. Execute `busca_otimizada_ml_etnografia.R`
2. Siga as instruções no console
3. Realize buscas manuais em Scopus/WoS usando queries geradas
4. Salve arquivos .bib na pasta `DADOS/`
5. Execute novamente o script para processar resultados

---

## ⚙️ 2-processamento/

Scripts para processar e limpar dados bibliográficos.

### Arquivos:

- **`corrigir_dependencias.R`**
  - **Descrição:** Corrige e instala dependências de pacotes R
  - **Uso:** Execute antes de rodar outros scripts se houver erros de pacotes
  - **Função:** Garante que todos os pacotes estão instalados corretamente

### Instruções de Uso:

```r
# Se houver erros de pacotes faltando:
source("2-processamento/corrigir_dependencias.R")
```

---

## 📊 3-prisma/

Scripts e resultados para gerar fluxogramas PRISMA (Preferred Reporting Items for Systematic Reviews and Meta-Analyses).

### Arquivos:

- **`gerar_prisma_interativo.R`**
  - **Descrição:** Gera fluxograma PRISMA interativo em HTML
  - **Output:** `prisma_flowdiagram_interativo.html`
  - **Função:** Visualização interativa do processo de seleção de estudos
  - **Uso:**
    ```r
    source("3-prisma/gerar_prisma_interativo.R")
    ```

- **`gerar_prisma_portugues.R`**
  - **Descrição:** Gera fluxograma PRISMA em português
  - **Output:** Fluxograma em imagem (PNG/PDF)
  - **Função:** Versão em português para inclusão na tese
  - **Uso:**
    ```r
    source("3-prisma/gerar_prisma_portugues.R")
    ```

- **`PRISMA.csv`**
  - **Descrição:** Dados brutos para construção do fluxograma PRISMA
  - **Formato:** CSV com números de cada etapa de triagem
  - **Colunas:** identificação, triagem, elegibilidade, inclusão

- **`prisma_flowdiagram_interativo.html`**
  - **Descrição:** Fluxograma PRISMA interativo gerado
  - **Visualização:** Abrir em qualquer navegador web
  - **Função:** Apresentações e defesa de tese

### Instruções de Uso:

1. Edite `PRISMA.csv` com números da sua revisão
2. Execute `gerar_prisma_interativo.R` para versão HTML
3. Execute `gerar_prisma_portugues.R` para versão em imagem
4. Use HTML para apresentações, imagem para tese impressa

---

## 📈 4-resultados/

Arquivos de resultados salvos das análises estatísticas.

### Arquivos:

- **`res_mca_temporal.rds`**
  - **Descrição:** Resultados da Análise de Correspondência Múltipla (MCA) temporal
  - **Conteúdo:** Objeto R com resultados da MCA
  - **Origem:** Script `02_mca_analysis.R` (pasta 1-ESTATISTICA)
  - **Uso:** 
    ```r
    res_mca <- readRDS("4-resultados/res_mca_temporal.rds")
    ```

- **`res_mca_temporal_completo.rds`**
  - **Descrição:** Resultados completos da MCA temporal (versão estendida)
  - **Diferença:** Inclui dados adicionais e metadados
  - **Uso:**
    ```r
    res_mca_completo <- readRDS("4-resultados/res_mca_temporal_completo.rds")
    ```

- **`Rplots.pdf`**
  - **Descrição:** Gráficos gerados durante análises
  - **Conteúdo:** Múltiplas páginas com diferentes visualizações
  - **Origem:** Outputs automáticos de scripts R
  - **Uso:** Consultar para ver gráficos gerados

### Instruções de Uso:

```r
# Carregar resultado salvo
resultado <- readRDS("4-resultados/nome_do_arquivo.rds")

# Visualizar estrutura
str(resultado)

# Usar em análises posteriores
summary(resultado)
plot(resultado)
```

---

## 🗄️ OLD_arquivos_originais/

Arquivos antigos, temporários ou substituídos mantidos para referência histórica.

### Arquivos:

- **`scopus_export.bib`**
  - **Descrição:** Exportação antiga do Scopus
  - **Status:** ❌ Substituído por buscas otimizadas
  - **Motivo:** Corpus focado em agroecologia geral, não ML+Etnografia

- **`wos_export.bib`**
  - **Descrição:** Exportação antiga do Web of Science
  - **Status:** ❌ Substituído por buscas otimizadas
  - **Motivo:** Mesmo problema do scopus_export.bib

- **`.Rhistory`**
  - **Descrição:** Histórico de comandos R executados
  - **Função:** Backup de comandos anteriores
  - **Uso:** Consultar para ver comandos usados anteriormente

### ⚠️ Atenção:

- **NÃO USE** estes arquivos para análises
- Mantidos apenas para referência histórica
- Corpus antigo tinha 0% de estudos relevantes para tema da tese

---

## 🚀 FLUXO DE TRABALHO RECOMENDADO

### 1️⃣ Primeira Vez (Setup Inicial)

```r
# 1. Corrigir dependências (se necessário)
source("scripts/2-processamento/corrigir_dependencias.R")

# 2. Executar busca otimizada
source("scripts/1-busca/busca_otimizada_ml_etnografia.R")

# 3. Seguir instruções no console para buscar em Scopus/WoS
```

### 2️⃣ Após Baixar Arquivos .bib

```r
# 1. Processar arquivos baixados
# (Script detecta automaticamente arquivos *etnografia*.bib)
source("scripts/1-busca/busca_otimizada_ml_etnografia.R")

# 2. Validar resultados
source("validar_busca_rapida.R")  # Gerado pelo script acima

# 3. Verificar qualidade
# Deve mostrar >60% ML, >70% TK, >60% Ethnography
```

### 3️⃣ Gerar Fluxograma PRISMA

```r
# 1. Editar números no arquivo
edit("scripts/3-prisma/PRISMA.csv")

# 2. Gerar versão interativa
source("scripts/3-prisma/gerar_prisma_interativo.R")

# 3. Gerar versão em português
source("scripts/3-prisma/gerar_prisma_portugues.R")
```

### 4️⃣ Análises Estatísticas

```r
# Ver pasta: 1-ESTATISTICA/1-RSTUDIO/
# Scripts: 01_pca_analysis.R, 02_mca_analysis.R, etc.
```

---

## 📝 ARQUIVOS IMPORTANTES GERADOS

Ao executar os scripts, os seguintes arquivos são criados na pasta **DADOS/**:

```
DADOS/
├── query_scopus_otimizada.txt              # Query para Scopus
├── queries_tematicas_complementares.txt    # 5 queries específicas
├── validar_busca_rapida.R                  # Script de validação
├── referencias_ml_etnografia_otimizado.bib # Corpus final processado
├── ESTRATEGIA_MELHORIA_BUSCA.txt          # Análise detalhada
└── GUIA_EXECUTAR_BUSCA.txt                # Guia passo a passo
```

---

## 🔧 TROUBLESHOOTING

### Erro: "Pacote não encontrado"

```r
source("scripts/2-processamento/corrigir_dependencias.R")
```

### Erro: "Arquivo não encontrado"

- Verifique se está executando do diretório correto
- Use caminhos relativos a partir de `DADOS/`

### Script não gera output

- Verifique o arquivo `.Rout` correspondente
- Procure por mensagens de erro no final do arquivo

### Resultados inesperados

- Verifique se os arquivos .bib estão na pasta correta
- Execute validação rápida para diagnosticar

---

## 📚 DOCUMENTAÇÃO ADICIONAL

- **Estratégia de Busca:** `../ESTRATEGIA_MELHORIA_BUSCA.txt`
- **Guia de Execução:** `../GUIA_EXECUTAR_BUSCA.txt`
- **Relatório de Reorganização:** `../../RELATORIO_REORGANIZACAO_FINAL.md`
- **README Estatística:** `../1-ESTATISTICA/README.md`

---

## 📞 SUPORTE

Para dúvidas sobre:

- **Buscas bibliográficas:** Ver `GUIA_EXECUTAR_BUSCA.txt`
- **Análises estatísticas:** Ver `1-ESTATISTICA/README.md`
- **Estrutura geral:** Ver `RELATORIO_REORGANIZACAO_FINAL.md`

---

## ✅ CHECKLIST DE MANUTENÇÃO

Ao adicionar novos scripts nesta pasta:

- [ ] Colocar na pasta apropriada (1-busca, 2-processamento, 3-prisma, 4-resultados)
- [ ] Adicionar comentários no cabeçalho do script
- [ ] Documentar no README.md
- [ ] Testar antes de commitar
- [ ] Mover arquivos antigos para OLD_arquivos_originais/

---

**Versão:** 1.0  
**Última atualização:** 23 de novembro de 2025  
**Mantido por:** Catuxe (Doutorado PPGPI)
