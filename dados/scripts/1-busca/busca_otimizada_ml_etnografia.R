################################################################################
# BUSCA OTIMIZADA: ML + ETNOGRAFIA + CONHECIMENTOS TRADICIONAIS
# Data: 23 de novembro de 2025
# Objetivo: Refazer busca com query restritiva para capturar interseção real
################################################################################

library(bibliometrix)
library(tidyverse)
library(httr)
library(jsonlite)

# Configurações
setwd("c:/Users/vidal/OneDrive/Documentos/13 - CLONEGIT/tese-catuxe/DADOS")

cat("================================================================================\n")
cat("BUSCA OTIMIZADA - ML + ETNOGRAFIA + CONHECIMENTOS TRADICIONAIS\n")
cat("================================================================================\n\n")

################################################################################
# 1. QUERY OTIMIZADA (exige interseção completa)
################################################################################

query_ml <- c(
  "machine learning", "artificial intelligence", "deep learning",
  "natural language processing", "NLP", "text mining",
  "computational analysis", "data mining", "neural network",
  "predictive model", "algorithm", "classification", "clustering"
)

query_tk <- c(
  "traditional knowledge", "indigenous knowledge", "local knowledge",
  "ethnobotany", "ethnobotanical", "traditional ecological knowledge",
  "TEK", "indigenous people", "native community", "aboriginal",
  "ancestral knowledge", "folk knowledge", "local ecological knowledge"
)

query_ethno <- c(
  "ethnography", "ethnographic", "participatory research",
  "community-based research", "field research", "qualitative",
  "interview", "case study", "action research", "mixed method",
  "participatory action research"
)

# Construir query Scopus
ml_terms <- paste0('"', query_ml, '"', collapse = " OR ")
tk_terms <- paste0('"', query_tk, '"', collapse = " OR ")
ethno_terms <- paste0('"', query_ethno, '"', collapse = " OR ")

query_scopus <- sprintf(
  "TITLE-ABS-KEY((%s) AND (%s) AND (%s)) AND PUBYEAR > 2013",
  ml_terms, tk_terms, ethno_terms
)

cat("QUERY SCOPUS GERADA:\n")
cat(substr(query_scopus, 1, 200), "...\n\n")

# Salvar query
writeLines(query_scopus, "query_scopus_otimizada.txt")

################################################################################
# 2. BUSCA ALTERNATIVA: GOOGLE SCHOLAR VIA bibliometrix
################################################################################

cat("INSTRUÇÕES PARA BUSCA MANUAL:\n")
cat("================================================================================\n\n")

cat("PASSO 1 - SCOPUS:\n")
cat("1. Acesse: https://www.scopus.com/search/form.uri?display=advanced\n")
cat("2. Cole a query salva em 'query_scopus_otimizada.txt'\n")
cat("3. Adicione filtros:\n")
cat("   - Document Type: Article, Review\n")
cat("   - Language: English, Portuguese, Spanish\n")
cat("   - Subject Area: Agricultural and Biological Sciences, Computer Science,\n")
cat("                   Social Sciences, Environmental Science\n")
cat("4. Exporte como BibTeX (máximo 2000 resultados)\n")
cat("5. Salve como: scopus_ml_etnografia.bib\n\n")

cat("PASSO 2 - WEB OF SCIENCE:\n")
cat("1. Acesse: https://www.webofscience.com/wos/woscc/advanced-search\n")
cat("2. Adapte a query para sintaxe WoS:\n")
cat("   TS=(", substr(ml_terms, 1, 50), "...) AND\n")
cat("   TS=(", substr(tk_terms, 1, 50), "...) AND\n")
cat("   TS=(", substr(ethno_terms, 1, 50), "...)\n")
cat("   AND PY=(2014-2024)\n")
cat("3. Adicione filtros semelhantes ao Scopus\n")
cat("4. Exporte como BibTeX\n")
cat("5. Salve como: wos_ml_etnografia.bib\n\n")

cat("PASSO 3 - GOOGLE SCHOLAR (complementar):\n")
cat("1. Use query simplificada:\n")
cat('   "machine learning" AND "traditional knowledge" AND ethnography\n')
cat("2. Use Publish or Perish ou Harzing's tool\n")
cat("3. Filtre por ano: 2014-2024\n")
cat("4. Exporte primeiros 200 resultados\n\n")

################################################################################
# 3. QUERIES TEMÁTICAS ESPECÍFICAS (para busca complementar)
################################################################################

