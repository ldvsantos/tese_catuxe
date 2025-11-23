################################################################################
# ATUALIZAR CORPUS.BIB COM BUSCA OTIMIZADA
# Data: 23 de novembro de 2025
# Objetivo: Substituir corpus atual por busca focada em ML + Etnografia + TK
################################################################################

library(bib2df)
library(bibliometrix)
library(tidyverse)

setwd("c:/Users/vidal/OneDrive/Documentos/13 - CLONEGIT/tese-catuxe/DADOS/1-ESTATISTICA/1-RSTUDIO")

cat("================================================================================\n")
cat("ATUALIZAÇÃO DO CORPUS.BIB\n")
cat("================================================================================\n\n")

################################################################################
# 1. BACKUP DO CORPUS ATUAL
################################################################################

cat("1. Criando backup do corpus atual...\n")

if (file.exists("corpus.bib")) {
  # Criar timestamp
  timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  backup_file <- paste0("corpus_backup_", timestamp, ".bib")
  
  # Copiar arquivo
  file.copy("corpus.bib", backup_file)
  
  cat("   ✓ Backup criado:", backup_file, "\n")
  
  # Analisar corpus atual
  tryCatch({
    corpus_antigo <- bib2df("corpus.bib")
    cat("   Corpus atual:", nrow(corpus_antigo), "estudos\n\n")
  }, error = function(e) {
    cat("   ⚠️ Não foi possível ler corpus antigo\n\n")
  })
} else {
  cat("   ℹ️ Nenhum corpus.bib encontrado - criando novo\n\n")
}

################################################################################
# 2. VERIFICAR SE HÁ NOVOS ARQUIVOS DE BUSCA
################################################################################

cat("2. Procurando novos arquivos de busca...\n")

# Procurar na pasta DADOS
setwd("c:/Users/vidal/OneDrive/Documentos/13 - CLONEGIT/tese-catuxe/DADOS")

# Padrões de busca
patterns <- c(
  "*ml_etnografia*.bib",
  "*scopus*2024*.bib",
  "*wos*2024*.bib", 
  "*etnografia*.bib",
  "referencias_ml_etnografia_otimizado.bib"
)

arquivos_novos <- character(0)
for (pattern in patterns) {
  encontrados <- list.files(pattern = pattern, full.names = TRUE, recursive = FALSE)
  arquivos_novos <- c(arquivos_novos, encontrados)
}

# Remover duplicatas
arquivos_novos <- unique(arquivos_novos)

# Filtrar arquivos antigos
arquivos_novos <- arquivos_novos[!grepl("backup|old|antigo", arquivos_novos, ignore.case = TRUE)]

