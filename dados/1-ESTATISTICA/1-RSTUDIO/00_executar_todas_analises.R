################################################################################
# SCRIPT MESTRE - EXECUÇÃO SEQUENCIAL DE TODAS AS ANÁLISES
# Machine Learning em Etnografia e Conhecimentos Tradicionais em Agroecologia
#
# Este script executa todas as análises em sequência:
#   1. PCA (Análise de Componentes Principais)
#   2. MCA (Análise de Correspondência Múltipla)
#   3. Cluster Analysis (K-means e Hierárquico)
#   4. Network Analysis (Análise de Redes de Co-ocorrência)
#   5. Temporal Analysis (Análise de Séries Temporais)
#   6. Predictive Modeling (Modelagem Preditiva)
#
# Autor: Tese Catuxe - PPGPI
# Data: Novembro 2025
################################################################################

# Limpar ambiente
rm(list = ls())
gc()

cat("\n")
cat("================================================================================\n")
cat("SCRIPT MESTRE - ANÁLISE COMPLETA DO CORPUS BIBLIOGRÁFICO\n")
cat("Machine Learning em Etnografia e Conhecimentos Tradicionais em Agroecologia\n")
cat("================================================================================\n\n")

# Verificar se o arquivo corpus.bib existe
if (!file.exists("corpus.bib")) {
  stop("❌ ERRO: Arquivo corpus.bib não encontrado!")
}

# Definir diretório de trabalho
setwd("c:/Users/vidal/OneDrive/Documentos/13 - CLONEGIT/tese-catuxe/DADOS/1-ESTATISTICA/1-RSTUDIO")

# Variável para rastrear erros
erros <- list()

################################################################################
# 1. ANÁLISE PCA
################################################################################
cat("\n")
cat("================================================================================\n")
cat("ETAPA 1/6: ANÁLISE DE COMPONENTES PRINCIPAIS (PCA)\n")
cat("================================================================================\n")

tryCatch({
  setwd("1-PCA")
  source("01_pca_analysis.R")
  cat("\n✅ PCA concluída com sucesso!\n")
  setwd("..")
}, error = function(e) {
  cat("\n❌ ERRO na análise PCA:", conditionMessage(e), "\n")
  erros <<- c(erros, list(PCA = conditionMessage(e)))
  setwd("..")
})

################################################################################
# 2. ANÁLISE MCA
################################################################################
cat("\n")
cat("================================================================================\n")
cat("ETAPA 2/6: ANÁLISE DE CORRESPONDÊNCIA MÚLTIPLA (MCA)\n")
cat("================================================================================\n")

tryCatch({
  setwd("2-MCA")
  source("02_mca_analysis.R")
  cat("\n✅ MCA concluída com sucesso!\n")
  setwd("..")
}, error = function(e) {
  cat("\n❌ ERRO na análise MCA:", conditionMessage(e), "\n")
  erros <<- c(erros, list(MCA = conditionMessage(e)))
  setwd("..")
})

################################################################################
# 3. ANÁLISE DE CLUSTERS
################################################################################
cat("\n")
cat("================================================================================\n")
cat("ETAPA 3/6: ANÁLISE DE CLUSTERS (K-MEANS E HIERÁRQUICO)\n")
cat("================================================================================\n")

tryCatch({
  setwd("3-CLUSTERS")
  source("03_cluster_analysis.R")
  cat("\n✅ Cluster Analysis concluída com sucesso!\n")
  setwd("..")
}, error = function(e) {
  cat("\n❌ ERRO na análise de Clusters:", conditionMessage(e), "\n")
  erros <<- c(erros, list(Clusters = conditionMessage(e)))
  setwd("..")
})

################################################################################
# 4. ANÁLISE DE REDE
################################################################################
cat("\n")
cat("================================================================================\n")
cat("ETAPA 4/6: ANÁLISE DE REDES DE CO-OCORRÊNCIA\n")
cat("================================================================================\n")

tryCatch({
  setwd("4-NETWORK")
  source("04_network_analysis.R")
  cat("\n✅ Network Analysis concluída com sucesso!\n")
  setwd("..")
}, error = function(e) {
  cat("\n❌ ERRO na análise de Redes:", conditionMessage(e), "\n")
  erros <<- c(erros, list(Network = conditionMessage(e)))
  setwd("..")
})

################################################################################
# 5. ANÁLISE TEMPORAL
################################################################################
cat("\n")
cat("================================================================================\n")
cat("ETAPA 5/6: ANÁLISE DE SÉRIES TEMPORAIS (2010-2025)\n")
cat("================================================================================\n")

tryCatch({
  setwd("5-TEMPORAL")
  source("05_temporal_analysis.R")
  cat("\n✅ Temporal Analysis concluída com sucesso!\n")
  setwd("..")
}, error = function(e) {
  cat("\n❌ ERRO na análise Temporal:", conditionMessage(e), "\n")
  erros <<- c(erros, list(Temporal = conditionMessage(e)))
  setwd("..")
})

################################################################################
# 6. MODELAGEM PREDITIVA
################################################################################
cat("\n")
cat("================================================================================\n")
cat("ETAPA 6/6: MODELAGEM PREDITIVA\n")
cat("================================================================================\n")

tryCatch({
  setwd("6-PREDICTIVE")
  source("06_predictive_modeling.R")
  cat("\n✅ Predictive Modeling concluída com sucesso!\n")
  setwd("..")
}, error = function(e) {
  cat("\n❌ ERRO na Modelagem Preditiva:", conditionMessage(e), "\n")
  erros <<- c(erros, list(Predictive = conditionMessage(e)))
  setwd("..")
})

################################################################################
# RELATÓRIO FINAL
################################################################################
cat("\n")
cat("================================================================================\n")
cat("RESUMO DA EXECUÇÃO\n")
cat("================================================================================\n\n")

if (length(erros) == 0) {
  cat("✅ TODAS AS ANÁLISES FORAM CONCLUÍDAS COM SUCESSO!\n\n")
  cat("📁 Arquivos gerados:\n")
  cat("   - 1-PCA: pca_*.png, pca_*.csv, pca_relatorio.txt\n")
  cat("   - 2-MCA: mca_*.png, mca_*.csv, mca_relatorio.txt\n")
  cat("   - 3-CLUSTERS: cluster_*.png, cluster_*.csv, cluster_relatorio.txt\n")
  cat("   - 4-NETWORK: network_*.png, network_*.graphml, network_relatorio.txt\n")
  cat("   - 5-TEMPORAL: temporal_*.png, temporal_*.csv, temporal_relatorio.txt\n")
  cat("   - 6-PREDICTIVE: model_*.png, model_*.csv, model_relatorio.txt\n\n")
} else {
  cat("⚠️ ALGUMAS ANÁLISES APRESENTARAM ERROS:\n\n")
  for (analise in names(erros)) {
    cat(sprintf("   - %s: %s\n", analise, erros[[analise]]))
  }
  cat("\n")
}

cat("================================================================================\n")
cat("EXECUÇÃO FINALIZADA!\n")
cat("================================================================================\n")

# Resetar diretório de trabalho
setwd("c:/Users/vidal/OneDrive/Documentos/13 - CLONEGIT/tese-catuxe/DADOS/1-ESTATISTICA/1-RSTUDIO")