cat("QUERIES TEMÁTICAS COMPLEMENTARES:\n")
cat("================================================================================\n\n")

queries_tematicas <- list(
  
  "A. Análise de Texto Etnográfico" = 
    'TITLE-ABS-KEY(("text analysis" OR "content analysis" OR "NLP" OR "topic modeling") 
     AND ("interview" OR "narrative" OR "oral history") 
     AND ("indigenous" OR "traditional" OR "community"))',
  
  "B. Mapeamento de Conhecimentos" = 
    'TITLE-ABS-KEY(("knowledge mapping" OR "knowledge graph" OR "ontology") 
     AND ("traditional knowledge" OR "indigenous knowledge" OR "ethnobotany"))',
  
  "C. Análise Espacial" = 
    'TITLE-ABS-KEY(("spatial analysis" OR "GIS" OR "remote sensing") 
     AND ("traditional" OR "indigenous") 
     AND ("land use" OR "territory"))',
  
  "D. Classificação Etnobotânica" = 
    'TITLE-ABS-KEY(("classification" OR "machine learning" OR "pattern recognition") 
     AND ("ethnobotany" OR "traditional medicine" OR "plant knowledge"))',
  
  "E. Análise de Redes Sociais" = 
    'TITLE-ABS-KEY(("social network analysis" OR "network analysis") 
     AND ("indigenous" OR "traditional knowledge" OR "knowledge exchange"))'
)

for (i in seq_along(queries_tematicas)) {
  cat(names(queries_tematicas)[i], ":\n")
  cat(queries_tematicas[[i]], "\n\n")
}

# Salvar queries temáticas
writeLines(
  paste(names(queries_tematicas), queries_tematicas, sep = "\n", collapse = "\n\n"),
  "queries_tematicas_complementares.txt"
)

################################################################################
# 4. FUNÇÃO PARA PROCESSAR ARQUIVOS QUANDO BAIXADOS
################################################################################

processar_busca_nova <- function(arquivos_bib) {
  
  cat("Processando arquivos de busca...\n")
  
  # Ler todos os arquivos
  bib_data <- lapply(arquivos_bib, function(f) {
    tryCatch({
      convert2df(file = f, dbsource = "scopus", format = "bibtex")
    }, error = function(e) {
      convert2df(file = f, dbsource = "wos", format = "bibtex")
    })
  })
  
  # Combinar
  bib_combined <- do.call(rbind, bib_data)
  
  # Remover duplicatas
  bib_unique <- bib_combined %>%
    distinct(DI, .keep_all = TRUE) %>%
    distinct(TI, .keep_all = TRUE)
  
  cat("\nESTATÍSTICAS:\n")
  cat("Total de registros: ", nrow(bib_combined), "\n")
  cat("Registros únicos: ", nrow(bib_unique), "\n")
  cat("Duplicatas removidas: ", nrow(bib_combined) - nrow(bib_unique), "\n\n")
  
  # Validação da busca
  cat("VALIDAÇÃO DA BUSCA:\n")
  cat("================================================================================\n")
  
  # Criar corpus de texto
  texto_completo <- paste(
    tolower(bib_unique$TI),
    tolower(bib_unique$AB),
    tolower(paste(bib_unique$DE, collapse = " "))
  )
  
  # Termos-chave
  termos_ml <- c("machine learning", "artificial intelligence", "deep learning", 
                 "neural network", "algorithm", "classification", "clustering")
  termos_tk <- c("traditional knowledge", "indigenous knowledge", "ethnobotany",
                 "traditional ecological knowledge", "aboriginal", "native")
  termos_ethno <- c("ethnography", "ethnographic", "participatory research",
                   "qualitative", "interview", "case study")
  
  # Calcular presença
  contagem_ml <- sum(sapply(termos_ml, function(t) sum(grepl(t, texto_completo))))
  contagem_tk <- sum(sapply(termos_tk, function(t) sum(grepl(t, texto_completo))))
  contagem_ethno <- sum(sapply(termos_ethno, function(t) sum(grepl(t, texto_completo))))
  
  cat("\nPRESENÇA DE TERMOS:\n")
  cat("Machine Learning: ", round(100*contagem_ml/nrow(bib_unique)), "%\n", sep="")
  cat("Traditional Knowledge: ", round(100*contagem_tk/nrow(bib_unique)), "%\n", sep="")
  cat("Ethnography: ", round(100*contagem_ethno/nrow(bib_unique)), "%\n\n", sep="")
  
  # Salvar corpus novo
  df2bib(bib_unique, file = "referencias_ml_etnografia_otimizado.bib")
  
  cat("Arquivo salvo: referencias_ml_etnografia_otimizado.bib\n")
  
  return(bib_unique)
}