if (length(arquivos_novos) > 0) {
  cat("   ✓ Encontrados", length(arquivos_novos), "arquivo(s):\n")
  for (arq in arquivos_novos) {
    cat("     -", basename(arq), "\n")
  }
  cat("\n")
  
  ################################################################################
  # 3. PROCESSAR E COMBINAR ARQUIVOS
  ################################################################################
  
  cat("3. Processando arquivos...\n")
  
  lista_bib <- list()
  
  for (i in seq_along(arquivos_novos)) {
    cat("   Processando:", basename(arquivos_novos[i]), "\n")
    
    tryCatch({
      # Tentar como Scopus
      bib_temp <- convert2df(file = arquivos_novos[i], 
                            dbsource = "scopus", 
                            format = "bibtex")
      lista_bib[[i]] <- bib_temp
      cat("     ✓ Lido com sucesso (Scopus):", nrow(bib_temp), "estudos\n")
    }, error = function(e1) {
      tryCatch({
        # Tentar como WoS
        bib_temp <- convert2df(file = arquivos_novos[i], 
                              dbsource = "wos", 
                              format = "bibtex")
        lista_bib[[i]] <- bib_temp
        cat("     ✓ Lido com sucesso (WoS):", nrow(bib_temp), "estudos\n")
      }, error = function(e2) {
        tryCatch({
          # Tentar com bib2df
          bib_temp <- bib2df(arquivos_novos[i])
          lista_bib[[i]] <- bib_temp
          cat("     ✓ Lido com sucesso (bib2df):", nrow(bib_temp), "estudos\n")
        }, error = function(e3) {
          cat("     ✗ Erro ao ler arquivo\n")
        })
      })
    })
  }
  
  # Remover elementos NULL
  lista_bib <- Filter(Negate(is.null), lista_bib)
  
  if (length(lista_bib) > 0) {
    # Combinar todos os dataframes
    cat("\n   Combinando datasets...\n")
    bib_combinado <- bind_rows(lista_bib)
    
    cat("   Total combinado:", nrow(bib_combinado), "estudos\n\n")
    
    ################################################################################
    # 4. REMOVER DUPLICATAS
    ################################################################################
    
    cat("4. Removendo duplicatas...\n")
    
    # Por DOI
    if ("DI" %in% names(bib_combinado)) {
      bib_unico <- bib_combinado %>%
        filter(!is.na(DI) & DI != "") %>%
        distinct(DI, .keep_all = TRUE)
      
      cat("   Únicos por DOI:", nrow(bib_unico), "\n")
    } else {
      bib_unico <- bib_combinado
    }
    
    # Por título
    if ("TI" %in% names(bib_unico)) {
      bib_unico <- bib_unico %>%
        mutate(TI_clean = tolower(trimws(TI))) %>%
        distinct(TI_clean, .keep_all = TRUE) %>%
        select(-TI_clean)
      
      cat("   Únicos por título:", nrow(bib_unico), "\n")
    }
    
    duplicatas_removidas <- nrow(bib_combinado) - nrow(bib_unico)
    cat("   Duplicatas removidas:", duplicatas_removidas, "\n\n")
    
    ################################################################################
    # 5. VALIDAÇÃO DO NOVO CORPUS
    ################################################################################
    
    cat("5. Validando qualidade do novo corpus...\n")
    
    # Criar texto para análise
    texto_titulos <- tolower(paste(bib_unico$TI, collapse = " "))
    texto_abstracts <- tolower(paste(bib_unico$AB, collapse = " "))
    texto_completo <- paste(texto_titulos, texto_abstracts)
    
    # Termos de validação
    termos_ml <- c("machine learning", "artificial intelligence", "deep learning",
                   "neural network", "algorithm", "classification", "clustering",
                   "predictive model", "data mining", "text mining")
    
    termos_tk <- c("traditional knowledge", "indigenous knowledge", "ethnobotany",
                   "traditional ecological knowledge", "local knowledge",
                   "aboriginal", "native", "ancestral knowledge")
    
    termos_ethno <- c("ethnography", "ethnographic", "participatory research",
                     "qualitative", "interview", "case study", "field research",
                     "community-based", "mixed method")
    
    # Calcular presença
    presenca_ml <- sum(sapply(termos_ml, function(t) grepl(t, texto_completo)))
    presenca_tk <- sum(sapply(termos_tk, function(t) grepl(t, texto_completo)))
    presenca_ethno <- sum(sapply(termos_ethno, function(t) grepl(t, texto_completo)))
    
    pct_ml <- round(100 * presenca_ml / nrow(bib_unico), 1)
    pct_tk <- round(100 * presenca_tk / nrow(bib_unico), 1)
    pct_ethno <- round(100 * presenca_ethno / nrow(bib_unico), 1)
    
    cat("\n")
    cat("   MÉTRICAS DE QUALIDADE:\n")
    cat("   =====================================================\n")
    cat("   Machine Learning:      ", pct_ml, "% ", 
        ifelse(pct_ml >= 60, "✓", "⚠️"), "\n", sep="")
    cat("   Traditional Knowledge: ", pct_tk, "% ",
        ifelse(pct_tk >= 70, "✓", "⚠️"), "\n", sep="")
    cat("   Ethnography:           ", pct_ethno, "% ",
        ifelse(pct_ethno >= 60, "✓", "⚠️"), "\n", sep="")
    cat("   =====================================================\n\n")
    
    # Verificar qualidade
    qualidade_ok <- (pct_ml >= 50 || pct_tk >= 50 || pct_ethno >= 50)
    
    if (qualidade_ok) {
      cat("   ✓ CORPUS APROVADO - Qualidade suficiente\n\n")
      
      ################################################################################
      # 6. SALVAR NOVO CORPUS
      ################################################################################
      
      cat("6. Salvando novo corpus...\n")
      
      # Voltar para pasta RSTUDIO
      setwd("c:/Users/vidal/OneDrive/Documentos/13 - CLONEGIT/tese-catuxe/DADOS/1-ESTATISTICA/1-RSTUDIO")
      
      # Salvar como corpus.bib
      df2bib(bib_unico, file = "corpus.bib")
      
      cat("   ✓ Corpus atualizado: corpus.bib\n")
      cat("   Total de estudos:", nrow(bib_unico), "\n\n")
      
      ################################################################################
      # 7. RELATÓRIO FINAL
      ################################################################################
      
      cat("================================================================================\n")
      cat("RELATÓRIO DE ATUALIZAÇÃO\n")
      cat("================================================================================\n\n")
      
      cat("CORPUS ANTERIOR:\n")
      if (exists("corpus_antigo")) {
        cat("  Estudos:", nrow(corpus_antigo), "\n")
        cat("  Backup:", backup_file, "\n\n")
      } else {
        cat("  Não havia corpus anterior\n\n")
      }
      
      cat("CORPUS NOVO:\n")
      cat("  Estudos:", nrow(bib_unico), "\n")
      cat("  Arquivos processados:", length(arquivos_novos), "\n")
      cat("  Duplicatas removidas:", duplicatas_removidas, "\n\n")
      
      cat("QUALIDADE:\n")
      cat("  ML:", pct_ml, "%\n")
      cat("  TK:", pct_tk, "%\n")
      cat("  Ethno:", pct_ethno, "%\n\n")
      
      if (exists("corpus_antigo")) {
        diferenca <- nrow(bib_unico) - nrow(corpus_antigo)
        cat("MUDANÇA:\n")
        cat("  Diferença:", diferenca, "estudos\n")
        cat("  Variação:", round(100 * diferenca / nrow(corpus_antigo), 1), "%\n\n")
      }
      
      cat("PRÓXIMOS PASSOS:\n")
      cat("  1. Execute diagnostico_corpus.R para análise detalhada\n")
      cat("  2. Re-execute as análises estatísticas (PCA, MCA, Cluster, etc.)\n")
      cat("  3. Compare resultados com análises anteriores\n\n")
      
      cat("================================================================================\n")
      
    } else {
      cat("   ✗ CORPUS REJEITADO - Qualidade insuficiente\n")
      cat("   Corpus não foi atualizado. Melhore a busca.\n\n")
    }
    
  } else {
    cat("\n   ✗ Nenhum arquivo válido foi processado\n\n")
  }
  
} else {
  cat("   ℹ️ Nenhum arquivo novo encontrado\n\n")
  cat("INSTRUÇÕES:\n")
  cat("================================================================================\n")
  cat("1. Execute a busca otimizada em Scopus/Web of Science\n")
  cat("2. Salve os arquivos .bib na pasta DADOS/\n")
  cat("3. Nomeie como: scopus_ml_etnografia_2024.bib ou wos_ml_etnografia_2024.bib\n")
  cat("4. Execute novamente este script\n\n")
  cat("QUERY SUGERIDA:\n")
  cat("Ver arquivo: query_scopus_otimizada.txt\n")
  cat("Ver arquivo: GUIA_EXECUTAR_BUSCA.txt\n\n")
  cat("================================================================================\n")
}

cat("\nScript finalizado.\n")