################################################################################
# 5. VERIFICAR SE JÁ EXISTEM ARQUIVOS DE BUSCA
################################################################################

cat("\nVERIFICANDO ARQUIVOS DE BUSCA EXISTENTES...\n")

arquivos_existentes <- list.files(pattern = "(scopus|wos).*etnografia.*\\.bib$", 
                                  full.names = TRUE)

if (length(arquivos_existentes) > 0) {
  cat("Encontrados ", length(arquivos_existentes), " arquivo(s):\n")
  print(arquivos_existentes)
  
  cat("\nProcessando arquivos...\n")
  bib_novo <- processar_busca_nova(arquivos_existentes)
  
  # Comparar com corpus antigo
  if (file.exists("referencias_filtradas_tema_agroecologia_v2.bib")) {
    bib_antigo <- convert2df("referencias_filtradas_tema_agroecologia_v2.bib", 
                             dbsource = "scopus", format = "bibtex")
    
    cat("\nCOMPARAÇÃO COM CORPUS ANTERIOR:\n")
    cat("Corpus antigo: ", nrow(bib_antigo), " estudos\n")
    cat("Corpus novo: ", nrow(bib_novo), " estudos\n\n")
  }
  
} else {
  cat("\nNenhum arquivo de busca encontrado.\n")
  cat("Execute as buscas manuais conforme instruções acima.\n")
  cat("Nomeie os arquivos como: scopus_ml_etnografia.bib e wos_ml_etnografia.bib\n")
  cat("Depois rode novamente este script.\n\n")
}

################################################################################
# 6. CRIAR SCRIPT DE VALIDAÇÃO AUTOMÁTICA
################################################################################

cat("\nCRIANDO SCRIPT DE VALIDAÇÃO...\n")

script_validacao <- '
# VALIDAÇÃO RÁPIDA DO NOVO CORPUS
# Execute após baixar os arquivos .bib

library(bib2df)
library(tidyverse)

arquivos <- list.files(pattern = "(scopus|wos).*etnografia.*\\.bib$")

if (length(arquivos) == 0) {
  stop("Nenhum arquivo encontrado. Baixe primeiro os resultados das buscas.")
}

cat("Processando", length(arquivos), "arquivo(s):\\n")

# Ler arquivos
dados <- lapply(arquivos, function(f) {
  cat("  -", f, "\\n")
  bib2df(f)
})

bib_df <- bind_rows(dados) %>%
  distinct(TITLE, .keep_all = TRUE)

cat("\\nTotal de estudos únicos:", nrow(bib_df), "\\n\\n")

# Análise rápida dos primeiros 50 títulos
titulos <- tolower(bib_df$TITLE[1:min(50, nrow(bib_df))])

cat("ANÁLISE DOS PRIMEIROS 50 TÍTULOS:\\n")
cat("ML terms:", sum(grepl("machine learning|artificial intelligence|algorithm", titulos)), "\\n")
cat("TK terms:", sum(grepl("traditional|indigenous|ethnobotany", titulos)), "\\n")
cat("Ethno terms:", sum(grepl("ethnograph|qualitative|participatory", titulos)), "\\n\\n")

cat("Exemplos de títulos:\\n")
print(head(bib_df$TITLE, 10))
'

writeLines(script_validacao, "validar_busca_rapida.R")

cat("Script de validação criado: validar_busca_rapida.R\n\n")

################################################################################
# FIM
################################################################################

cat("================================================================================\n")
cat("PRÓXIMOS PASSOS:\n")
cat("================================================================================\n")
cat("1. Execute as buscas manualmente em Scopus e Web of Science\n")
cat("2. Salve os arquivos .bib na pasta DADOS\n")
cat("3. Execute novamente este script para processar os resultados\n")
cat("4. Use validar_busca_rapida.R para verificação rápida\n\n")

cat("Arquivos gerados:\n")
cat("  - query_scopus_otimizada.txt\n")
cat("  - queries_tematicas_complementares.txt\n")
cat("  - validar_busca_rapida.R\n\n")

cat("================================================================================\n")
